///RUIN EVENTS, KEEP THEM ORGANIZED FROM COMMON TO EPIC IN DESCENDING ORDER//
//ELIGBLE FACTIONS: FTL_NEUTRAL, FTL_SOLGOV, FTL_NANOTRASEN, FTL_SYNDICATE, FTL_PIRATE, FTL_PLAYERSHIP//
/datum/ftl_event/ruin
	var/mapname //path to map
	event_type = RUIN

/datum/ftl_event/ruin/xenohive
	name = "Derelict ship"
	faction = FTL_NEUTRAL
	rarity = UNCOMMON_EVENT
	mapname = "events/ruins/xeno_hive.dmm"
