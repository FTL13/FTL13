/obj/machinery/fusion/injector //The injector is must be constructed as part of the containment pipe loop
	name = "Fusion Plasma Injector"
	desc = "A block of machinery used in heating elements to form a plasma."
	icon = 'icons/obj/fusion_engine/injector.dmi'
	icon_state = "off"
	anchored = 1
	density = 1
	pixel_x = -32
	pixel_y = -32
	
	//Mod vars
	fusion_machine = "injector"
	
	//Balance vars
	var/bullet_energy = 2 //How much energy it receives from emitters
	
	//Upgradeable vars
	var/fuel_efficiency = 1 //Fuel use multiplier
	var/gas_efficiency = 1 //Hydrogen use multiplier
	var/yield = 1 //How much fusion plasma can be made in one unit of time
	var/heat_multiplier = 1
	var/max_energy = 300 //Maximum amount of stored energy
	
	//Process vars
	var/remaining = 0 //How much fusion plasma remains to be made from this unit of fuel
	var/energy = 0
	var/output_multiplier = 1 //Player controled output throttle
	
	//Hugbox stuff
	var/use_fuel = 1
	var/use_energy = 1
	var/use_hydrogen = 1
	
	//Linked objects
	var/obj/machinery/atmospherics/components/unary/terminal/atmos_terminal
	var/obj/machinery/atmospherics/pipe/containment/simple/fusion_pipe
	
/obj/machinery/fusion/injector/New()
	..()
	var/obj/item/weapon/circuitboard/machine/B = new /obj/item/weapon/circuitboard/machine/fusion_injector(null)
	B.apply_default_parts(src)
	if(!atmos_terminal)
		atmos_terminal = new(loc)
		atmos_terminal.master = src
	if(map_ready)
		initialize()
		
/obj/machinery/fusion/injector/initialize()
	if(!fusion_pipe) //Check only directly adjacent tiles for a pipe then align yourself to it
		var/turf/T
		
		for(var/D in cardinal)
			T = get_step(src,D)
			if(!istype(T))
				continue
			var/TC = T.GetAllContents()
			for(var/obj/machinery/atmospherics/pipe/containment/simple/P in TC)
				fusion_pipe = P
				dir = D
		fusion_pipe.layer = 0.1
		fusion_pipe.master += src
		update_icon()
	..()
	
/obj/machinery/fusion/injector/update_icon()
	if(dir == NORTH || dir == SOUTH)
		bound_height = 64
		bound_width = 32
	else //dir == EAST || dir == WEST
		bound_height = 32
		bound_width = 64
	switch(dir)
		if(EAST)
			bound_x = -32
			bound_y = 0
			atmos_terminal.change_dir(NORTH)
		if(NORTH)
			bound_x = 0
			bound_y = -32
			atmos_terminal.change_dir(WEST)
		if(WEST)
			bound_x = 0
			bound_y = 0
			atmos_terminal.change_dir(SOUTH)
		if(SOUTH)
			bound_x = 0
			bound_y = 0
			atmos_terminal.change_dir(EAST)
		
/obj/item/weapon/circuitboard/machine/fusion_injector
	name = "circuit board (Fusion Engine Injector)"
	build_path = /obj/machinery/fusion/injector
	origin_tech = "magnets=3;programming=3;engineering=2"
	req_components = list(
		/obj/item/weapon/stock_parts/capacitor = 1,
		/obj/item/weapon/stock_parts/micro_laser = 1,
		/obj/item/weapon/stock_parts/manipulator = 1)
		
/obj/machinery/fusion/injector/Destroy()
	qdel(atmos_terminal)
	atmos_terminal = null
	fusion_pipe = null
	..()
	
/obj/machinery/fusion/injector/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user,icon,icon,I))
		return
	if(default_deconstruction_crowbar(I))
		return
		
	if(panel_open)
		if(istype(I, /obj/item/device/multitool))
			var/obj/item/device/multitool/M = I
			M.buffer = src
			user << "<span class='caution'>You save the data in the [I.name]'s buffer.</span>"
			return 1
	if(istype(I, /obj/item/weapon/fuel_cell))
		var/obj/item/weapon/fuel_cell/F = I
		remaining += F.amount
		qdel(F)
		return
	..()
	
/obj/machinery/fusion/injector/toggle_power()
	..()
	
/obj/machinery/fusion/injector/proc/set_output(O)
	if(O > 100)
		O = 100
	else if(O < 0)
		O = 0
	O /= 100
	output_multiplier = O
		
/obj/machinery/fusion/injector/proc/terminal_process_atmos() //I really need to rewrite a lot of this
	if(!fusion_pipe || !power)
		return
		
	var/datum/gas_mixture/air1 = atmos_terminal.AIR1
	var/list/cached_gases = air1.gases
	
	var/datum/gas_mixture/containment_pipe_air = fusion_pipe.return_air()
	var/list/containment_cached_gases = containment_pipe_air.gases
	
	if(atmos_terminal.NODE1 && atmos_terminal.AIR1)
		/*
		Since yield is how much fusion plasma is made in one tick, and fusion plasma is made of 75% hydrogen and 25% 'fuel'
		calculations have to be done if we dont have enough hydrogen, fuel, or energy to create the full yield
		*/
		air1.assert_gas("hydrogen")
		containment_pipe_air.assert_gas("fusion_plasma")
		if(cached_gases["hydrogen"][MOLES] != 0 && energy != 0 && remaining != 0) //If any of them are 0 then we can't make fusion plasma
			var/fuel_use = yield * 0.25 * output_multiplier //Fuel use is how much fuel gets used in the ideal scenario
			var/output
			
			if(!use_fuel || !use_energy) //Hugbox code, give self energy/fuel to cover the running costs
				if(!use_fuel)
					remaining += fuel_use
				if(!use_energy)
					energy += yield

			/*
			Since we use the full yield of energy to create fusion plasma, we need to make sure that fuel_use * 4 <= energy
			Since we use 3/4 the yield of hydrogen to create fusion plasma, we need to make sure that fuel_use * 3 <= hydrogen
			There's probably a better way to do this that's more easily read
			*/
			fuel_use = min(fuel_use,remaining,energy/4,cached_gases["hydrogen"][MOLES]/3)
			
			//Now that fuel_use is possibly scaled down to deal with not enough of some resource, we determine the rest
			remaining -= fuel_use
			output = fuel_use * 4
			energy -= output
			if(use_hydrogen)
				cached_gases["hydrogen"][MOLES] -= fuel_use * 3 * gas_efficiency * output_multiplier
			
			containment_cached_gases["fusion_plasma"][MOLES] += output * fuel_efficiency 
			containment_pipe_air.temperature += (output * 100)/containment_pipe_air.heat_capacity() * heat_multiplier //Needs balancing
		
		//If it contains anything other than hydrogen, eject it
		if(cached_gases.len > 1)
			var/hydrogen = cached_gases["hydrogen"][MOLES] //don't eject the hydrogen
			cached_gases["hydrogen"][MOLES] = 0
			var/datum/gas_mixture/temp_air = air1.remove(air1.total_moles())
			var/turf/T = get_turf(src)
			T.assume_air(temp_air)
			air_update_turf()
			air1.assert_gas("hydrogen")
			cached_gases["hydrogen"][MOLES] = hydrogen
			air1.garbage_collect()
			
/obj/machinery/fusion/injector/bullet_act(obj/item/projectile/Proj)
	if(Proj.flag != "bullet")
		energy += Proj.damage * bullet_energy
		if(energy > max_energy)
			energy = max_energy
	else
		..()