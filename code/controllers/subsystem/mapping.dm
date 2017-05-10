SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = INIT_ORDER_MAPPING
	flags = SS_NO_FIRE

	var/list/nuke_tiles = list()
	var/list/nuke_threats = list()

	var/datum/map_config/config
	var/datum/map_config/next_map_config

	var/list/map_templates = list()

	var/list/ruins_templates = list()
	var/list/space_ruins_templates = list()
	var/list/lava_ruins_templates = list()

	var/list/shuttle_templates = list()
	var/list/shelter_templates = list()

	var/loading_ruins = FALSE
	var/list/mineral_spawn_override = null

	// Z levels presently in use - a list of planet datums
	var/list/z_level_alloc = list()
	// Z level to planet loader. For obtaining properties of current z-level such as plant color or atmospheric mix
	var/list/z_level_to_planet_loader = list()
	// A list of levels available to hand out for maps to load
	// This is a list of numbers, instead of planet datums,
	// indexed associatively so as to not waste space
	var/list/free_zlevels = list()

/datum/controller/subsystem/mapping/PreInit()
	if(!config)
#ifdef FORCE_MAP
		config = new(FORCE_MAP)
#else
		config = new
#endif
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

/datum/controller/subsystem/mapping/Initialize(timeofday)
	if(config.defaulted)
		to_chat(world, "<span class='boldannounce'>Unable to load next map config, defaulting to Box Station</span>")
	loadWorld()
	repopulate_sorted_areas()
	process_teleport_locs()			//Sets up the wizard teleport locations
	preloadTemplates()

	if(SSstarmap.current_planet)
		load_planet(SSstarmap.current_planet)

	// Generate mining.

	/*var/mining_type = MINETYPE
	if (mining_type == "lavaland")
		seedRuins(list(5), global.config.lavaland_budget, /area/lavaland/surface/outdoors, lava_ruins_templates)
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

	seedRuins(space_zlevels, global.config.space_budget, /area/space, space_ruins_templates)
	loading_ruins = FALSE
	repopulate_sorted_areas()*/
	
	// Set up Z-level transistions.
	space_manager.do_transition_setup()
	..()

/* Nuke threats, for making the blue tiles on the station go RED
   Used by the AI doomsday and the self destruct nuke.
*/

/datum/controller/subsystem/mapping/proc/add_nuke_threat(datum/nuke)
	nuke_threats[nuke] = TRUE
	check_nuke_threats()

/datum/controller/subsystem/mapping/proc/remove_nuke_threat(datum/nuke)
	nuke_threats -= nuke
	check_nuke_threats()

/datum/controller/subsystem/mapping/proc/check_nuke_threats()
	for(var/datum/d in nuke_threats)
		if(!istype(d) || QDELETED(d))
			nuke_threats -= d

	for(var/N in nuke_tiles)
		var/turf/open/floor/circuit/C = N
		C.update_icon()
		
/datum/subsystem/mapping/proc/load_planet(var/datum/planet/PL, var/do_unload = 1)
	SSstarmap.is_loading = 1
	if(do_unload)
		log_world("Unloading old z-levels...")
		for(var/z_level_txt in z_level_alloc)
			var/datum/planet/P = z_level_alloc[z_level_txt]
			if(!P)
				continue
			if(P == PL || !P.do_unload())
				log_world("Not unloading [P.z_levels[1]] for [P.name]")
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
				log_world("Z-level [z_level] for [P.name] unloaded")
				deallocate_zlevel(P)
	log_world("Loading z-levels for new sector...")

	for(var/I in 1 to PL.map_names.len)
		var/datum/planet_loader/map_name = PL.map_names[I]
		if(!allocate_zlevel(PL, I))
			log_world("Skipping [PL.z_levels[I]] for [PL.name]")
			continue
		if(istext(map_name))
			map_name = new /datum/planet_loader(map_name, 1)
			PL.map_names[I] = map_name
		SSmapping.z_level_to_planet_loader["[PL.z_levels[I]]"] = map_name
		if(map_name.load(PL.z_levels[I], PL))
			log_world("Z-level [PL.z_levels[I]] for [PL.name] loaded: [map_name.map_name]")
		else
			log_world("Unable to load z-level [PL.z_levels[I]] for [PL.name]! File: [map_name.map_name]")
		CHECK_TICK

	// Later, we can save this per star-system, but for now, scramble the connections
	// on star system load
	space_manager.do_transition_setup()
	SortAreas()
	SSstarmap.is_loading = 0

/datum/subsystem/mapping/proc/add_z_to_planet(var/datum/planet/PL, var/load_name, var/params = null)
	var/datum/planet_loader/map_name = load_name
	message_admins("BOARD MAP LOAD TEST: [map_name]")
	if(!allocate_zlevel(PL, PL.map_names.len+1))
		world.log << "Skipping [PL.z_levels[PL.map_names.len+1]] for [PL.name]"
		return
	if(istext(map_name))
		map_name = new /datum/planet_loader(map_name, 1)
		load_name = map_name
	SSmapping.z_level_to_planet_loader["[PL.z_levels[PL.map_names.len+1]]"] = map_name
	if(map_name.load(PL.z_levels[PL.map_names.len+1], PL, params))
		world.log << "Z-level [PL.z_levels[PL.map_names.len+1]] for [PL.name] loaded: [map_name.map_name]"
	else
		world.log << "Unable to load z-level [PL.z_levels[PL.map_names.len+1]] for [PL.name]! File: [map_name.map_name]"
	CHECK_TICK
	SortAreas()
	PL.map_names += load_name

/datum/subsystem/mapping/Recover()
	flags |= SS_NO_INIT
	map_templates = SSmapping.map_templates
	ruins_templates = SSmapping.ruins_templates
	space_ruins_templates = SSmapping.space_ruins_templates
	lava_ruins_templates = SSmapping.lava_ruins_templates
	shuttle_templates = SSmapping.shuttle_templates
	shelter_templates = SSmapping.shelter_templates

	config = SSmapping.config
	next_map_config = SSmapping.next_map_config

/datum/controller/subsystem/mapping/proc/TryLoadZ(filename, errorList, forceLevel, last)
	var/static/dmm_suite/loader
	if(!loader)
		loader = new
	if(!loader.load_map(file(filename), 0, 0, forceLevel, no_changeturf = TRUE))
		errorList |= filename
	if(last)
		QDEL_NULL(loader)

/datum/controller/subsystem/mapping/proc/CreateSpace(MaxZLevel)
	while(world.maxz < MaxZLevel)
		++world.maxz
		CHECK_TICK

#define INIT_ANNOUNCE(X) to_chat(world, "<span class='boldannounce'>[X]</span>"); log_world(X)
/datum/controller/subsystem/mapping/proc/loadWorld()
	//if any of these fail, something has gone horribly, HORRIBLY, wrong
	var/list/FailedZs = list()
    
	var/start_time = REALTIMEOFDAY
  
	INIT_ANNOUNCE("Loading [config.map_name]...")
	TryLoadZ(config.GetFullMapPath(), FailedZs, ZLEVEL_STATION)
	INIT_ANNOUNCE("Loaded station in [(REALTIMEOFDAY - start_time)/10]s!")
	SSblackbox.add_details("map_name", config.map_name)

	if(config.minetype != "lavaland")
		INIT_ANNOUNCE("WARNING: A map without lavaland set as it's minetype was loaded! This is being ignored! Update the maploader code!")

	CreateSpace(ZLEVEL_SPACEMAX)

	if(LAZYLEN(FailedZs))	//but seriously, unless the server's filesystem is messed up this will never happen
		var/msg = "RED ALERT! The following map files failed to load: [FailedZs[1]]"
		if(FailedZs.len > 1)
			for(var/I in 2 to FailedZs.len)
				msg += ", [I]"
		msg += ". Yell at your server host!"
		INIT_ANNOUNCE(msg)
#undef INIT_ANNOUNCE

/datum/controller/subsystem/mapping/proc/maprotate()
	var/players = GLOB.clients.len
	var/list/mapvotes = list()
	//count votes
	if(global.config.allow_map_voting)
		for (var/client/c in GLOB.clients)
			var/vote = c.prefs.preferred_map
			if (!vote)
				if (global.config.defaultmap)
					mapvotes[global.config.defaultmap.map_name] += 1
				continue
			mapvotes[vote] += 1
	else
		for(var/M in global.config.maplist)
			mapvotes[M] = 1

	//filter votes
	for (var/map in mapvotes)
		if (!map)
			mapvotes.Remove(map)
		if (!(map in global.config.maplist))
			mapvotes.Remove(map)
			continue
		var/datum/map_config/VM = global.config.maplist[map]
		if (!VM)
			mapvotes.Remove(map)
			continue
		if (VM.voteweight <= 0)
			mapvotes.Remove(map)
			continue
		if (VM.config_min_users > 0 && players < VM.config_min_users)
			mapvotes.Remove(map)
			continue
		if (VM.config_max_users > 0 && players > VM.config_max_users)
			mapvotes.Remove(map)
			continue

		if(global.config.allow_map_voting)
			mapvotes[map] = mapvotes[map]*VM.voteweight

	var/pickedmap = pickweight(mapvotes)
	if (!pickedmap)
		return
	var/datum/map_config/VM = global.config.maplist[pickedmap]
	message_admins("Randomly rotating map to [VM.map_name]")
	. = changemap(VM)
	if (. && VM.map_name != config.map_name)
		to_chat(world, "<span class='boldannounce'>Map rotation has chosen [VM.map_name] for next round!</span>")

/datum/controller/subsystem/mapping/proc/changemap(var/datum/map_config/VM)
	if(!VM.MakeNextMap())
		next_map_config = new(default_to_box = TRUE)
		message_admins("Failed to set new map with next_map.json for [VM.map_name]! Using default as backup!")
		return

	next_map_config = VM
	return TRUE

/datum/controller/subsystem/mapping/proc/preloadTemplates(path = "_maps/templates/") //see master controller setup
	var/list/filelist = flist(path)
	for(var/map in filelist)
		var/datum/map_template/T = new(path = "[path][map]", rename = "[map]")
		map_templates[T.name] = T

	preloadRuinTemplates()
	preloadShuttleTemplates()
	preloadShelterTemplates()

/datum/controller/subsystem/mapping/proc/preloadRuinTemplates()
	// Still supporting bans by filename
	var/list/banned = generateMapList("config/lavaruinblacklist.txt")
	banned += generateMapList("config/spaceruinblacklist.txt")

	for(var/item in subtypesof(/datum/map_template/ruin))
		var/datum/map_template/ruin/ruin_type = item
		// screen out the abstract subtypes
		if(!initial(ruin_type.id))
			continue
		var/datum/map_template/ruin/R = new ruin_type()

		if(banned.Find(R.mappath))
			continue

		map_templates[R.name] = R
		ruins_templates[R.name] = R

		if(istype(R, /datum/map_template/ruin/lavaland))
			lava_ruins_templates[R.name] = R
		else if(istype(R, /datum/map_template/ruin/space))
			space_ruins_templates[R.name] = R

/datum/controller/subsystem/mapping/proc/preloadShuttleTemplates()
	var/list/unbuyable = generateMapList("config/unbuyableshuttles.txt")

	for(var/item in subtypesof(/datum/map_template/shuttle))
		var/datum/map_template/shuttle/shuttle_type = item
		if(!(initial(shuttle_type.suffix)))
			continue

		var/datum/map_template/shuttle/S = new shuttle_type()
		if(unbuyable.Find(S.mappath))
			S.can_be_bought = FALSE

		shuttle_templates[S.shuttle_id] = S
		map_templates[S.shuttle_id] = S

/datum/controller/subsystem/mapping/proc/preloadShelterTemplates()
	for(var/item in subtypesof(/datum/map_template/shelter))
		var/datum/map_template/shelter/shelter_type = item
		if(!(initial(shelter_type.mappath)))
			continue
		var/datum/map_template/shelter/S = new shelter_type()

		shelter_templates[S.shelter_id] = S
		map_templates[S.shelter_id] = S
