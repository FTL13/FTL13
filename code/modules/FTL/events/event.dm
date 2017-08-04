/datum/ftl_event
	var/name //Name of event
	var/description //flavor text for signal scanning
	var/event_state = FTL_EVENT_STATE_INITIATE //state of event
	var/event_type //Bitflag for type of event
	var/finished = FALSE
	var/severity //unused, will be used to set necesary danger level of the planet.
	var/rarity = NONE
	var/faction = FTL_NEUTRAL //defines for where the event can spawn FTL_NEUTRAL and FTL_PIRATE spawn anywhere,
	var/datum/planet/our_planet //reference to planet the datum is on
	var/list/ships_to_spawn //If an event should spawn ships, this is a list of which ships

/datum/ftl_event/proc/init_event() //Called on jump to planet
	return

/datum/ftl_event/proc/activate_event() //Called on arrival at planet
	SSstarmap.get_visible_events() //Sets the list of events currently available in the system
	return

/datum/ftl_event/proc/event_effects(var/state) //effects of an event, takes event_state so children can put that in a switch statement and get the results
	return

/datum/ftl_event/proc/finish_event() //Called when an event finishes
