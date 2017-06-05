GLOBAL_VAR_INIT(security_level, 0)
GLOBAL_VAR_INIT(previous_level, 0)
//0 = code green
//1 = code amber
//2 = general quarters
//3 = code delta

//config.alert_desc_blue_downto

/proc/set_security_level(level)
	switch(level)
		if("green")
			level = SEC_LEVEL_GREEN
		if("amber")
			level = SEC_LEVEL_AMBER
		if("general quarters")
			level = SEC_LEVEL_GQ
		if("delta")
			level = SEC_LEVEL_DELTA

	//Will not be announced if you try to set to the same level as it already is
	if(level >= SEC_LEVEL_GREEN && level <= SEC_LEVEL_DELTA && level != GLOB.security_level)
		switch(level)
			if(SEC_LEVEL_GREEN)
				minor_announce(config.alert_desc_green, "Attention! Situation Green - All systems nominal.")
				if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
					if(GLOB.security_level >= SEC_LEVEL_DELTA)
						SSshuttle.emergency.modTimer(4)
					else
						SSshuttle.emergency.modTimer(2)
				GLOB.security_level = SEC_LEVEL_GREEN
				for(var/obj/machinery/firealarm/FA in GLOB.machines)
					if(FA.z == ZLEVEL_STATION)
						FA.update_icon()
			if(SEC_LEVEL_AMBER)
				if(GLOB.security_level < SEC_LEVEL_AMBER)
					minor_announce(config.alert_desc_blue_upto, "Attention! Situation Amber - Martial Law",1)
					if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
						SSshuttle.emergency.modTimer(0.5)
				else
					minor_announce(config.alert_desc_blue_downto, "Attention! Situation Amber - Martial Law")
					if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
						SSshuttle.emergency.modTimer(2)
				GLOB.security_level = SEC_LEVEL_AMBER
				for(var/obj/machinery/firealarm/FA in GLOB.machines)
					if(FA.z == ZLEVEL_STATION)
						FA.update_icon()
			if(SEC_LEVEL_GQ)
				if(GLOB.security_level < SEC_LEVEL_DELTA)
					minor_announce(config.alert_desc_red_upto, "All hands! General Quarters - Man your battle stations!",1)
					if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
						if(GLOB.security_level == SEC_LEVEL_GREEN)
							SSshuttle.emergency.modTimer(0.25)
						else
							SSshuttle.emergency.modTimer(0.5)
				else
					minor_announce(config.alert_desc_red_downto, "All hands! General Quarters - Man your battle stations!")
				GLOB.security_level = SEC_LEVEL_GQ

				/*	- At the time of commit, setting status displays didn't work properly
				var/obj/machinery/computer/communications/CC = locate(/obj/machinery/computer/communications,world)
				if(CC)
					CC.post_status("alert", "redalert")*/

				for(var/obj/machinery/firealarm/FA in GLOB.machines)
					if(FA.z == ZLEVEL_STATION)
						FA.update_icon()
				for(var/obj/machinery/computer/shuttle/pod/pod in GLOB.machines)
					pod.admin_controlled = 0
				for(var/obj/machinery/computer/ftl_weapons/ftl_weapons in GLOB.machines)
					ftl_weapons.general_quarters = TRUE
				for(var/obj/machinery/computer/ftl_navigation/ftl_navigation in GLOB.machines)
					ftl_navigation.general_quarters = TRUE
			if(SEC_LEVEL_DELTA)
				minor_announce(config.alert_desc_delta, "Attention! Delta security level reached!",1)
				if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
					if(GLOB.security_level == SEC_LEVEL_GREEN)
						SSshuttle.emergency.modTimer(0.25)
					else if(GLOB.security_level == SEC_LEVEL_AMBER)
						SSshuttle.emergency.modTimer(0.5)
				GLOB.security_level = SEC_LEVEL_DELTA
				for(var/obj/machinery/firealarm/FA in GLOB.machines)
					if(FA.z == ZLEVEL_STATION)
						FA.update_icon()
				for(var/obj/machinery/computer/shuttle/pod/pod in GLOB.machines)
					pod.admin_controlled = 0
		for(var/area/shuttle/ftl/F in world)
			for(var/mob/living/L in F)
				F.update_ship_ambience(L) //update the alert sound in progress
	else
		return

/proc/get_security_level()
	switch(GLOB.security_level)
		if(SEC_LEVEL_GREEN)
			return "green"
		if(SEC_LEVEL_AMBER)
			return "amber"
		if(SEC_LEVEL_GQ)
			return "general quarters"
		if(SEC_LEVEL_DELTA)
			return "delta"

/proc/num2seclevel(num)
	switch(num)
		if(SEC_LEVEL_GREEN)
			return "green"
		if(SEC_LEVEL_AMBER)
			return "amber"
		if(SEC_LEVEL_GQ)
			return "general quarters"
		if(SEC_LEVEL_DELTA)
			return "delta"

/proc/seclevel2num(seclevel)
	switch( lowertext(seclevel) )
		if("green")
			return SEC_LEVEL_GREEN
		if("amber")
			return SEC_LEVEL_AMBER
		if("general quarters")
			return SEC_LEVEL_GQ
		if("delta")
			return SEC_LEVEL_DELTA

/proc/play_level_sound(seclevel)
	switch(lowertext(seclevel))
		if("general quarters")
			return 'sound/effects/purge_siren.ogg'
		if("delta")
			return 'sound/effects/siren.ogg'
	return null



/*DEBUG
/mob/verb/set_thing0()
	set_security_level(0)
/mob/verb/set_thing1()
	set_security_level(1)
/mob/verb/set_thing2()
	set_security_level(2)
/mob/verb/set_thing3()
	set_security_level(3)
*/
