/datum/ftl_event
	//Flavor text//
	var/name //Name of event
	var/description //flavor text for signal scanning
	var/shortname = "Unknown signal" //name for scanner on short range distance
	var/longname = "Unknown signal"
	var/shortdesc = "We have no clue what we could find out here" //name for scanner on long range distance
	var/longdesc = "We have no clue what we could find out here" //flavor text for scanner on long range distance
	//Flavor visibility//
	var/shortvisible = TRUE //Can you see this event from a short distance on the scanner?
	var/longvisible = TRUE //Can you see this event from a long distance on the scanner?
	//Event Type, Rarity and Faction bitflags//
	var/event_type = NONE //Bitflag for type of event
	var/rarity = NONE
	var/faction = FTL_NEUTRAL //defines for where the event can spawn FTL_NEUTRAL and FTL_PIRATE spawn anywhere,

	var/datum/planet/our_planet //reference to planet the datum is on

	//Effects//
	var/list/possible_actions = list()//List of possible actions, should be datums of /datum/ftl_event_action. Empty means you cannot do anything but return back to the previous menu
	var/list/action_instances = list()
	var/timer //timer till we pick the default option effects
	var/timer_length = 60 //Time till it defaults to the first possible_action
	var/timer_enabled = FALSE //Set to true if you want it to pick the default option after 120 seconds.
	var/list/ships_to_spawn //If an event should spawn ships, this is a list of which ships

/datum/ftl_event/New(planet) //Called on jump to planet
	for(var/T in possible_actions)
		var/datum/ftl_event_action/A = new T
		A.our_event = src
		action_instances += A
	our_planet = planet

/datum/ftl_event/proc/init_event() //Called on jump to planet
	return

/datum/ftl_event/proc/activate_event() //Called on arrival at planet
	if(possible_actions && timer_enabled)
		timer = addtimer(CALLBACK(possible_actions[1], /datum/ftl_event_action.proc/activate), 120, TIMER_STOPPABLE)
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
