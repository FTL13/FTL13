//COMBAT EVENTS ARE SHIP TO SHIP COMBAT EVENTS//
//KEEP THEM ORGANIZED FROM COMMON TO EPIC IN DESCENDING ORDER//
//ELIGBLE FACTIONS: FTL_PIRATE, FTL_SYNDICATE//
/datum/ftl_event/combat
	event_type = COMBAT
	longvisible = FALSE
	var/timer
	var/canbribe = TRUE

/datum/ftl_event/combat/init_event()
	. = ..()
	event_effects(FTL_EVENT_STATE_STARTCOUNTDOWN)

/datum/ftl_event/combat/event_effects(state)
	. = ..()
	event_state = state
	switch(event_state)
		if(FTL_EVENT_STATE_INITIATE)
			message_admins("gallow")
		if(FTL_EVENT_STATE_STARTCOUNTDOWN)
			timer = addtimer(CALLBACK(src, .proc/event_effects, FTL_EVENT_STATE_ENGAGECOMBAT), 120, TIMER_STOPPABLE)
		if(FTL_EVENT_STATE_ENGAGECOMBAT)
			for(var/ship_type in ships_to_spawn)
				var/amount = ships_to_spawn[ship_type]
				var/ship = new ship_type
				for(var/i = 1 to amount)
					var/datum/starship/S = SSship.create_ship(ship, faction, SSstarmap.current_system, our_planet)
					S.mission_ai = new /datum/ship_ai/guard //Ensures our new ship doesn't fuck off to another planet or system
			finish_event()
		if(FTL_EVENT_STATE_AVOIDCOMBAT)
			message_admins("tit2")
			finish_event()
		if(FTL_EVENT_STATE_BRIBECOMBAT)
			message_admins("tit3")
			finish_event()
	return

/datum/ftl_event/combat/finish_event()
	if(timer)
		deltimer(timer)
	finished = TRUE

/datum/ftl_event/combat/syndicate
	name = "Syndicate Ships"
	description = "A fleet of Syndicate ships is spotted in orbit of the planet"
	rarity = COMMON_EVENT
	faction = FTL_SYNDICATE
	canbribe = FALSE
	ships_to_spawn = list(/datum/starship/drone=3)

/datum/ftl_event/combat/pirate
	name = "Pirate ship"
	description = "A pirate ship is spotted in orbit of the planet"
	rarity = COMMON_EVENT
	faction = FTL_PIRATE
	ships_to_spawn = list(/datum/starship/clanker=1)

/datum/ftl_event/combat/random
	name = "Pirate ships"
	description = "An assortment of pirate ships is spotted in orbit of the planet, It seems like they stole these ships somewhere."
	faction = FTL_PIRATE
	rarity = 	UNCOMMON_EVENT
	var/amount
	ships_to_spawn = list()

/datum/ftl_event/combat/random/New()
	amount = rand(1, 3)
	for(var/i = 1 to amount)
		ships_to_spawn = pickweight(SSship.ship_weight_list)
