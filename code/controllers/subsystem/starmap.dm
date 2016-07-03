var/datum/subsystem/starmap/SSstarmap

/datum/subsystem/starmap
	name = "Star map"
	wait = 10
	
	var/list/star_systems = list()
	
	//Information on where the ship is
	var/datum/star_system/current_system
	
	var/datum/star_system/from_system // Which system are we in transit from?
	var/from_time // When did we start transiting?
	var/datum/star_system/to_system // Which system are we in transit to?
	var/to_time // When are we expected to arrive?
	var/in_transit // Are we currently in transit?

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
		current_system = to_system
		
		from_system = null
		from_time = 0
		to_system = null
		to_time = 0
		in_transit = 0
		
		var/obj/docking_port/mobile/ftl/ftl = SSshuttle.getShuttle("ftl")
		var/obj/docking_port/stationary/dest = SSshuttle.getDock("ftl_start") // For now
		
		ftl.dock(dest)

/datum/subsystem/starmap/proc/jump(var/datum/star_system/target)
	if(!target)
		return 1
	if(in_transit)
		return 1
	var/obj/docking_port/mobile/ftl/ftl = SSshuttle.getShuttle("ftl")
	from_system = current_system
	from_time = world.time
	to_system = target
	to_time = world.time + 600 // For now
	current_system = null
	in_transit = 1
	ftl.enterTransit()
	return 0