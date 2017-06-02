GLOBAL_VAR_INIT(admin_notice, "") // Admin notice that all clients see when joining the server

GLOBAL_VAR_INIT(timezoneOffset, 0) // The difference betwen midnight (of the host computer) and 0 world.ticks.

	// For FTP requests. (i.e. downloading runtime logs.)
	// However it'd be ok to use for accessing attack logs and such too, which are even laggier.
GLOBAL_VAR_INIT(fileaccess_timer, 0)

GLOBAL_VAR_INIT(TAB, "&nbsp;&nbsp;&nbsp;&nbsp;")

GLOBAL_DATUM_INIT(data_core, /datum/datacore, new)

GLOBAL_VAR_INIT(CELLRATE, 0.002)  // multiplier for watts per tick <> cell storage (eg: .002 means if there is a load of 1000 watts, 20 units will be taken from a cell per second)
GLOBAL_VAR_INIT(CHARGELEVEL, 0.001) // Cap for how fast cells charge, as a percentage-per-tick (.001 means cellcharge is capped to 1% per second)

GLOBAL_LIST_EMPTY(powernets)


GLOBAL_VAR_INIT(map_ready, 0)
/*
	basically, this will be used to avoid initialize() being called twice for objects
	initialize() is necessary because the map is instanced on a turf-by-turf basis
	i.e. all obj on a turf are instanced, then all mobs on that turf, before moving to the next turf (starting bottom-left)
	This means if we want to say, get any neighbouring objects in New(), only objects to the south and west will exist yet.
	Therefore, we'd need to use spawn() inside New() to wait for the surrounding turf contents to be instanced
	However, using lots of spawn() has a severe performance impact, and often results in spaghetti-code
	map_ready will be set to 1 when world/New() is called (which happens just after the map is instanced)
*/