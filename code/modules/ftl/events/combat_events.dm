//COMBAT EVENTS ARE SHIP TO SHIP COMBAT EVENTS//
//KEEP THEM ORGANIZED FROM COMMON TO EPIC IN DESCENDING ORDER//
//ELIGBLE FACTIONS: FTL_PIRATE, FTL_SYNDICATE//
/datum/ftl_event/combat
	event_type = COMBAT
	longvisible = FALSE

/datum/ftl_event/combat/syndicate
	name = "Syndicate Ships"
	description = "A fleet of Syndicate ships is spotted in orbit of the planet"
	rarity = COMMON_EVENT
	faction = FTL_SYNDICATE
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
	rarity = UNCOMMON_EVENT
	var/amount = 3
	ships_to_spawn = list()

/datum/ftl_event/combat/random/New()
	amount = rand(1, 3)
	for(var/i = 1 to amount)
		ships_to_spawn += pickweight(SSship.ship_weight_list)
