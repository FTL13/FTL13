//RUIN EVENTS ARE EVENTS THAT ALLOW YOU TO DOCK WITH A MAP AND EXPLORE IT//
//KEEP THEM ORGANIZED FROM COMMON TO EPIC IN DESCENDING ORDER//
//ELIGBLE FACTIONS: FTL_NEUTRAL, FTL_SOLGOV, FTL_NANOTRASEN, FTL_SYNDICATE, FTL_PIRATE, FTL_PLAYERSHIP//
/datum/ftl_event/ruin
	var/mapname //path to map
	shortname = "Unknown ruin"
	shortdesc = "A ruin abandoned here years, if not ages ago"
	longname = "Unknown ruin"
	longdesc = "A ruin abandoned here years, if not ages ago"
	event_type = RUIN

/datum/ftl_event/ruin/xenohive
	name = "Broken-up ship"
	description = "A broken up ship with weird resin sticking onto the hull, life sign detected from inside of the ship, caution is advised."
	shortname = "Derelict ship"
	shortdesc = "It seems to be an abandoned ship of unknown nature"
	faction = FTL_NEUTRAL
	rarity = UNCOMMON_EVENT
	mapname = "events/ruins/xeno_hive.dmm"


/datum/ftl_event/ruin/factory
	name = "Old factory"
	description = "It seems this place is an old abandoned factory"
	shortname = "Old factory"
	faction = FTL_NEUTRAL
	rarity = UNCOMMON_EVENT
	mapname = "events/ruins/factory_impact.dmm"
