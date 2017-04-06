/obj/machinery/atmospherics/pipe/containment
	icon = 'icons/obj/fusion_engine/containment_pipe.dmi'
	var/icon_overlay
	density = 1
	can_buckle = 0
	burn_state = LAVA_PROOF
	
	//Balancing vars
	var/radiation_portion = 0.5 //What portion of the energy released is radiation
	var/thermal_portion = 0.5 //Keep these 2 vars equal to 1
	var/energy_multiplier = 1000 //Overall energy output multiplier
	
	//Upgradeable vars
	var/max_durability = 1000
	var/max_pressure = 0 //Calculated based on speed of internal plasma and upgrades
	var/internal_hr = 15000 //How hot the fusion plasma can be before damage, hr = heat resistance
	var/external_hr = 40 //How hot the containment room can be before damage
	var/auto_vent = 0 //An upgrade sets this to 1 so waste gases are automaticaly ejected

	//Process vars
	var/durability = 1000
	var/speed = 0
	
	//Linked objects
	var/list/master
	var/obj/machinery/fusion/injector/input
	
	//Pipe vars
	volume = 1000
	
/obj/machinery/atmospherics/pipe/containment/New()
	for(var/obj/machinery/fusion/electromagnet/M in oview(1,src))
		master += M
	..()
	
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
	var/datum/gas_mixture/pipe_air = return_air()
	var/pressure = pipe_air.gases
	
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
	
/obj/machinery/atmospherics/pipe/containment/proc/dump_waste()
	//gas ejections stuffs
	return
	
/obj/machinery/atmospherics/pipe/containment/proc/containment_failure()
	world << "<span class='warning'>OH SHIT AN UNHANDLED EVENT HAPPENED, THE BUGS ARE HERE, RUN!!</span>"
	qdel(src)
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
		
	if(master.len > 0)
		for(var/obj/machinery/fusion/electromagnet/M in master)
			if(M.speed > speed && M.torque > pressure)
				speed += M.speed
			else
				speed += M.speed / (M.torque / pressure)
		
	if(enviroment_temperature > external_hr || pipe_air.temperature > internal_hr || speed < 100)
		var/external_chance = 0
		if(!istype(T, /turf/open/space))
			external_chance = round(enviroment_temperature / external_hr) ^ 2 //If enviroment heat is double external_hr, chance for damage (exponential)
		var/internal_chance = min(round((pipe_air.temperature - internal_hr) / 10), 0) //If internal heat is over internal_hr, chance for damage (flat)
		var/speed_chance = min(100 - speed, 0) //If speed is under 100, chance for damage (flat)
		var/damage_chance = (external_chance + internal_chance + speed_chance) * (pressure * min(speed/150,1) / max_pressure) //Lower speed and pressure reduces damage
		if(damage_chance > 100)
			durability -= damage_chance - 100
		else
			durability -= prob(damage_chance)
		if(durability <= 0)
			containment_failure()
			
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
	//if nearby pipes are lower in speed, share speed here
			
/obj/machinery/atmospherics/pipe/containment/process()
	if(!parent)
		return //machines subsystem fires before atmos is initialized so this prevents race condition runtimes
		
	//var/datum/gas_mixture/pipe_air = return_air()
	//var/pressure = pipe_air.return_pressure()
	
	update_icon()
		
		