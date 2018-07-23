/datum/ftl_event
	//Flavor text//
	var/name //Name of event
	var/description //flavor text for signal scanning
	var/shortname = "Unknown signal" //name for scanner on short range distance TODO: ADD THIS TO NAV CONSOLE
	var/longname = "Unknown signal" //name for scanner on long range distance //TODO: ADD THIS TO NAV CONSOLE
	var/shortdesc = "We have no clue what we could find out here" //name for scanner on long range distance TODO: ADD THIS TO NAV CONSOLE
	var/longdesc = "We have no clue what we could find out here" //flavor text for scanner on long range distance TODO: ADD THIS TO NAV CONSOLE
	//Flavor visibility//
	var/shortvisible = TRUE //Can you see this event from a short distance on the scanner?
	var/longvisible = TRUE //Can you see this event from a long distance on the scanner?
	//Event Type, Rarity and Faction bitflags//
	var/event_type = NONE //Bitflag for type of event
	var/rarity = COMMON_EVENT //rarity
	var/faction = FTL_NEUTRAL //defines for where the event can spawn FTL_NEUTRAL and FTL_PIRATE spawn anywhere,

	var/datum/planet/our_planet //reference to planet the datum is on

	var/list/ships_to_spawn //If an event should spawn ships, this is a list of which ships

/datum/ftl_event/New(planet)
	our_planet = planet

/datum/ftl_event/proc/init_event() //Called on jump to planet
	return

/datum/ftl_event/proc/activate_event() //Called on arrival at planet
	spawn_ships()
	return

/datum/ftl_event/proc/spawn_ships()
	. = ..()
	for(var/ship_type in ships_to_spawn)
		var/amount = ships_to_spawn[ship_type]
		var/ship = new ship_type
		for(var/i = 1 to amount)
			var/datum/starship/S = SSship.create_ship(ship, faction, SSstarmap.current_system, our_planet)
			S.mission_ai = new /datum/ship_ai/guard //Ensures our new ship doesn't fuck off to another planet or system
		return
