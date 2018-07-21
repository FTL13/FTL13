/datum/planet_loader
	var/map_name
	var/map_prefix = "_maps/ship_encounters/"
	var/list/ruins_args = list()
	var/atmos_mix
	var/plant_color // The idea is that every planet's organisms come up with their own version of chlorophyll
	var/has_gravity = 0

/datum/planet_loader/New(init_map_name, ruins = 0)
	map_name = init_map_name
	if(ruins)
		ruins_args = list(rand(2,4), /area/space, SSmapping.space_ruins_templates)

/datum/planet_loader/proc/add_more_shit(z_level, var/datum/planet/PL)
	return

/datum/planet_loader/proc/load(z_level, var/datum/planet/PL, var/params=null)
	if(istext(map_name))
		var/map = "[map_prefix][map_name]"
		var/file = file(map)
		if(isfile(file))
			SSmapping.mineral_spawn_override = PL.rings_composition
			GLOB.maploader.load_map(file, 1, 1, z_level)
		else
			return 0

	for(var/obj/effect/landmark/dock_spawn/L in GLOB.landmarks_list)
		if(copytext(L.name, 1, 8) == "ftldock" && L.z == z_level)
			L.load_dock(z_level, PL, params=null)

			qdel(L)
	add_more_shit(z_level, PL)

	if(ruins_args.len)
		seedRuins(list(z_level), ruins_args[1], ruins_args[2], ruins_args[3])

	if(SSlighting.initialized)
		SSlighting.create_all_z_lighting_objects(z_level)
	SSmapping.initialize_z_level(z_level)
	smooth_zlevel(z_level)

	SSmapping.mineral_spawn_override = null


	return 1
