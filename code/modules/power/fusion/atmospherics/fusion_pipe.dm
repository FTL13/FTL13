/obj/machinery/atmospherics/pipe/containment
	icon = 'icons/obj/fusion_engine/containment_pipe.dmi'
	var/icon_overlay
	density = 1
	can_buckle = 1
	climbable = TRUE
	burn_state = LAVA_PROOF
	
	//Mod vars
	var/list/mods
	var/mod_slots = 3
	var/fusion_machine = "pipe"
	
	//Balancing vars
	var/radiation_portion = 0.5 //What portion of the energy released is radiation
	var/thermal_portion = 0.5 //Keep these 2 vars equal to 1
	var/energy_multiplier = 1000 //Overall energy output multiplier
	
	//Upgradeable vars
	var/max_durability = 1000
	var/max_pressure = 100 //Calculated based on speed of internal plasma and upgrades
	var/internal_hr = 15000 //How hot the fusion plasma can be before damage, hr = heat resistance
	var/external_hr = 200 //How hot the containment room can be before damage
	var/auto_vent = 0 //An upgrade sets this to 1 so waste gases are automaticaly ejected

	//Process vars
	var/durability = 1000
	var/speed = 120 //Starts at a little over 120 so pipes dont take damage the first time they get fusion plasma
	var/external_temperature //Record keeping
	var/last_damage_chance //Record keeping
	
	//Hugbox stuff
	var/no_damage = 0
	
	//Linked objects
	var/list/master = list()
	var/obj/machinery/fusion/injector/input
	
	//Pipe vars
	volume = 1000
	
/obj/machinery/atmospherics/pipe/containment/New()
	..()
	if(map_ready)
		initialize()
	
/obj/machinery/atmospherics/pipe/containment/initialize()
	//linking code is in the injector and electromagnet code
	return(..())
	
/obj/machinery/atmospherics/pipe/containment/Destroy()
	if(input)
		input.fusion_pipe = null
		input = null
	for(var/obj/machinery/fusion/electromagnet/M in master)
		M.pipes -= src
	master = null
	..()
			
/obj/machinery/atmospherics/pipe/containment/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user,icon,icon,I))
		return
	if(default_change_direction_wrench(user,I))
		return
	if(default_deconstruction_crowbar(I))
		return
	if(istype(I,/obj/item/weapon/fusion_mod))
		switch(add_part(I))
			if(0)
				user << "<span class='caution'>You install the mod.</span>"
			if(1)
				user << "<span class='caution'>This component has no slots for mods left!</span>"
			if(2)
				user << "<span class='caution'>This mod seems broken, you may want to reconstruct the engine component.</span>"
			if(4)
				user << "<span class='caution'>This mod is incompatible with an instaled mod.</span>"
			if(8)
				user << "<span class='caution'>This mod is incompatible with this machine.</span>"
		return
	..()
	
/obj/machinery/atmospherics/pipe/containment/proc/add_part(I)
	var/obj/item/weapon/fusion_mod/M = I
	if(mods.len >= mod_slots)
		return 1 //Failure code for full slots
	if(M.machine != fusion_machine)
		return 8 //Failure code for incorrect machine type
	mods += M
	return(RefreshParts())
	
/obj/machinery/atmospherics/pipe/containment/RefreshParts()
	var/list/initialized //mods that succeded in getting added
	var/list/failed //mods that are incompatible with the machine
	var/i = 0
	while(mods.len > 0 && i < 10)
		for(var/obj/item/weapon/fusion_mod/M in mods)
			switch(M.get_effects(src))
				if(0)
					failed += M
					mods -= M
				if(1)
					initialized += M
					mods -= M
				if(2)
					continue
		i++
	failed += mods
	mods = initialized
	if(i == 10)
		message_admins("<span class='warning'>An engine mod arangement failed to initialize. Failed:[failed], Succeded:[mods].</span>")
		return(2) //Failure code for badly coded mod
	if(failed.len > 0)
		return(4) //Failure code for incompatible mods
	return(0) //No failure
	
/obj/machinery/atmospherics/pipe/containment/can_be_node(obj/machinery/atmospherics/pipe/containment/target)
	if(!istype(target))
		return 0
	if(target.initialize_directions & get_dir(target,src))
		return 1
		
/obj/machinery/atmospherics/pipe/containment/hide()
	return
	
/obj/machinery/atmospherics/pipe/containment/GetInitDirections()
	return ..() | initialize_directions
	
/obj/machinery/atmospherics/pipe/containment/update_icon()
	..()
	var/datum/gas_mixture/pipe_air = return_air()
	if(!pipe_air) //No one likes runtimes
		return
	var/pressure = pipe_air.return_pressure()
	
	cut_overlays()
	
	if(pressure == 0)
		//overlay = none
	else if(pressure < 100)
		add_overlay(icon_overlay + "low")
	else if(pressure < 500)
		add_overlay(icon_overlay + "medium")
	else if(pressure >= 500)
		add_overlay(icon_overlay + "high")
	/*	
	if(durability == max_durability)
		//icon_state = pristine
	else if(durability/max_durability > 0.9)
		//icon_state = used
	else if(durability/max_durability > 0.5)
		//icon_state = worn
	else if(durability == 0)
		//icon_state = destroyed
		
	if(auto_vent)
		//overlay = vents
	*/
	return
	
/obj/machinery/atmospherics/pipe/atmosinit()
	..()
	return
	
/obj/machinery/atmospherics/pipe/containment/proc/dump_waste()
	//gas ejections stuffs
	return
	
/obj/machinery/atmospherics/pipe/containment/proc/containment_failure()
	world << "<span class='warning'>OH SHIT AN UNHANDLED EVENT HAPPENED, THE BUGS ARE HERE, RUN!!</span>"
	Destroy()
	//todo
	return
	
/obj/machinery/atmospherics/pipe/containment/process_atmos()
	var/enviroment_temperature = 0
	var/datum/gas_mixture/pipe_air = return_air()
	var/list/cached_gases = pipe_air.gases
	var/pressure = pipe_air.return_pressure()
	var/turf/T = loc
	
	if(istype(T))
		if(T.blocks_air)
			enviroment_temperature = T.temperature
		else
			var/turf/open/OT = T
			enviroment_temperature = OT.GetTemperature()
	else
		enviroment_temperature = T.temperature
	external_temperature = enviroment_temperature //Saving the value here so console doesnt have to calculate it seperately
	
	if(!pressure)
		return //Why calculate anything if there's no fusion plasma?
		
	//Acceleration handling
	if(master)
		for(var/obj/machinery/fusion/electromagnet/M in master)
			if(!M.power)
				continue
			if(M.speed > speed && M.torque > pressure)
				speed += M.speed
			else
				speed += M.speed * (M.torque / pressure)

	//Damage handling
	if((enviroment_temperature > external_hr || pipe_air.temperature > internal_hr || speed < 100) && !no_damage)
		var/external_chance = 0
		if(!istype(T, /turf/open/space))
			external_chance = round((enviroment_temperature-external_hr) / external_hr) ^ 2 //If enviroment heat is over external_hr, chance for damage (exponential)
		var/internal_chance = min(round((pipe_air.temperature - internal_hr) / 10), 0) //If internal heat is over internal_hr, chance for damage (flat)
		var/speed_chance = min(100 - speed, 0) //If speed is under 100, chance for damage (flat)
		var/damage_chance = (external_chance + internal_chance + speed_chance) * (pressure * min(speed/150,1) / max_pressure) //Lower speed and pressure reduces damage
		if(damage_chance > 100)
			durability -= damage_chance - 100
		else
			durability -= prob(damage_chance)
		if(durability <= 0)
			containment_failure()
			
	//Reaction handling
	if(cached_gases["fusion_plasma"] && cached_gases["fusion_plasma"][MOLES])
		var/consumed_fuel = (pressure*pipe_air.temperature) * ((speed-100)/100) //Speeds under 200 decrease reaction rate. Needs balancing
		consumed_fuel = min(consumed_fuel, cached_gases["fusion_plasma"][MOLES]) //Don't use more fuel than you have
		var/energy_released = energy_multiplier * consumed_fuel
		
		pipe_air.assert_gas("hydrogen")
		pipe_air.assert_gas("plasma")
		cached_gases["fusion_plasma"] -= consumed_fuel
		cached_gases["hydrogen"] += consumed_fuel * (thermal_portion*0.75)
		cached_gases["plasma"] += consumed_fuel * (thermal_portion*0.25)
		pipe_air.temperature += (energy_released*thermal_portion)/pipe_air.heat_capacity() //Needs balancing
		if(auto_vent)
			dump_waste()
		pipe_air.garbage_collect()
		
		for(var/obj/machinery/power/rad_collector/R in rad_collectors)
			if(get_dist(R, src) <= 15)
				R.receive_pulse(energy_released*radiation_portion) //Maybe needs balancing?
				
	speed -= speed/10
	return
			
/obj/machinery/atmospherics/pipe/containment/process()
	if(!parent)
		return //machines subsystem fires before atmos is initialized so this prevents race condition runtimes
		
	for(var/obj/machinery/atmospherics/pipe/containment/P in nodes)
		if(P.speed >= speed)
			continue
		var/S = (P.speed+speed)/2
		P.speed = S
		speed = S
	
	update_icon()
		
		