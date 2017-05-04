var/datum/controller/subsystem/server_maint/SSserver

/datum/controller/subsystem/server_maint
	name = "Server Tasks"
	wait = 6000
	init_order = 19
	flags = SS_NO_TICK_CHECK|SS_NO_INIT

/datum/controller/subsystem/server_maint/New()
	NEW_SS_GLOBAL(SSserver)

/datum/controller/subsystem/server_maint/fire()
	//handle kicking inactive players
	if(config.kick_inactive > 0)
		for(var/client/C in clients)
			if(C.is_afk(INACTIVITY_KICK))
				if(!istype(C.mob, /mob/dead))
					log_access("AFK: [key_name(C)]")
					to_chat(C, "<span class='danger'>You have been inactive for more than 10 minutes and have been disconnected.</span>")
					del(C)

	if(config.sql_enabled)
		sql_record_stats()
