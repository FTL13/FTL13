///COMBAT EVENTS, KEEP THEM ORGANIZED FROM COMMON TO EPIC IN DESCENDING ORDER//
//ELIGBLE FACTIONS: FTL_PIRATE, FTL_SYNDICATE//
/datum/ftl_event/combat
	event_type = COMBAT

/datum/ftl_event/combat/activate_event()
	for(var/ship_type in ships_to_spawn)
		var/amount = ships_to_spawn[ship_type]
		var/ship = new ship_type
		for(var/i = 1 to amount)
			SSship.create_ship(ship, faction, SSstarmap.current_system, our_planet)

/datum/ftl_event/combat/syndicate
	name = "Syndicate combat encounter"
	rarity = COMMON_EVENT
	faction = FTL_SYNDICATE
	ships_to_spawn = list(/datum/starship/drone=3)

/datum/ftl_event/combat/pirate
	name = "Pirate Combat encounter"
	rarity = COMMON_EVENT
	faction = FTL_PIRATE
	ships_to_spawn = list(/datum/starship/clanker=1)

/datum/ftl_event/combat/random
	name = "Random combat encounter"
	faction = FTL_PIRATE
	rarity = 	UNCOMMON_EVENT
	var/amount
	ships_to_spawn = list()

/datum/ftl_event/combat/random/New()
	amount = rand(1, 3)
	for(var/i = 1 to amount)
		ships_to_spawn = pickweight(SSship.ship_weight_list)
