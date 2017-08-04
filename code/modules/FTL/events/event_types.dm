/datum/ftl_event
	var/name = "event" //Name of event
	var/event_type //Type of event
	var/severity //unused, will be used to set necesary danger level of the planet.
	var/datum/event_communications //unused but will be datum that comes with the event which sets up the communications part of the event
	var/rarity = NONE
	var/faction = FTL_NEUTRAL //defines for where the event can spawn FTL_NEUTRAL and FTL_PIRATE spawn anywhere, generally speaking NT and SolGov do not have combat events. FTL_NEUTRAL and FTL_PLAYERSHIP
	var/list/ships_to_spawn

/datum/ftl_event/proc/activate_event()
	return


///COMBAT EVENTS, KEEP THEM ORGANIZED FROM COMMON TO EPIC IN DESCENDING ORDER//
/datum/ftl_event/combat
	name = "Combat encounter"

/datum/ftl_event/combat/activate_event()
	for(var/ship_type in ships_to_spawn)
		var/amount = ships_to_spawn[ship_type]
		var/ship = new ship_type
		for(var/i = 1 to amount)
			SSship.create_ship(ship, faction, SSstarmap.current_system, SSstarmap.current_planet)

/datum/ftl_event/combat/syndicate
	name = "Syndicate combat encounter"
	event_type = COMBAT
	rarity = COMMON_EVENT
	faction = FTL_SYNDICATE
	ships_to_spawn = list(/datum/starship/drone=3)

/datum/ftl_event/combat/pirate
	name = "Pirate Combat encounter"
	rarity = COMMON_EVENT
	faction = FTL_PIRATE
	ships_to_spawn = list(/datum/starship/clanker=3)

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
