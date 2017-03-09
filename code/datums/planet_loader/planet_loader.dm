/datum/planet_loader
	var/map_name
	var/map_prefix = "_maps/ship_encounters/"
	var/list/ruins_args = list()
	var/atmos_mix
	var/plant_color // The idea is that every planet's organisms come up with their own version of chlorophyll

/datum/planet_loader/New(init_map_name, ruins = 0)
	map_name = init_map_name
	if(ruins)
		ruins_args = list(rand(2,4), /area/space, space_ruins_templates)

/datum/planet_loader/proc/add_more_shit(z_level, var/datum/planet/PL)
	return

/datum/planet_loader/proc/load(z_level, var/datum/planet/PL, var/params=null)
	if(istext(map_name))
		var/map = "[map_prefix][map_name]"
		var/file = file(map)
		if(isfile(file))
			SSmapping.mineral_spawn_override = PL.rings_composition
			maploader.load_map(file, 1, 1, z_level)
		else
			return 0
	SSmapping.mineral_spawn_override = null

	for(var/obj/effect/landmark/L in landmarks_list)
		if(copytext(L.name, 1, 8) == "ftldock" && L.z == z_level)
			var/docking_port_id = "ftl_z[L.z][copytext(L.name, 8)]"
			var/obj/docking_port/stationary/ftl_encounter/D = new(L.loc)
			D.encounter_type = copytext(L.name, 9)
			D.id = docking_port_id
			PL.docks |= D
			PL.name_dock(D, D.encounter_type, params)
			if(D.encounter_type == "main")
				PL.main_dock = D
			qdel(L)

	add_more_shit(z_level, PL)

	if(ruins_args.len)
		seedRuins(list(z_level), ruins_args[1], ruins_args[2], ruins_args[3])

	smooth_zlevel(z_level)

	return 1