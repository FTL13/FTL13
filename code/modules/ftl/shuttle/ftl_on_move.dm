/************************************Area move procs************************************/

/area/shuttle/ftl/space/beforeShuttleMove()
	. = ..()
	if(. & MOVE_AREA)
		. |= MOVE_CONTENTS

/************************************Machinery move procs************************************/

/obj/machinery/ftl_shieldgen/beforeShuttleMove(turf/newT, rotation, move_mode) //Pointless nowadays
	. = ..()
	if(is_active())
		drop_physical()

/obj/machinery/ftl_shieldgen/afterShuttleMove(list/movement_force, shuttle_dir, shuttle_preferred_direction, move_dir)
	. = ..()
	if(is_active())
		raise_physical()

/************************************Misc FTL move procs************************************/

/obj/docking_port/mobile/fob/beforeShuttleMove(turf/newT, rotation, move_mode)
	. = ..()
	previous_dock = get_docked()

/obj/docking_port/mobile/fob/afterShuttleMove(list/movement_force, shuttle_dir, shuttle_preferred_direction, move_dir)
	. = ..()
	if(!istype(get_docked(),/obj/docking_port/stationary/transit))//Keep the planet loaded, don't bother if its transit a transit dock
		var/obj/docking_port/stationary/fob/destination_dock = get_docked()
		var/datum/planet/planet = destination_dock.current_planet
		if(planet.no_unload_reason == "")
			planet.no_unload_reason = unload_marker
		else if(planet.no_unload_reason == "FOB SHUTTLE" || planet.no_unload_reason == "CARGO SHUTTLE")
			if(planet.no_unload_reason != unload_marker)
				planet.no_unload_reason = "BOTH SHUTTLES"

	//Unload the planet
	var/obj/docking_port/stationary/fob/old_dock = previous_dock
	if(istype(old_dock,/obj/docking_port/stationary/transit))
		return
	if(old_dock.current_planet)
		var/datum/planet/old_planet = old_dock.current_planet
		if(old_planet.no_unload_reason == unload_marker) //same as us, safe to unmark
			old_planet.no_unload_reason = ""
		else if(old_planet.no_unload_reason == "BOTH SHUTTLES")
			if(unload_marker == "FOB_SHUTTLE")
				old_planet.no_unload_reason = "CARGO SHUTTLE"
			else
				old_planet.no_unload_reason = "FOB SHUTTLE"
