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

	var/obj/machinery/ftl_drive/ftl_drive
	var/obj/machinery/ftl_shieldgen/ftl_shieldgen


/datum/subsystem/starmap/New()
	NEW_SS_GLOBAL(SSstarmap)

/datum/subsystem/starmap/Initialize(timeofday)

	// Generate star systems
	for(var/i in 1 to 100)
		var/datum/star_system/system = new
		system.generate()
		star_systems += system

	var/datum/star_system/base
	while(!base || base.alignment != "unaligned")
		base = pick(star_systems)
	base.alignment = "nanotrasen"
	base.capital_planet = 1
	base.danger_level = 8
	current_system = base
	current_planet = base.navbeacon
	current_system.visited = 1
	while(!base || base.alignment != "unaligned")
		base = pick(star_systems)
	base.alignment = "syndicate"
	base.capital_planet = 1
	base.danger_level = 8
	while(!base || base.alignment != "unaligned")
		base = pick(star_systems)
	base.alignment = "solgov"
	base.capital_planet = 1
	base.danger_level = 8

	// Generate territories
	for(var/i in 1 to 70)
		var/territory_to_expand = pick("syndicate", "solgov", "nanotrasen")
		var/datum/star_system/system_closest_to_territory = null
		var/system_closest_to_territory_dist = 100000
		var/datum/star_system/capital = null
		// Not exactly a fast algorithm, but it works. Besides, there's only a hundered star systems, it's not gonna cause much lag.
		for(var/datum/star_system/E in star_systems)
			if(E.alignment != "unaligned")
				continue
			var/closest_in_dist = 100000
			for(var/datum/star_system/C in star_systems)
				if(C.alignment != territory_to_expand)
					continue
				if(C.capital_planet)
					capital = C
				var/dist = E.dist(C)
				closest_in_dist = min(dist, closest_in_dist)
			if(closest_in_dist < system_closest_to_territory_dist)
				system_closest_to_territory_dist = closest_in_dist
				system_closest_to_territory = E
		if(system_closest_to_territory)
			system_closest_to_territory.alignment = territory_to_expand
			system_closest_to_territory.danger_level = max(1, max(1,round((50 - system_closest_to_territory.dist(capital)) / 8)))


	..()

/datum/subsystem/starmap/fire()
	if(world.time > to_time && in_transit)
		current_system = to_system

		var/obj/docking_port/stationary/ftl_start = SSshuttle.getDock("ftl_start")
		current_system.navbeacon.docks = list(ftl_start)
		current_system.navbeacon.main_dock = ftl_start
		current_planet = current_system.navbeacon

		from_system = null
		from_time = 0
		to_system = null
		to_time = 0
		in_transit = 0

		var/obj/docking_port/mobile/ftl/ftl = SSshuttle.getShuttle("ftl")
		var/obj/docking_port/stationary/dest = ftl_start

		ftl.dock(dest)
		for(var/area/shuttle/ftl/F in world)
			F << 'sound/effects/hyperspace_end.ogg'
		parallax_movedir_in_areas(/area/shuttle/ftl, 0)
		parallax_launch_in_areas(/area/shuttle/ftl, 4, 1)
		toggle_ambience(0)
		current_system.visited = 1

		generate_npc_ships()

	if(world.time > to_time && in_transit_planet)
		if(is_loading) // Not done loading yet, delay arrival by 10 seconds
			to_time += 100
			return

		current_planet = to_planet

		from_planet = null
		from_time = 0
		to_planet = null
		to_time = 0
		in_transit_planet = 0

		var/obj/docking_port/mobile/ftl/ftl = SSshuttle.getShuttle("ftl")

		ftl.dock(current_planet.main_dock)
		for(var/area/shuttle/ftl/F in world)
			F << 'sound/effects/hyperspace_end.ogg'
		parallax_movedir_in_areas(/area/shuttle/ftl, 0)
		parallax_launch_in_areas(/area/shuttle/ftl, 4, 1)
		toggle_ambience(0)



/datum/subsystem/starmap/proc/get_transit_progress()
	if(!in_transit && !in_transit_planet)
		return 0
	return (world.time - from_time)/(to_time - from_time)

/datum/subsystem/starmap/proc/getTimerStr()
	var/timeleft = round((to_time-world.time)/10)
	if(timeleft > 0)
		return "[add_zero(num2text((timeleft / 60) % 60),2)]:[add_zero(num2text(timeleft % 60), 2)]"
	else
		return "00:00"

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
	if(!ftl_drive || !ftl_drive.can_jump())
		return 1
	if(in_transit || in_transit_planet)
		return 1
	var/obj/docking_port/mobile/ftl/ftl = SSshuttle.getShuttle("ftl")
	from_system = current_system
	from_time = world.time + 40
	to_system = target
	to_time = world.time + 1840
	current_system = null
	in_transit = 1
	ftl_drive.plasma_charge = 0
	ftl_drive.power_charge = 0
	for(var/area/shuttle/ftl/F in world)
		F << 'sound/effects/hyperspace_begin.ogg'
	parallax_launch_in_areas(/area/shuttle/ftl, 4, 0)
	spawn(40)
		ftl.enterTransit()
		toggle_ambience(1)
		parallax_movedir_in_areas(/area/shuttle/ftl, 4)
	spawn(45)
		SSmapping.clear_navbeacon()

	return 0

/datum/subsystem/starmap/proc/jump_planet(var/datum/planet/target)
	if(!target || target == current_planet || !istype(target))
		return 1
	if(!ftl_drive || !ftl_drive.can_jump_planet())
		return 1
	if(in_transit || in_transit_planet)
		return 1
	var/obj/docking_port/mobile/ftl/ftl = SSshuttle.getShuttle("ftl")
	from_planet = current_planet
	from_time = world.time + 40
	to_planet = target
	to_time = world.time + 640 // Oh god, this is some serous jump time.
	current_planet = null
	in_transit_planet = 1
	ftl_drive.plasma_charge -= ftl_drive.plasma_charge_max*0.25
	ftl_drive.power_charge -= ftl_drive.power_charge_max*0.25
	for(var/area/shuttle/ftl/F in world)
		F << 'sound/effects/hyperspace_begin.ogg'
	parallax_launch_in_areas(/area/shuttle/ftl, 4, 0)
	spawn(40)
		ftl.enterTransit()
		toggle_ambience(1)
		parallax_movedir_in_areas(/area/shuttle/ftl, 4)
	spawn(45)
		SSmapping.load_planet(target)

	return 0

/datum/subsystem/starmap/proc/jump_port(var/obj/docking_port/stationary/target)
	if(in_transit || in_transit_planet)
		return 1
	if(!target || !(target.z in current_planet.z_levels))
		return 1
	var/obj/docking_port/mobile/ftl/ftl = SSshuttle.getShuttle("ftl")
	if(target == ftl.get_docked())
		return 1
	ftl.dock(target)
	return 0

/datum/subsystem/starmap/Recover()
	flags |= SS_NO_INIT

/datum/subsystem/starmap/proc/toggle_ambience(var/on)
	for(var/area/shuttle/ftl/F in world)
		F.current_ambience = on ? 'sound/effects/hyperspace_progress_loopy.ogg' : initial(F.current_ambience)
		F.refresh_ambience_for_mobs()

/datum/subsystem/starmap/proc/generate_npc_ships(var/num=0)
	var/f_list
	var/generating_pirates = 0

	if(!num)
		num = rand(current_system.danger_level - 1, current_system.danger_level + 1)

	if(current_system.alignment == "unaligned"|| prob(10))
		f_list = SSship.faction2list("pirate") //unaligned systems have pirates, and aligned systems have a small chance
		generating_pirates = 1
		num = rand(1,2)

	else f_list = SSship.faction2list(current_system.alignment)





	for(var/i = 1 to num)
		var/datum/starship/S
		while(!S)
			S = pick(f_list)
			if(!prob(f_list[S]))
				S = null

		var/datum/starship/N = new S.type(1)
		N.system = current_system
		N.planet = pick(current_system.planets) //small chance you'll jump into a planet with a ship at it
		N.system.ships += N

		if(!generating_pirates)
			N.faction = current_system.alignment //a bit hacky, yes, pretty much overrides the wierd list with faction and chance to a numerical var.
		else
			N.faction = "pirate"