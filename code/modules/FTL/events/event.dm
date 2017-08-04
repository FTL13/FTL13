/datum/ftl_event
	var/name //Name of event
	var/event_type //Bitflag for type of event
	var/severity //unused, will be used to set necesary danger level of the planet.
	var/datum/event_communications //unused but will be datum that comes with the event which sets up the communications part of the event
	var/rarity = NONE
	var/faction = FTL_NEUTRAL //defines for where the event can spawn FTL_NEUTRAL and FTL_PIRATE spawn anywhere,
	var/datum/planet/our_planet //reference to planet the datum is on
	var/list/ships_to_spawn //If an event should spawn ships, this is a list of which ships

/datum/ftl_event/proc/init_event() //Called on jump to planet
	return

/datum/ftl_event/proc/activate_event() //Called on arrival at planet
	return
