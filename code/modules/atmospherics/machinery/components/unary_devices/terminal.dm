/obj/machinery/atmospherics/components/unary/terminal
	invisibility = INVISIBILITY_ABSTRACT
	var/obj/master
	dir = SOUTH

/obj/machinery/atmospherics/components/unary/terminal/Destroy()
	if(master == null)
		return QDEL_HINT_LETMELIVE
	return ..()

/obj/machinery/atmospherics/components/unary/terminal/singularity_pull()
	return

/obj/machinery/atmospherics/components/unary/terminal/singularity_act()
	return 0

/obj/machinery/atmospherics/components/unary/terminal/proc/change_dir(direction)
	dir = direction
	SetInitDirections()
	var/obj/machinery/atmospherics/node = NODE1
	if(node)
		node.disconnect(src)
		NODE1 = null
	nullifyPipenet(PARENT1)

	atmosinit()
	node = NODE1
	if(node)
		node.atmosinit()
		node.addMember(src)
	build_network()
	return

//Dumps percentage% gas from AIR1 that isn't in exceptions. Percentage is a number from 0 to 1.
/obj/machinery/atmospherics/components/unary/terminal/proc/dump_gas(var/list/exceptions, var/percentage)
	var/datum/gas_mixture/air = AIR1
	var/list/cached_gases = air.gases
	if(exceptions && exceptions.len)
		for(var/gas_name in exceptions) //exceptions is an associative list with values at 0
			air.assert_gas(gas_name)
			exceptions[gas_name] = cached_gases[gas_name][MOLES]
			cached_gases[gas_name][MOLES] = 0

		if(cached_gases.len == exceptions.len) //We've asserted all the exception gases, if those are the only gases why do anything.
			air.garbage_collect()
			return FALSE

	var/total_moles = air.total_moles()
	var/datum/gas_mixture/temp_air = air.remove(max(total_moles * percentage, min(total_moles, 1))) //Removes at least 1 mole unless less than 1 mole remaining. If so remove all.
	var/turf/T = get_turf(src)
	T.assume_air(temp_air)
	air_update_turf()

	if(exceptions && exceptions.len)
		for(var/gas_name in exceptions)
			air.assert_gas(gas_name)
			cached_gases[gas_name][MOLES] = exceptions[gas_name]

	air.garbage_collect()

	return TRUE

/obj/machinery/atmospherics/components/unary/terminal/process_atmos()
	. = ..()
	if(master)
		master:terminal_process_atmos(src) //ugh, why :