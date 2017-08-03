/datum/ftl_event
	var/name = "event" //Name of event
	var/event_type //Type of event
	var/severity //unused, will be used to set necesary danger level of the planet.
	var/datum/event_communications //unused but will be datum that comes with the event which sets up the communications part of the event
	var/rarity
	var/faction = "syndicate" //found in ship.dm
	var/list/ships_to_spawn

/datum/ftl_event/proc/activate_event()
	return

/datum/ftl_event/combat
	name = "Combat encounter"
	event_type = COMBAT
	rarity = COMMON
	ships_to_spawn = (/datum/starship/drone=3)

/datum/ftl_event/combat/activate_event()
	for(var/ship_type in ships_to_spawn)
		var/amount = ships_to_spawn[ship_type]
		var/ship = ship_type
		for(var/i = 1 to amount)
			SSship.create_ship(ship, faction, SSstarmap.current_system, SSstarmap.current_planet)

/datum/ftl_event/combat/pirates
	name = "Pirate encounter"
	faction = "pirate"
	rarity = COMMON
	ships_to_spawn = (/datum/starship/clanker=3)
