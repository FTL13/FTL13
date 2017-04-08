/obj/machinery/fusion/injector //The injector is must be constructed as part of the containment pipe loop
	name = "Fusion Plasma Injector"
	desc = "A block of machinery used in heating elements to form a plasma."
	icon = 'icons/obj/fusion_engine/injector.dmi'
	icon_state = "off"
	anchored = 1
	density = 1
	pixel_x = -32
	pixel_y = -32
	
	//Upgradeable vars
	var/fuel_efficiency = 1 //Fuel use multiplier
	var/gas_efficiency = 1 //Hydrogen use multiplier
	var/yield = 0 //How much fusion plasma can be made in one unit of time
	var/heat_multiplier = 1
	
	//Process vars
	var/remaining = 0 //How much fusion plasma remains to be made from this unit of fuel
	var/energy = 0
	
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
	
	initialize()
		
/obj/machinery/fusion/injector/initialize()
	if(!atmos_terminal)
		atmos_terminal = new(loc)
	if(!fusion_pipe)
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
		update_icon()
	..()
	
/obj/machinery/fusion/injector/update_icon()
	if(dir == NORTH || dir == SOUTH)
		bound_height = 64
		bound_width = 32
	else //dir == EAST || dir == WEST
		bound_height = 32
		bound_width = 64
	if(dir == EAST)
		bound_x = -32
		bound_y = 0
	if(dir == NORTH)
		bound_x = 0
		bound_y = -32
	if(dir == WEST)
		bound_x = 0
		bound_y = 0
	if(dir == SOUTH)
		bound_x = 0
		bound_y = 0
		
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
	//if(default_deconstruction_screwdriver(user, 'stage1', 'stage2', I))
	//	return
	//if(default_deconstruction_crowbar(I))
	//	return
		
	if(panel_open)
		if(istype(I, /obj/item/device/multitool))
			var/obj/item/device/multitool/M = I
			M.buffer = src
			user << "<span class='caution'>You save the data in the [I.name]'s buffer.</span>"
			return 1
	else if(istype(I, /obj/item/weapon/fuel_cell))
		var/obj/item/weapon/fuel_cell/F = I
		remaining += F.amount
		qdel(F)
	..()
		
/obj/machinery/fusion/injector/process_atmos()
	if(!atmos_terminal || !fusion_pipe)
		return
		
	var/datum/gas_mixture/air1 = atmos_terminal.AIR1
	var/list/cached_gases = air1.gases
	
	var/datum/gas_mixture/containment_pipe_air = fusion_pipe.return_air()
	var/list/containment_cached_gases = containment_pipe_air.gases
	
	if(atmos_terminal.NODE1 && atmos_terminal.AIR1)
		if("hydrogen" in cached_gases && cached_gases["hydrogen"][MOLES] && cached_gases["hydrogen"][MOLES] && energy != 0 && remaining != 0) //Check if it has hydrogen, power, and fuel
			var/fuel_use = yield * 0.25 //Fusion plasma is made of 25% [plasma?phoron?mcguffins?]
			var/O
			
			if(!use_fuel || !use_energy) //Hugbox code
				if(!use_fuel)
					remaining += fuel_use
				if(!use_energy)
					energy += yield
			if(use_hydrogen)
				cached_gases["hydrogen"][MOLES] -= yield * 0.75 * gas_efficiency //Fusion plasma is made of 75% hydrogen
				
				
			if(fuel_use > remaining && remaining < energy) //If not enough fuel, use the last of it
				energy -= remaining
				O = remaining * 4
				remaining = 0
			else if(fuel_use < remaining && yield < energy) //Standard fare, make as much as yield allows
				energy -= yield
				remaining -= fuel_use
				O = yield
			else if(yield > energy && energy < remaining) //If not enough energy, use the last of it
				O = energy
				remaining -= energy
				energy = 0
			else
				message_admins("<span class='warning'>Unhandled fuel consumption. Energy:[energy], Remaining:[remaining], Yield:[yield]. Yell at ninjanomnom to fix it</span>")
			containment_cached_gases["fusion_plasma"][MOLES] += O * fuel_efficiency 
			containment_pipe_air.temperature += (O * 100)/containment_pipe_air.heat_capacity() * heat_multiplier //Needs balancing
		
		//If it contains anything other than hydrogen, eject it
		air1.assert_gas("hydrogen")
		if(cached_gases.len > 1)
			var/hydrogen = cached_gases["hydrogen"][MOLES] //don't eject the hydrogen
			cached_gases["hydrogen"][MOLES] = 0
			var/datum/gas_mixture/temp_air = air1.remove(air1.total_moles())
			var/turf/T = get_turf(src)
			T.assume_air(temp_air)
			air_update_turf()
			cached_gases["hydrogen"][MOLES] = hydrogen
			air1.garbage_collect()