/proc/power_failure()
	priority_announce("Abnormal activity detected in [station_name()]'s powernet. As a precautionary measure, the station's power will be shut off for an indeterminate duration.", "Critical Power Failure", 'sound/AI/poweroff.ogg')
	for(var/obj/machinery/power/smes/S in machines)
		if(istype(get_area(S), /area/turret_protected) || S.z != ZLEVEL_STATION)
			continue
		S.charge = 0
		S.output_level = 0
		S.output_attempt = 0
		S.update_icon()
		S.power_change()

	var/list/skipped_areas = list(/area/engine/engineering, /area/turret_protected/ai)

	for(var/area/A in world)
		if( !A.requires_power || A.always_unpowered )
			continue

		var/skip = 0
		for(var/area_type in skipped_areas)
			if(istype(A,area_type))
				skip = 1
				break
		if(A.contents)
			for(var/atom/AT in A.contents)
				if(AT.z != ZLEVEL_STATION) //Only check one, it's enough.
					skip = 1
				break
		if(skip) continue

/proc/power_restore()
	priority_announce("Power has been restored to [station_name()]. We apologize for the inconvenience.", "Power Systems Nominal", 'sound/AI/poweron.ogg')
	for(var/obj/machinery/power/smes/S in machines)
		if(S.z != ZLEVEL_STATION)
			continue
		S.charge = S.capacity
		S.update_icon()
		S.power_change()

/proc/power_restore_quick()
	priority_announce("All SMESs on [station_name()] have been recharged. We apologize for the inconvenience.", "Power Systems Nominal", 'sound/AI/poweron.ogg')
	for(var/obj/machinery/power/smes/S in machines)
		if(S.z != ZLEVEL_STATION)
			continue
		S.charge = S.capacity
		S.update_icon()
		S.power_change()
