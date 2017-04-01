/obj/machinery/fusion/injector //The injector is must be constructed as part of the containment pipe loop
	name = "Fusion Plasma Injector"
	desc = "A block of machinery used in heating elements to form a plasma."
	icon = 'icons/obj/fusion_engine/injector.dmi'
	icon_state = "off"
	density = 1
	bound_width = 96
	bound_height = 32
	
	//Upgradeable vars
	var/fuel_efficiency = 0 //How much fusion plasma can be made from one unit of fuel
	var/yield = 0 //How much fusion plasma can be made in one unit of time
	
	//Process vars
	var/remaining = 0 //How much fusion plasma remains to be made from this unit of fuel
	var/energy = 0
	
	//Linked objects
	var/obj/machinery/atmospherics/components/unary/terminal/atmos_terminal
	var/obj/machinery/atmospherics/pipe/containment/simple/fusion_pipe
	
/obj/machinery/fusion/injector/New()
	..()
	if(!atmos_terminal)
		atmos_terminal = new(loc)
	if(!fusion_pipe)
		fusion_pipe = new(get_step(src, WEST))
		fusion_pipe.dir = NORTH
		fusion_pipe.input = src
	if(map_ready)
		initialize()
		
/obj/machinery/fusion/injector/Destroy()
	qdel(atmos_terminal)
	atmos_terminal = null
	qdel(fusion_pipe)
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
			
	else
		return ..()
		
/obj/machinery/fusion/injector/process_atmos()
	var/datum/gas_mixture/air1 = atmos_terminal.AIR1
	var/list/cached_gases = air1.gases
	
	if(atmos_terminal.NODE1 && atmos_terminal.AIR1)
		if("hydrogen" in cached_gases && cached_gases["hydrogen"][MOLES] && cached_gases["hydrogen"][MOLES] && energy != 0 && remaining != 0)
			cached_gases["hydrogen"][MOLES] -= yield * 0.75
			var/datum/gas_mixture/containment_pipe_air = fusion_pipe.return_air()
			var/list/containment_cached_gases = containment_pipe_air.gases
			var/O
			if(remaining == 0 || energy == 0)
				O = 0
			if(yield > remaining && remaining < energy)
				energy -= remaining
				O = remaining
				remaining = 0
			if(yield < remaining && yield < energy)
				energy -= yield
				remaining -= yield
				O = yield
			if(yield > energy && energy < remaining)
				O = energy
				remaining -= energy
				energy = 0
			containment_cached_gases["fusion_plasma"][MOLES] += O
			containment_pipe_air.temperature += (O * 100)/containment_pipe_air.heat_capacity() //Needs balancing
			//add fusion plasma to the containment pipe here
			
		air1.assert_gas("hydrogen")
		if(cached_gases.len > 1) //If it contains anything other than hydrogen, eject it
			var/hydrogen = cached_gases["hydrogen"][MOLES] //don't eject the hydrogen
			cached_gases["hydrogen"][MOLES] = 0
			var/datum/gas_mixture/temp_air = air1.remove(air1.total_moles())
			var/turf/T = get_turf(src)
			T.assume_air(temp_air)
			air_update_turf()
			cached_gases["hydrogen"][MOLES] = hydrogen
			air1.garbage_collect()
			
			