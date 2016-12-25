var/datum/subsystem/power/SSpower

/datum/subsystem/power
	name = "Power"
	flags = SS_KEEP_TIMING|SS_NO_INIT

	var/list/currentrun = list()
	var/list/processing = list()

/datum/subsystem/power/New()
	NEW_SS_GLOBAL(SSpower)

/datum/subsystem/power/stat_entry(msg)
	..("P:[processing.len]")

/datum/subsystem/power/fire(resumed = 0)
	if(!resumed)
		src.currentrun = processing.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(currentrun.len)
		var/datum/thing = currentrun[currentrun.len]
		currentrun.len--
		if(thing)
			thing.process()
		else
			processing.Remove(thing)
		if (MC_TICK_CHECK)
			return
