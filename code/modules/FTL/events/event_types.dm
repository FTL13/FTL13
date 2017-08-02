/datum/ftl_event
	var/name = "event" //Name of event
	var/event_type //Type of event
	var/severity //unused, will be used to set necesary danger level of the planet.
	var/datum/event_communications //unused but will be datum that comes with the event which sets up the communications part of the event
	var/rarity
	var/faction

/datum/ftl_event/combat
	name = "Combat encounter"
	event_type = COMBAT
	rarity = COMMON
	var/faction = "pirates"
	var/list/ships_to_spawn

/datum/ftl_event/combat/pirates
	faction = "pirates"
	ships_to_spawn
