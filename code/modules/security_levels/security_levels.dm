/var/security_level = 0
/var/previous_level = 0
//0 = code green
//1 = code amber
//2 = general quarters
//3 = code delta

//config.alert_desc_blue_downto

/proc/set_security_level(level)
	switch(level)
		if("green")
			level = SEC_LEVEL_GREEN
		if("blue")
			level = SEC_LEVEL_AMBER
		if("red")
			level = SEC_LEVEL_GQ
		if("delta")
			level = SEC_LEVEL_DELTA

	//Will not be announced if you try to set to the same level as it already is
	if(level >= SEC_LEVEL_GREEN && level <= SEC_LEVEL_DELTA && level != security_level)
		previous_level = security_level
		switch(level)
			if(SEC_LEVEL_GREEN)
				minor_announce(config.alert_desc_green, "Attention! Situation Green - All systems nominal.")
				security_level = SEC_LEVEL_GREEN
				for(var/obj/machinery/firealarm/FA in machines)
					if(FA.z == ZLEVEL_STATION)
						FA.update_icon()
			if(SEC_LEVEL_AMBER)
				if(security_level < SEC_LEVEL_AMBER)
					minor_announce(config.alert_desc_blue_upto, "Attention! Situation Amber - Martial Law",1)
				else
					minor_announce(config.alert_desc_blue_downto, "Attention! Situation Amber - Martial Law")
				security_level = SEC_LEVEL_AMBER
				for(var/obj/machinery/firealarm/FA in machines)
					if(FA.z == ZLEVEL_STATION)
						FA.update_icon()
			if(SEC_LEVEL_GQ)
				if(security_level < SEC_LEVEL_GQ)
					minor_announce(config.alert_desc_red_upto, "Attention! General Quarters - All hands to battle stations!",1)
				else
					minor_announce(config.alert_desc_red_downto, "Attention! General Quarters - All hands to battle staions!")
				security_level = SEC_LEVEL_GQ

				/*	- At the time of commit, setting status displays didn't work properly
				var/obj/machinery/computer/communications/CC = locate(/obj/machinery/computer/communications,world)
				if(CC)
					CC.post_status("alert", "redalert")*/

				for(var/obj/machinery/firealarm/FA in machines)
					if(FA.z == ZLEVEL_STATION)
						FA.update_icon()
				for(var/obj/machinery/computer/shuttle/pod/pod in machines)
					pod.admin_controlled = 0
			if(SEC_LEVEL_DELTA)
				minor_announce(config.alert_desc_delta, "Attention! Delta security level reached!",1)
				security_level = SEC_LEVEL_DELTA
				for(var/obj/machinery/firealarm/FA in machines)
					if(FA.z == ZLEVEL_STATION)
						FA.update_icon()
				for(var/obj/machinery/computer/shuttle/pod/pod in machines)
					pod.admin_controlled = 0
	else
		return

/proc/get_security_level()
	switch(security_level)
		if(SEC_LEVEL_GREEN)
			return "green"
		if(SEC_LEVEL_AMBER)
			return "blue"
		if(SEC_LEVEL_GQ)
			return "red"
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
		if("blue")
			return SEC_LEVEL_AMBER
		if("red")
			return SEC_LEVEL_GQ
		if("delta")
			return SEC_LEVEL_DELTA


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
