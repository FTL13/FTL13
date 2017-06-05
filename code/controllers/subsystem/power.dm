SUBSYSTEM_DEF(power)
	name = "Power"
	flags = SS_KEEP_TIMING|SS_NO_INIT

	var/list/currentrun = list()
	var/list/processing = list()

	var/total_gen_power = 0
	var/last_total_gen_power = 0

/datum/controller/subsystem/power/stat_entry(msg)
	..("P:[processing.len]")

/datum/controller/subsystem/power/fire(resumed = 0)
	if(!resumed)
		src.currentrun = processing.Copy()
		last_total_gen_power = total_gen_power
		total_gen_power = 0
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
