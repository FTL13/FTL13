/datum/objective/ftl/find_target()
	update_explanation_text()

/datum/objective/ftl/killships
	var/ship_count
	var/faction
	var/ships_killed = 0

/datum/objective/ftl/killships/find_target()
	ship_count = rand(5,10)
	if(prob(25))
		faction = "pirate"
	else
		faction = "syndicate"
	..()

/datum/objective/ftl/killships/update_explanation_text()
	explanation_text = "Destroy [ship_count] [faction] ships."

/datum/objective/ftl/killships/check_completion()
	if(ships_killed >= ship_count)
		return 1
	return 0

/datum/objective/ftl/delivery
	var/has_purchased_item = 0
	var/obj/delivery_item
	var/item_name = ""
	var/datum/planet/source_planet
	var/datum/planet/target_planet
	var/list/delivery_types = list("syndicate intelligence documents" = 1, "the volatile bomb" = 1)

/datum/objective/ftl/delivery/find_target()
	var/datum/supply_pack/delivery_mission/U = SSshuttle.supply_packs[/datum/supply_pack/delivery_mission]
	if(!U)
		SSshuttle.supply_packs[/datum/supply_pack/delivery_mission] = new /datum/supply_pack/delivery_mission
		U = SSshuttle.supply_packs[/datum/supply_pack/delivery_mission]
	var/obj_type

	item_name = pickweight(delivery_types)
	var/searching_planets = TRUE
	if(item_name == "syndicate intelligence documents")
		while(searching_planets) //Only use this when we deal with a system that we don't want the players to go to without admin permission
			source_planet = SSstarmap.pick_station("syndicate")
			if(!istype(source_planet.parent_system,/datum/star_system/capital/syndicate)) //Dolos check
				searching_planets = FALSE
		obj_type = /obj/item/documents/syndicate
		item_name = "syndicate intelligence documents"
		target_planet = SSstarmap.pick_station("nanotrasen")
	else //if(item_name == "the volatile bomb") //future
		source_planet = SSstarmap.pick_station("nanotrasen")
		obj_type = /obj/structure/volatile_bomb
		item_name = "the volatile bomb"
		searching_planets = TRUE
		while(searching_planets) //Only use this when we deal with a system that we don't want the players to go to without admin permission
			target_planet = SSstarmap.pick_station("syndicate") //I don't get why we haul a bomb from NT to NT, so lets take it to the Syndicate
			if(!istype(target_planet.parent_system,/datum/star_system/capital/syndicate)) //Dolos check
				searching_planets = FALSE

	U.objective = src
	U.contains = list(obj_type)
	U.crate_name = "[item_name] crate"
	U.name = item_name
	source_planet.station.stock[U.type] = 1
	..()

/datum/objective/ftl/delivery/update_explanation_text()
	explanation_text = "Pick up [item_name] from the station at [source_planet.name] and deliver them to the station at [target_planet.name]."

/datum/objective/ftl/delivery/check_completion()
	if(completed || failed)
		return completed
	if(has_purchased_item && (!delivery_item || delivery_item.gc_destroyed))
		failed = 1
		return 0
	if(!has_purchased_item)
		return 0
	var/turf/T = get_turf(delivery_item)
	if(istype(T.loc, /area/no_entry/delivery) && SSmapping.z_level_alloc["[T.z]"] == target_planet)
		completed = 1
		qdel(delivery_item)
		return 1

/datum/objective/ftl/boardship
	var/datum/star_faction/target_faction
	var/datum/starship/ship_target
	var/boarding_progress = BOARDING_MISSION_UNSTARTED

/datum/objective/ftl/boardship/find_target()
	if(prob(25))
		target_faction = SSship.cname2faction("pirate")
	else
		target_faction = SSship.cname2faction("syndicate")
	var/searching = TRUE
	while(searching)
		ship_target = pick(target_faction.ships)
		if(ship_target.boarding_chance) //Can we even board it?
			if(!istype(ship_target.system,/datum/star_system/capital/syndicate)) //Dolos check
				if(ship_target.mission_ai != /datum/ship_ai/escort) //Is the target busy escorting?
					searching = FALSE
					ship_target.system.forced_boarding = ship_target
					ship_target.mission_ai = new /datum/ship_ai/guard //Stop the ship from leaving the current system
					var/datum/ship_ai/guard/AI = ship_target.mission_ai
					if(ship_target.ftl_vector) //Is the ship jumping somewhere?
						AI.assigned_system = ship_target.ftl_vector //If so, use the jump target
					else //Otherwise, use current system
						AI.assigned_system = ship_target.system
					AI.assigned_system.forced_boarding = ship_target //Sets up all the vars for boarding
	..()

/datum/objective/ftl/boardship/update_explanation_text()
	explanation_text = "Board and download flight data from [ship_target] (owned by the [ship_target.faction]), currently guarding [ship_target.mission_ai:assigned_system]."

/datum/objective/ftl/boardship/check_completion()
	if(boarding_progress == BOARDING_MISSION_SUCCESS)
		return TRUE
	if(!ship_target && !SSstarmap.mode) //Did the target get destroyed already/ Did the crew run from the objective?
		failed = TRUE
	return FALSE

/datum/objective/ftl/trade
	var/target_credits = 0
	var/max_credits_held = 0

/datum/objective/ftl/trade/find_target()
	target_credits = SSshuttle.points + rand(80000,150000)
	..()

/datum/objective/ftl/trade/update_explanation_text()
	explanation_text = "Increase ship funds to [target_credits]. Upon completion you are free to spend as you wish."

/datum/objective/ftl/trade/check_completion()
	if(SSshuttle.points > max_credits_held)
		max_credits_held = SSshuttle.points
	if(max_credits_held >= target_credits)
		return TRUE
	else
		return FALSE

/datum/objective/ftl/hold_system
	var/datum/star_system/target_system
	var/faction = "syndicate"
	var/list/spawnable_ships = list()
	var/holding_system //If they run, they fail the objective
	var/total_waves
	var/current_wave = 1
	var/wave_active = FALSE
	var/ships_remaining = -1
	var/next_wave_start_time

/datum/objective/ftl/hold_system/find_target()
	var/searching = TRUE
	var/datum/star_faction/F = SSship.cname2faction(faction)
	while(searching)
		target_system = pick(F.systems)
		if(!istype(target_system,/datum/star_system/capital/syndicate)) //Dolos check
			searching = FALSE
	total_waves = rand(2,7)
	faction = target_system.alignment
	spawnable_ships = SSship.faction2list(faction)
	for(var/datum/starship/S in spawnable_ships) //Removes merchant ships
		if(S.operations_type)
			spawnable_ships -= S
	..()

/datum/objective/ftl/hold_system/update_explanation_text()
	if(!holding_system)
		explanation_text = "Travel to [target_system] (owned by [faction]) and cause a significant distraction for CC to commence operation |REDACTED|. This should take about [total_waves] waves of reinforcements to complete."
	else
		explanation_text = "Distress signal spoofed to their fleets. Hold [target_system] until operation |REDACTED| is completed. ([current_wave]/[total_waves])."

/datum/objective/ftl/hold_system/proc/manage_waves()
	if(current_wave >= total_waves)
		return TRUE
	if(!holding_system && SSstarmap.current_system == target_system) //They have just arrived, start the waves
		holding_system = TRUE
		next_wave_start_time = world.time + rand(500,1000)
		update_explanation_text()
	else if(holding_system && !completed)
		if(holding_system && SSstarmap.current_system != target_system)
			failed = TRUE //They ran
		if(!wave_active && next_wave_start_time <= world.time)
			wave_active = TRUE
			ships_remaining = rand(1,2+current_wave) + current_wave//Leads to more intense waves towards the end
			for(var/C in 1 to ships_remaining)
				var/datum/starship/ship_to_spawn = pickweight(spawnable_ships)
				var/datum/starship/ship_spawned = SSship.create_ship(ship_to_spawn,faction,target_system)
				ship_spawned.mission_ai = new /datum/ship_ai/guard/
				var/datum/ship_ai/guard/AI = ship_spawned.mission_ai
				AI.assigned_system = target_system
				ship_spawned.boarding_chance = -1 //Stops boarding on all these ships. They don't need distracting.
		else if(!ships_remaining && wave_active)
			if(current_wave < total_waves)
				wave_active = FALSE
				next_wave_start_time = world.time + rand(100,300)
				current_wave++
				update_explanation_text()
	return FALSE

/datum/objective/ftl/hold_system/check_completion()
	if(manage_waves())
		return TRUE
	else
		return FALSE

/datum/objective/ftl/gohome
	var/datum/star_system/target_system

/datum/objective/ftl/gohome/find_target()
	target_system = SSstarmap.capitals["nanotrasen"]
	..()

/datum/objective/ftl/gohome/update_explanation_text()
	explanation_text = "Return to the nanotrasen capital at [target_system] for debriefing and crew transfer."

/datum/objective/ftl/gohome/check_completion()
	if(target_system == SSstarmap.current_system)
		SSticker.force_ending = 1
		return 1
