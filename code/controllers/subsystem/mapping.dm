var/datum/subsystem/mapping/SSmapping

/datum/subsystem/mapping
	name = "Mapping"
	init_order = 100000
	flags = SS_NO_FIRE
	display_order = 50
	
	var/list/mineral_spawn_override = null

/datum/subsystem/mapping/New()
	NEW_SS_GLOBAL(SSmapping)
	return ..()


/datum/subsystem/mapping/Initialize(timeofday)
	// Ensure that we have 11 z-levels, even if they are empty.
	if(world.maxz < 11)
		world.maxz = 11 // There, we now have 11 z-levels.

	preloadTemplates()
	// Pick a random away mission.
	createRandomZlevel()
	// Generate mining.

	/*var/mining_type = MINETYPE
	if (mining_type == "lavaland")
		seedRuins(list(5), config.lavaland_budget, /area/lavaland/surface/outdoors, lava_ruins_templates)
		spawn_rivers()
	else
		make_mining_asteroid_secrets()*/

	// deep space ruins
	/*var/space_zlevels = list()
	for(var/i in ZLEVEL_SPACEMIN to ZLEVEL_SPACEMAX)
		switch(i)
			if(ZLEVEL_MINING, ZLEVEL_LAVALAND, ZLEVEL_EMPTY_SPACE)
				continue
			else
				space_zlevels += i

	seedRuins(space_zlevels, rand(8,16), /area/space, space_ruins_templates)*/
	
	load_star(SSstarmap.current_system, 1)

	// Set up Z-level transistions.
	setup_map_transitions()
	..()

/datum/subsystem/mapping/proc/load_star(datum/star_system/star, var/is_initial = 0)
	SSstarmap.is_loading = 1
	if(!is_initial)
		world.log << "Unloading old z-levels..."
		for(var/datum/sub_turf_block/STB in split_block(locate(1, 1, 3), locate(255, 255, 11)))
			for(var/turf/T in STB.return_list())
				for(var/A in T.contents)
					if(istype(A, /obj/docking_port))
						qdel(A, 1) // Clear everything out. Including docking ports.
					else
						qdel(A)
				for(var/A in T.contents)
					qdel(A) // Some qdels dump their shit on the ground.
				CHECK_TICK
		for(var/datum/sub_turf_block/STB in split_block(locate(1, 1, 1), locate(255, 255, 1)))
			for(var/turf/T in STB.return_list())
				for(var/A in T.contents)
					qdel(A) // Clear everything out, not including docking ports
				for(var/A in T.contents)
					qdel(A) // Some qdels dump their shit on the ground.
				CHECK_TICK
	world.log << "Loading z-levels for new sector..."
	var/list/ruins_levels = list()

	for(var/datum/planet/P in star.planets)
		if(P.z_level < 3 || P.z_level > 11)
			continue
		
		var/map = "[P.map_prefix][P.map_name]"
		var/file = file(map)
		if(isfile(file))
			mineral_spawn_override = P.rings_composition
			maploader.load_map(file, 1, 1, P.z_level)
			
			smooth_zlevel(P.z_level)
			world.log << "Z-level [P.z_level] loaded: [map]"
		else
			world.log << "Unable to load z-level [P.z_level]!"
		if(P.spawn_ruins)
			ruins_levels += P.z_level
		
		P.docks = list()
		
		CHECK_TICK
	
	for(var/obj/effect/landmark/L in landmarks_list)
		if(copytext(L.name, 1, 8) == "ftldock" && L.z >= 3 && L.z <= 11)
			var/docking_port_id = "ftl_z[L.z][copytext(L.name, 8)]"
			var/obj/docking_port/stationary/ftl_encounter/D = new(L.loc)
			D.id = docking_port_id
			for(var/datum/planet/P in star.planets)
				if(P.z_level == D.z)
					P.docks += D
					P.name_dock(D, copytext(L.name, 9))
					if(copytext(L.name, 9) == "main")
						P.main_dock = D
	
	var/obj/docking_port/stationary/ftl_start = SSshuttle.getDock("ftl_start")
	star.navbeacon.docks = list(ftl_start)
	star.navbeacon.main_dock = ftl_start
	SSstarmap.current_planet = star.navbeacon
	
	seedRuins(ruins_levels, rand(8,16), /area/space, space_ruins_templates)
	
	SortAreas()
	SSstarmap.is_loading = 0

/datum/subsystem/mapping/Recover()
	flags |= SS_NO_INIT
