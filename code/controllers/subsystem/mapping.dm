var/datum/subsystem/mapping/SSmapping

/datum/subsystem/mapping
	name = "Mapping"
	init_order = 100000
	flags = SS_NO_FIRE
	display_order = 50

	var/list/mineral_spawn_override = null

	// Z levels presently in use - a list of planet datums
	var/list/z_level_alloc = list()
	// Z level to planet loader. For obtaining properties of current z-level such as plant color or atmospheric mix
	var/list/z_level_to_planet_loader = list()
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
		z_level_to_planet_loader -= "[z_level]"
		free_zlevels["[z_level]"] = z_level
		P.z_levels -= z_level
	return

/datum/subsystem/mapping/Initialize(timeofday)
	preloadTemplates()

	if(SSstarmap.current_planet)
		load_planet(SSstarmap.current_planet)

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

	for(var/I in 1 to PL.map_names.len)
		var/datum/planet_loader/map_name = PL.map_names[I]
		if(!allocate_zlevel(PL, I))
			world.log << "Skipping [PL.z_levels[I]] for [PL.name]"
			continue
		if(istext(map_name))
			map_name = new /datum/planet_loader(map_name, 1)
			PL.map_names[I] = map_name
		SSmapping.z_level_to_planet_loader["[PL.z_levels[I]]"] = map_name
		if(map_name.load(PL.z_levels[I], PL))
			world.log << "Z-level [PL.z_levels[I]] for [PL.name] loaded: [map_name.map_name]"
		else
			world.log << "Unable to load z-level [PL.z_levels[I]] for [PL.name]! File: [map_name.map_name]"
		CHECK_TICK

	// Later, we can save this per star-system, but for now, scramble the connections
	// on star system load
	space_manager.do_transition_setup()
	SortAreas()
	SSstarmap.is_loading = 0

/datum/subsystem/mapping/proc/add_z_to_planet(var/datum/planet/PL, var/load_name)
	var/datum/planet_loader/map_name = load_name
	if(!allocate_zlevel(PL, PL.map_names.len+1))
		world.log << "Skipping [PL.z_levels[PL.map_names.len+1]] for [PL.name]"
		continue
	if(istext(map_name))
		map_name = new /datum/planet_loader(map_name, 1)
	SSmapping.z_level_to_planet_loader["[PL.z_levels[PL.map_names.len+1]]"] = map_name
	if(map_name.load(PL.z_levels[PL.map_names.len+1], PL))
		world.log << "Z-level [PL.z_levels[PL.map_names.len+1]] for [PL.name] loaded: [map_name.map_name]"
	else
		world.log << "Unable to load z-level [PL.z_levels[PL.map_names.len+1]] for [PL.name]! File: [map_name.map_name]"
	CHECK_TICK
	SortAreas()
	PL.map_names += load_name

/datum/subsystem/mapping/Recover()
	flags |= SS_NO_INIT
