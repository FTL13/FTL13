SUBSYSTEM_DEF(starmap)
	name = "Star map"
	wait = 10
	init_order = INIT_ORDER_STARMAP

	var/list/star_systems = list()
	var/list/capitals = list()

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

	var/is_loading = FTL_NOT_LOADING // Status of z level loading during FTL

	var/obj/machinery/ftl_drive/ftl_drive
	var/obj/machinery/ftl_shieldgen/ftl_shieldgen

	var/list/ftl_consoles = list()
	var/ftl_is_spooling = 0
	var/ftl_can_cancel_spooling = 0

	var/list/ship_objectives = list()

	var/list/objective_types = list(/datum/objective/ftl/killships = 2, /datum/objective/ftl/delivery = 1, /datum/objective/ftl/boardship = 1)

	//For calling events - only one event allowed at the single time
	var/datum/round_event/ghost_role/boarding/mode

	var/list/star_resources = list()
	var/list/galactic_prices = list()

	var/list/stations = list()
	var/list/wreckages = list()
	var/list/station_modules = list()

	var/initial_report = 0

	var/planet_loaded = FALSE

	var/dolos_entry_sound = 'sound/ambience/THUNDERDOME.ogg' //FTL last stand would also work

/datum/controller/subsystem/starmap/Initialize(timeofday)
	var/list/resources = subtypesof(/datum/star_resource)
	for(var/i in resources)
		star_resources += new i

	for(var/i in subtypesof(/datum/station_module))
		var/datum/station_module/module = i
		station_modules[i] = initial(module.rarity)

	var/datum/star_system/base

	base = new /datum/star_system/capital/nanotrasen
	base.generate()
	star_systems += base
	capitals[base.alignment] = base
	current_system = base
	current_planet = base.planets[1]
	current_system.visited = 1

	base = new /datum/star_system/capital/syndicate
	base.generate()
	star_systems += base
	capitals[base.alignment] = base

	base = new /datum/star_system/capital/solgov
	base.generate()
	star_systems += base
	capitals[base.alignment] = base

	// Generate star systems
	for(var/i in 1 to 100)
		var/datum/star_system/system = new
		system.generate()
		star_systems += system

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

			var/datum/star_faction/faction = SSship.cname2faction(system_closest_to_territory.alignment)
			faction.systems += system_closest_to_territory
			faction.systems[system_closest_to_territory] = system_closest_to_territory.danger_level

	for(var/datum/star_system/system in star_systems)
		if(system.alignment == "unaligned")
			var/datum/star_faction/pirate = SSship.cname2faction("pirate")
			pirate.systems += system
			system.danger_level = 2



	spawn(10) generate_factions()
	..()

/datum/controller/subsystem/starmap/fire()
	if(is_loading == FTL_LOADING && world.time >= to_time)
		to_time += 100

	if(in_transit || in_transit_planet)
		var/obj/docking_port/mobile/ftl/ftl = SSshuttle.getShuttle("ftl")
		if(is_loading == FTL_NOT_LOADING && world.time >= from_time + 50)
			if(in_transit)
				SSmapping.load_planet(to_system.planets[1])
			else if(in_transit_planet)
				SSmapping.load_planet(to_planet)

		if(is_loading == FTL_DONE_LOADING && world.time >= to_time)
			if(in_transit) //Update the ships new location
				current_system = to_system
				current_system.visited = TRUE
				current_planet = current_system.planets[1]
			else if(in_transit_planet)
				current_planet = to_planet
			var/obj/docking_port/stationary/dest = current_planet.main_dock //Delet me to stop ship after FTL
			ftl.mode = SHUTTLE_CALL
			ftl.destination = dest
			if(current_system.name == "Dolos") //Syndie cap
				message_admins("The ship has just arrived at Dolos!")
				for(var/A in ftl.shuttle_areas)
					var/area/place = A
					place << dolos_entry_sound
			for(var/A in ftl.shuttle_areas)
				var/area/place = A
				place << 'sound/effects/hyperspace_end.ogg'
			toggle_ambience(0)

			addtimer(CALLBACK(src,.proc/ftl_sound,'sound/ai/ftl_success.ogg'), 50)

			from_time = 0
			to_time = 0
			from_planet = null
			from_system = null
			to_planet = null
			to_system = null
			in_transit = FALSE
			in_transit_planet = FALSE
			is_loading = FTL_NOT_LOADING

	// Check and update ship objectives
	var/objectives_complete = 1
	for(var/datum/objective/O in ship_objectives)
		if((O.type == /datum/objective/ftl/gohome) || (!O.failed && !O.check_completion() && !O.failed))
			objectives_complete = 0

	if(objectives_complete)
		// Make a new objective
		var/datum/objective/O

		if(objective_types.len && world.time < 54000)
			var/objectivetype = pickweight(objective_types)
			objective_types[objectivetype]--
			if(objective_types[objectivetype] <= 0)
				objective_types -= objectivetype
			O = new objectivetype
		else
			O = new /datum/objective/ftl/gohome

		O.find_target()
		ship_objectives += O
		priority_announce("Ship objectives updated. Please check a communications console for details.", null, null)

/datum/controller/subsystem/starmap/proc/get_transit_progress()
	if(!in_transit && !in_transit_planet)
		return 0
	return (world.time - from_time)/(to_time - from_time)

/datum/controller/subsystem/starmap/proc/getTimerStr()
	var/timeleft = round((to_time-world.time)/10)
	if(timeleft > 0)
		return "[add_zero(num2text((timeleft / 60) % 60),2)]:[add_zero(num2text(timeleft % 60), 2)]"
	else
		return "00:00"

/datum/controller/subsystem/starmap/proc/get_ship_x()
	if(!in_transit)
		return current_system.x
	return from_system.lerp_x(to_system, get_transit_progress())

/datum/controller/subsystem/starmap/proc/get_ship_y()
	if(!in_transit)
		return current_system.y
	return from_system.lerp_y(to_system, get_transit_progress())

/datum/controller/subsystem/starmap/proc/jump(var/datum/star_system/target)
	if(!target || target == current_system || !istype(target))
		return 1
	if(!ftl_drive || !ftl_drive.can_jump())
		return 1
	if(in_transit || in_transit_planet)
		return 1
	if(ftl_is_spooling)
		return 1
	if(!spool_up()) return
	var/obj/docking_port/mobile/ftl/ftl = SSshuttle.getShuttle("ftl")
	from_system = current_system
	from_time = world.time + 40
	to_system = target
	if(to_system.name == "Dolos") //Syndie cap
		message_admins("The ship has just jumped to Dolos!!")
	to_time = world.time + 1850
	current_system = null
	in_transit = 1
	mode = null
	ftl_drive.plasma_charge = 0
	ftl_drive.power_charge = 0
	SSshuttle.has_calculated = FALSE
	planet_loaded = FALSE //Bad, replace with a check for telecoms
	ftl_sound('sound/effects/hyperspace_begin.ogg')
	spawn(49)
		toggle_ambience(1)
	spawn(50)
		ftl.mode = SHUTTLE_IGNITING //This line moves the ship

	for(var/datum/starship/other in SSstarmap.current_system)
		if(!SSship.check_hostilities(other.faction,"ship"))
			SSship.last_known_player_system = to_system
			break

	return 0

/datum/controller/subsystem/starmap/proc/jump_planet(var/datum/planet/target)
	if(!target || target == current_planet || !istype(target))
		return 1
	if(!ftl_drive || !ftl_drive.can_jump_planet())
		return 1
	if(in_transit || in_transit_planet)
		return 1
	if(ftl_is_spooling)
		return 1
	if(!spool_up()) return
	var/obj/docking_port/mobile/ftl/ftl = SSshuttle.getShuttle("ftl")
	from_planet = current_planet
	from_time = world.time + 40
	to_planet = target
	to_time = world.time + 950 // Oh god, this is some serous jump time.
	current_planet = null
	in_transit_planet = 1
	mode = null //why was this not here???
	SSshuttle.has_calculated = FALSE
	planet_loaded = FALSE //Bad, replace with a check for telecoms?
	ftl_drive.plasma_charge -= ftl_drive.plasma_charge_max*0.25
	ftl_drive.power_charge -= ftl_drive.power_charge_max*0.25
	ftl_sound('sound/effects/hyperspace_begin.ogg')
	spawn(49)
		toggle_ambience(1)
	spawn(50)
		ftl.mode = SHUTTLE_IGNITING

	return 0

/datum/controller/subsystem/starmap/proc/jump_port(var/obj/docking_port/stationary/target)
	if(in_transit || in_transit_planet)
		return 1
	if(!target || !(target.z in current_planet.z_levels))
		return 1
	if(ftl_is_spooling)
		return 1

	var/obj/docking_port/mobile/ftl/ftl = SSshuttle.getShuttle("ftl")
	if(target == ftl.get_docked())
		return 1
	if(!SSshuttle.has_calculated)
		var/datum/planet/PL = SSstarmap.current_system.get_planet_for_z(target.z)
		if(PL && PL.station)
			INVOKE_ASYNC(GLOBAL_PROC, .proc/recalculate_prices, PL.station)
	ftl.dock(target)
	return 0

/datum/controller/subsystem/starmap/Recover()
	flags |= SS_NO_INIT

/datum/controller/subsystem/starmap/proc/toggle_ambience(var/on)
	for(var/area/shuttle/ftl/F in world)
		F.current_ambience = on ? 'sound/effects/hyperspace_progress_loopy.ogg' : initial(F.current_ambience)
		F.refresh_ambience_for_mobs()

/* Deprecated

/datum/controller/subsystem/starmap/proc/generate_npc_ships(var/num=0)
	var/f_list
	var/generating_pirates = 0

	if(!num)
		num = rand(current_system.danger_level - 1, current_system.danger_level + 1)

	if(current_system.alignment == "unaligned"|| prob(10))
		f_list = SSship.faction2list("pirate") //unaligned systems have pirates, and aligned systems have a small chance
		generating_pirates = 1
		num = rand(1,2)

	else
		f_list = SSship.faction2list(current_system.alignment)

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

*/

/datum/controller/subsystem/starmap/proc/pick_station(var/alignment, var/datum/star_system/origin, var/distance)
	var/list/possible_stations = list();
	for(var/datum/star_system/S in star_systems)
		if(S.alignment != alignment)
			continue
		if(origin && (origin.dist(S) > distance))
			continue
		for(var/datum/planet/P in S.planets)
			if(P.station)
				possible_stations += P
	return pick(possible_stations)

/datum/controller/subsystem/starmap/proc/ftl_message(var/message)
	for(var/obj/machinery/computer/ftl_navigation/C in ftl_consoles)
		C.status_update(message)
	ftl_drive.status_update(message)

/datum/controller/subsystem/starmap/proc/ftl_sound(var/sound) //simple proc to play a sound to the crew aboard the ship, also since I want to use minor_announce for the FTL notice but that doesn't support sound
	for(var/A in GLOB.sortedAreas)
		var/area/place = A
		var/atom/AT = place.contents[1]
		var/i = 1
		while(!AT)
			AT = place.contents[i++]
		if(AT.z == ZLEVEL_STATION && istype(place, /area/shuttle/ftl))
			place << sound

/datum/controller/subsystem/starmap/proc/ftl_cancel() //reusable proc for when your FTL jump fails or is canceled
	minor_announce("The scheduled FTL translation has either been cancelled or failed during the safe processing stage. All crew are to standby for orders from the bridge.","Alert! FTL spoolup failure!")
	ftl_sound('sound/ai/ftl_cancel.ogg')
	ftl_is_spooling = 0

/datum/controller/subsystem/starmap/proc/ftl_rumble(var/message)
	for(var/A in GLOB.sortedAreas)
		var/area/place = A
		var/atom/AT = place.contents[1]
		var/i = 1
		while(!AT)
			AT = place.contents[i++]
		if(AT.z == ZLEVEL_STATION && istype(place, /area/shuttle/ftl))
			for(var/mob/M in place)
				to_chat(M, "<font color=red><i>The ship's deck starts to shudder violently as the FTL drive begins to activate.</font></i>")
				rumble_camera(M,150,12)

/datum/controller/subsystem/starmap/proc/ftl_sleep(var/delay) //proc that checks the spooling status before adding the delay, used to cancel the spooling process
	if(!ftl_is_spooling)
		ftl_cancel()
		return 0
	else
		sleep(delay)
		return 1

/datum/controller/subsystem/starmap/proc/generate_factions()
	for(var/capital in capitals)
		var/datum/star_faction/faction_capital = SSship.cname2faction(capital)
		var/datum/star_system/capital_system = capitals[capital]
		faction_capital.systems += capital_system
		faction_capital.systems[capital_system] = capital_system.danger_level

		faction_capital.capital = capital_system

	for(var/datum/star_faction/faction in SSship.star_factions)
		if(faction.abstract)
			continue
		var/starting_cash = STARTING_FACTION_CASH + rand(-10000,10000)
		faction.money += starting_cash
		faction.starting_funds += starting_cash

		for(var/datum/star_resource/resource in star_resources)
			faction.resources += resource.cname
			faction.resources[resource.cname] = max(1,resource.scale_weight + rand(-200,200))


		faction.systems = sortList(faction.systems,/proc/cmp_danger_dsc) //sorts systems in descending order based on danger level

		var/list/h_list = SSship.faction2list(faction.cname,1)
		for(var/datum/starship/S in h_list)
			var/datum/starship/ship_spawned = SSship.create_ship(S,faction.cname,faction.capital)
			ship_spawned.mission_ai = new /datum/ship_ai/guard
			ship_spawned.mission_ai:assigned_system = faction.capital

		var/ships_spawned = 0
		var/ships_to_spawn = STARTING_FACTION_WARSHIPS + rand(-5,5)
		var/list/f_list = SSship.faction2list(faction.cname)
		for(var/datum/star_system/system in faction.systems)
			for(var/i in 1 to system.danger_level)
				if(ships_spawned >= ships_to_spawn)
					break

				var/datum/starship/ship_to_spawn
				while(!ship_to_spawn)
					ship_to_spawn = pick(f_list)
					if(ship_to_spawn.operations_type)
						ship_to_spawn = null
					if(!prob(f_list[ship_to_spawn]))
						ship_to_spawn = null

				var/datum/starship/ship_spawned = SSship.create_ship(ship_to_spawn,faction.cname,system)
				ship_spawned.mission_ai = new /datum/ship_ai/guard
				ship_spawned.mission_ai:assigned_system = system //ew? search operator is yuck but best thing to do here
				ships_spawned++

		for(var/i in 1 to STARTING_FACTION_FLEETS)
			var/datum/star_system/system = pick(faction.systems)
			var/datum/starship/flagship

			while(!flagship)
				flagship = pick(f_list)
				if(flagship.operations_type)
					flagship = null
				if(!prob(f_list[flagship]))
					flagship = null

			flagship = SSship.create_ship(flagship,faction.cname,system)
			if(flagship.faction == "pirate")
				flagship.mission_ai = new /datum/ship_ai/patrol/roam
			else
				flagship.mission_ai = new /datum/ship_ai/patrol


			for(var/x in 1 to rand(5,8))
				var/datum/starship/ship_to_spawn
				while(!ship_to_spawn)
					ship_to_spawn = pick(f_list)
					if(ship_to_spawn.operations_type)
						ship_to_spawn = null
					if(!prob(f_list[ship_to_spawn]))
						ship_to_spawn = null

				ship_to_spawn = SSship.create_ship(ship_to_spawn,faction.cname,system)
				ship_to_spawn.flagship = flagship

				ship_to_spawn.mission_ai = new /datum/ship_ai/escort

		var/datum/star_system/capital_system = SSstarmap.capitals[faction.cname]
		if(capital_system)
			for(var/i in 1 to (STARTING_FACTION_MERCHANTS + rand(-2,2)))
				var/datum/starship/ship_to_spawn
				while(!ship_to_spawn)
					ship_to_spawn = pick(f_list)
					if(!ship_to_spawn.operations_type)
						ship_to_spawn = null
					if(!prob(f_list[ship_to_spawn]))
						ship_to_spawn = null

				SSship.create_ship(ship_to_spawn,faction.cname,capital_system)

		for(var/datum/star_system/system in faction.systems)
			var/list/possible_stations = list()
			for(var/datum/planet/planet in system.planets)
				if(planet.station)
					possible_stations += planet.station
			if(!possible_stations.len || system.capital_planet) //capital planets cause issues with freighter pathfinding
				continue
			system.primary_station = pick(possible_stations)
			var/highest_resource_num = 0

			for(var/datum/planet/planet in system.planets)
				if(planet.resource_type)
					if(system.primary_station.resources.Find(planet.resource_type))
						system.primary_station.resources[planet.resource_type] += rand(500,1000)
					else
						system.primary_station.resources += planet.resource_type
						system.primary_station.resources[planet.resource_type] = rand(500,1000)

					if(!system.primary_station.primary_resource)
						system.primary_station.primary_resource = planet.resource_type
						highest_resource_num = system.primary_station.resources[planet.resource_type]
					else if(system.primary_station.resources[planet.resource_type] > highest_resource_num)
						system.primary_station.primary_resource = planet.resource_type
						highest_resource_num = system.primary_station.resources[planet.resource_type]






			system.primary_station.is_primary = 1

		generate_galactic_prices()
		generate_faction_prices(faction)

		for(var/datum/star_system/system in faction.systems)
			generate_system_prices(system)










/datum/controller/subsystem/starmap/proc/spool_up() //wewlad this proc. Dunno any better way to do this though.
	. = 0
	ftl_is_spooling = 1
	ftl_can_cancel_spooling = 1
	minor_announce("FTL drive spool up sequence initiated. Brace for FTL translation in 60 seconds and ensure all crew are onboard the ship.","Warning! FTL spoolup initiated!")
	ftl_sound('sound/ai/ftl_spoolup.ogg')
	if(!ftl_sleep(30)) return
	ftl_message("<span class=notice>Initiating bluespace translation vector indice search. Calculating translation vectors...</span>")
	if(!ftl_sleep(70)) return
	if(prob(0.1)) //Failure during this stage is unlikely.
		ftl_message("<span class=warning>Indice search failed. 0 valid bluespace vectors enumerated.</span>")
		ftl_cancel()
		return
	ftl_message("<span class=notice>Indice search complete. [rand(1,100)] valid bluespace vectors enumerated.</span>")
	//t minus 50 seconds
	if(!ftl_sleep(10)) return
	ftl_message("<span class=notice>Calculating safest bluespace vector. [rand(1,30)] local unstable subspace vortices detected.</span>")
	if(!ftl_sleep(80)) return
	if(prob(1))
		ftl_message("<span class=warning>Departure vector calculation failed. 0 safe vectors detected. Initiating emergency cancellation.</span>")
		ftl_cancel()
		return
	ftl_message("<span class=notice>Departure vector calculation complete. Selected outbound vector: [num2hex(rand(1000,120000))]-[rand(0,999)]-BXS</span>")
	if(!ftl_sleep(20)) return
	//t minus 39 seconds
	ftl_message("<span class=notice>Finalizing calculations...</span>")
	if(!ftl_sleep(10)) return
	if(prob(1))
		ftl_message("<span class=warning>Data loss registered. Calculation failure.</span>")
		ftl_cancel()
		return
	ftl_message("<span class=notice>Calculations finalized. Commencing pre-translation equipment checks.</span>")
	if(!ftl_sleep(5)) return
	ftl_message("<span class=notice>Calibrating bluespace crystal array.</span>")
	if(!ftl_sleep(5)) return
	ftl_message("<span class=notice>Calibration complete. [max(0,rand(-20,10))] faults corrected.</span>")
	//t- 37s
	if(!ftl_sleep(5)) return
	ftl_message("<span class=notice>Testing bluespace surge protector failsafe sensitivities...</span>")
	if(!ftl_sleep(10)) return
	ftl_message("<span class=notice>Surge failsafes operating at regulation sensitivities.</span>")
	if(!ftl_sleep(25)) return
	ftl_message("<span class=notice>Equipment checks complete, commencing spool up sequence. Now unable to cancel the scheduled FTL translation safely.</span>")
	//33s You can't cancel the jump anymore now.
	ftl_sound('sound/effects/ftl_drone.ogg')
	ftl_can_cancel_spooling = 0
	sleep(5)
	ftl_message("<span class=notice>Charging flux capacitors...</span>") // :^)
	sleep(1)
	ftl_message("<span class=notice>Activating flux-bypass safety valves...</span>")
	sleep(1)
	ftl_message("<span class=notice>Powering up translation governor...</span>")
	sleep(1)
	ftl_message("<span class=notice>Deploying bluespace vortice stablizers...</span>")
	sleep(5)
	ftl_message("<span class=notice>Discharging pre-spool crystal arrays...</span>")
	sleep(4)
	ftl_message("<span class=notice>Aligning plasma resonance chamber injectors...</span>")
	sleep(3)
	ftl_message("<span class=notice>Commencing plasma injection sequence...</span>")
	ftl_sound('sound/effects/ftl_whistle.ogg')
	sleep(10)
	ftl_sound('sound/ai/ftl_30sec.ogg')
	sleep(20)
	//28s
	ftl_message("<span class=notice>Spooling main bluespace distortion arrays.</span>")
	sleep(130)
	ftl_sound('sound/ai/ftl_15sec.ogg')
	ftl_sound('sound/effects/ftl_rumble.ogg')
	ftl_rumble()
	//15s
	ftl_message("<span class=notice>Discharging main bluespace distortion arrays.</span>")
	sleep(50)
	ftl_sound('sound/ai/ftl_10sec.ogg')
	ftl_sound('sound/effects/ftl_swoop.ogg')
	sleep(70) //godspeed (want it to line up with the actual jump animation and such
	ftl_is_spooling = 0
	return 1
