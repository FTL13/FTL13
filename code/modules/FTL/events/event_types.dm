/datum/ftl_event
	var/name = "event" //Name of event
	var/event_type //Type of event
	var/severity //unused, will be used to set necesary danger level of the planet.
	var/datum/event_communications //unused but will be datum that comes with the event which sets up the communications part of the event
	var/rarity
	var/faction //found in ship.dm
	var/list/ships_to_spawn

/datum/ftl_event/proc/activate_event()
	return

/datum/ftl_event/combat
	name = "Combat encounter"
	event_type = COMBAT
	rarity = COMMON
	faction = "syndicate"
	ships_to_spawn = list(/datum/starship/drone, /datum/starship/drone, /datum/starship/drone)

/datum/ftl_event/combat/activate_event()
	for(var/S in ships_to_spawn)
		SSship.create_ship(S, faction, SSstarmap.current_system, SSstarmap.current_planet)

/datum/ftl_event/combat/pirates
	name = "Pirate encounter"
	faction = "pirate"
	rarity = COMMON
	ships_to_spawn = list(/datum/starship/clanker, /datum/starship/clanker, /datum/starship/clanker)
