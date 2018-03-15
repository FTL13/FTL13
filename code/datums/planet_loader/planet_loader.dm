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
			var/docking_port_id = "ftl_z[L.z][copytext(L.name, 8)]"
			if(!L.ftl_ship_main_dock) //FOB docks setup
				var/obj/docking_port/stationary/fob/D = new(L.loc)
				D.encounter_type = copytext(L.name, 9)
				D.id = docking_port_id + "_[L.allowed_shuttles]" //Makes it so unique docks can exist. Will have issues with identical docks, but thats for future PRs
				D.baseturf_type = L.baseturf_type
				D.turf_type = L.turf_type
				D.area_type = L.area_type
				D.dir = L.dir
				D.dock_distance = L.distance
				D.use_dock_distance = L.use_dock_distance
				D.dock_do_not_show = L.keep_hidden
				D.allowed_shuttles = L.allowed_shuttles
				PL.docks |= D
				PL.name_dock(D, D.encounter_type, params)
			else
				var/obj/docking_port/stationary/ftl_encounter/D = new(L.loc)
				D.encounter_type = copytext(L.name, 9)
				D.id = docking_port_id
				D.baseturf_type = L.baseturf_type
				D.turf_type = L.turf_type
				D.area_type = L.area_type
				D.dir = L.dir
				D.dock_distance = 25
				D.use_dock_distance = TRUE
				D.dock_do_not_show = FALSE
				D.allowed_shuttles = ALL_SHUTTLES
				PL.docks |= D
				PL.name_dock(D, D.encounter_type, params)
				PL.main_dock = D
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
