var/datum/subsystem/starmap/SSstarmap

/datum/subsystem/starmap
	name = "Star map"
	wait = 10
	init_order = 100001 // Initialize before mapping.
	
	var/list/star_systems = list()
	
	//Information on where the ship is
	var/datum/star_system/current_system
	
	var/datum/star_system/from_system // Which system are we in transit from?
	var/from_time // When did we start transiting?
	var/datum/star_system/to_system // Which system are we in transit to?
	var/to_time // When are we expected to arrive?
	var/in_transit // Are we currently in transit?
	
	var/datum/planet/current_planet
	var/datum/planet/from_planet
	var/datum/planet/to_planet
	var/in_transit_planet // In transit between planets?
	
	var/is_loading = 0

/datum/subsystem/starmap/New()
	NEW_SS_GLOBAL(SSstarmap)

/datum/subsystem/starmap/Initialize(timeofday)
	
	// Generate star systems
	for(var/i in 1 to 100)
		var/datum/star_system/system = new
		system.generate()
		star_systems += system
	
	// Pick a location to place the player
	current_system = pick(star_systems)
	
	..()

/datum/subsystem/starmap/fire()
	if(world.time > to_time && in_transit)
		if(is_loading) // Not done loading yet, delay arrival by 30 seconds
			to_time += 300
			return
		
		current_system = to_system
		
		from_system = null
		from_time = 0
		to_system = null
		to_time = 0
		in_transit = 0
		
		var/obj/docking_port/mobile/ftl/ftl = SSshuttle.getShuttle("ftl")
		var/obj/docking_port/stationary/dest = SSshuttle.getDock("ftl_start") // For now
		
		ftl.dock(dest)
	
	if(world.time > to_time && in_transit_planet)
		current_planet = to_planet
		
		from_planet = null
		from_time = 0
		to_planet = null
		to_time = 0
		in_transit_planet = 0
		
		var/obj/docking_port/mobile/ftl/ftl = SSshuttle.getShuttle("ftl")
		
		ftl.dock(current_planet.main_dock)

/datum/subsystem/starmap/proc/get_transit_progress()
	if(!in_transit && !in_transit_planet)
		return 0
	return (world.time - from_time)/(to_time - from_time)

/datum/subsystem/starmap/proc/get_ship_x()
	if(!in_transit)
		return current_system.x
	return from_system.lerp_x(to_system, get_transit_progress())

/datum/subsystem/starmap/proc/get_ship_y()
	if(!in_transit)
		return current_system.y
	return from_system.lerp_y(to_system, get_transit_progress())

/datum/subsystem/starmap/proc/jump(var/datum/star_system/target)
	if(!target || target == current_system || !istype(target))
		return 1
	if(in_transit || in_transit_planet)
		return 1
	var/obj/docking_port/mobile/ftl/ftl = SSshuttle.getShuttle("ftl")
	from_system = current_system
	from_time = world.time
	to_system = target
	to_time = world.time + 1800 // Should give more than enough time to load the maps.
	current_system = null
	in_transit = 1
	ftl.enterTransit()
	spawn(5)
		SSmapping.load_star(target)
	
	return 0

/datum/subsystem/starmap/proc/jump_planet(var/datum/planet/target)
	if(!target || target == current_planet || !istype(target))
		return 1
	if(in_transit || in_transit_planet)
		return 1
	var/obj/docking_port/mobile/ftl/ftl = SSshuttle.getShuttle("ftl")
	from_planet = current_planet
	from_time = world.time
	to_planet = target
	to_time = world.time + 150 // A quick jump to another planet!
	current_planet = null
	in_transit_planet = 1
	ftl.enterTransit()
	
	return 0

/datum/subsystem/mapping/Recover()
	flags |= SS_NO_INIT
