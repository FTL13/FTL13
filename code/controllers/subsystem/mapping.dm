var/datum/subsystem/mapping/SSmapping

/datum/subsystem/mapping
	name = "Mapping"
	init_order = 100000
	flags = SS_NO_FIRE
	display_order = 50

	var/list/mineral_spawn_override = null

	// Z levels presently in use - a list of planet datums
	var/list/z_level_alloc = list()
	// A list of levels available to hand out for maps to load
	// This is a list of numbers, instead of planet datums,
	// indexed associatively so as to not waste space
	var/list/free_zlevels = list()

/datum/subsystem/mapping/New()
	NEW_SS_GLOBAL(SSmapping)
	return ..()

/datum/subsystem/mapping/proc/allocate_zlevel(var/datum/planet/P, var/index)
	// First of all, is this planet already allocated?
	if(P.z_levels.len >= index)
		return 0

	// Now try to find an unused slot.
	var/z_level = null
	// This is cheaty, but it lets me easily grab some value in an associative list
	for(z_level in free_zlevels)
		z_level = free_zlevels[z_level]
		break
	if(isnull(z_level))
		// `free_zlevels` didn't contain anything, so we create a new level for this
		z_level = space_manager.add_new_zlevel("[P.name] ([index])", linkage = CROSSLINKED, traits = list(REACHABLE))
	else
		// We got a z level, so let's move it over
		free_zlevels -= "[z_level]"
		space_manager.rename_level(z_level, "[P.name]  ([index])")
	// If we wanted to assign attributes to this level based off of the planet,
	// we'd do it here
	// var/datum/space_level/S = space_manager.get_zlev(z_level)
	// S.traits.Cut()
	// S.traits |= planet traits

	z_level_alloc["[z_level]"] = P
	P.z_levels += z_level
	return 1

/datum/subsystem/mapping/proc/deallocate_zlevel(var/datum/planet/P)
	for(var/z_level in P.z_levels)
		if(z_level < 3)
			continue
		if(!("[z_level]" in z_level_alloc))
			continue

		z_level_alloc -= "[z_level]"
		free_zlevels["[z_level]"] = z_level
		P.z_levels -= z_level
	return

/datum/subsystem/mapping/Initialize(timeofday)
	// Ensure that we have 11 z-levels, even if they are empty.

	preloadTemplates()
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

	// Set up Z-level transistions.
	space_manager.do_transition_setup()
	..()

/datum/subsystem/mapping/proc/clear_navbeacon()
	var/area/spacearea = locate(/area/space)
	for(var/datum/sub_turf_block/STB in split_block(locate(1, 1, 1), locate(255, 255, 1)))
		for(var/turf/T in STB.return_list())
			for(var/A in T.contents)
				qdel(A) // Clear everything out, not including docking ports
			for(var/A in T.contents)
				qdel(A) // Some qdels dump their shit on the ground.
			T.ChangeTurf(/turf/open/space)
			spacearea.contents += T
			CHECK_TICK
	world.log << "Navbeacon cleared"

/datum/subsystem/mapping/proc/load_planet(var/datum/planet/PL, var/do_unload = 1)
	SSstarmap.is_loading = 1
	if(do_unload)
		world.log << "Unloading old z-levels..."
		for(var/z_level_txt in z_level_alloc)
			var/datum/planet/P = z_level_alloc[z_level_txt]
			if(!P)
				continue
			if(P == PL || !P.do_unload())
				world.log << "Not unloading [P.z_levels[1]] for [P.name]"
				continue
			for(var/z_level in P.z_levels)
				if("[z_level]" != z_level_txt)
					continue
				for(var/datum/sub_turf_block/STB in split_block(locate(1, 1, z_level), locate(255, 255, z_level)))
					for(var/turf/T in STB.return_list())
						for(var/A in T.contents)
							if(istype(A, /obj/docking_port))
								qdel(A, 1) // Clear everything out. Including docking ports.
							else
								qdel(A)
						for(var/A in T.contents)
							qdel(A) // Some qdels dump their shit on the ground.
						SSair.remove_from_active(T)
						CHECK_TICK
				world.log << "Z-level [z_level] for [P.name] unloaded"
				deallocate_zlevel(P)
	world.log << "Loading z-levels for new sector..."
	var/list/ruins_levels = list()

	for(var/I in 1 to PL.map_names.len)
		var/map_name = PL.map_names[I]
		if(!allocate_zlevel(PL, I))
			world.log << "Skipping [PL.z_levels[I]] for [PL.name]"
			continue
		var/map = "[PL.map_prefix][map_name]"
		var/file = file(map)
		if(isfile(file))
			mineral_spawn_override = PL.rings_composition
			maploader.load_map(file, 1, 1, PL.z_levels[I])

			smooth_zlevel(PL.z_levels[I])
			world.log << "Z-level [PL.z_levels[I]] for [PL.name] loaded: [map]"
		else
			world.log << "Unable to load z-level [PL.z_levels[I]] for [PL.name]! File: [map]"
		if(PL.spawn_ruins)
			ruins_levels += PL.z_levels[I]
		CHECK_TICK

	for(var/obj/effect/landmark/L in landmarks_list)
		if(copytext(L.name, 1, 8) == "ftldock" && L.z in PL.z_levels)
			var/docking_port_id = "ftl_z[L.z][copytext(L.name, 8)]"
			var/obj/docking_port/stationary/ftl_encounter/D = new(L.loc)
			D.id = docking_port_id
			PL.docks |= D
			PL.name_dock(D, copytext(L.name, 9))
			if(copytext(L.name, 9) == "main")
				PL.main_dock = D
			
			qdel(L)

	seedRuins(ruins_levels, rand(2,4), /area/space, space_ruins_templates)
	// Later, we can save this per star-system, but for now, scramble the connections
	// on star system load
	space_manager.do_transition_setup()
	SortAreas()
	SSstarmap.is_loading = 0

/datum/subsystem/mapping/Recover()
	flags |= SS_NO_INIT
