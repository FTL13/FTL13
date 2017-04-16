//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/var/const/access_security = 1 // Security equipment
/var/const/access_brig = 2 // Brig timers and permabrig
/var/const/access_armory = 3
/var/const/access_forensics_lockers = 4 //unused atm
/var/const/access_medical = 5
/var/const/access_genetics = 6
/var/const/access_engine = 7
/var/const/access_maint_tunnels = 8
/var/const/access_external_airlocks = 9
/var/const/access_emergency_storage = 10
/var/const/access_change_ids = 11
/var/const/access_heads = 12
/var/const/access_captain = 13
/var/const/access_all_personal_lockers = 14
/var/const/access_atmospherics = 15
/var/const/access_bar = 16
/var/const/access_kitchen = 17
/var/const/access_robotics = 18
/var/const/access_rd = 19
/var/const/access_cargo = 20
/var/const/access_chemistry = 21
/var/const/access_hydroponics = 22
/var/const/access_virology = 23
/var/const/access_cmo = 24
/var/const/access_surgery = 25
/var/const/access_research = 26
/var/const/access_mining = 27
/var/const/access_xenobiology = 28
/var/const/access_ce = 29
/var/const/access_xo= 30
/var/const/access_hos = 31
/var/const/access_RC_announce = 32 //Request console announcements
/var/const/access_tcomms = 33 // has access to the telecomms machinery
/var/const/access_engine_equip = 34
/var/const/access_munitions = 35
/var/const/access_literal_engine = 36
/var/const/access_morgue = 37
/var/const/access_sec_doors = 38
/var/const/access_janitor = 39
/var/const/access_waste = 40
/var/const/access_detective = 41
/var/const/access_helm = 42
/var/const/access_moffice = 43
/var/const/access_ai_chamber = 44
/var/const/access_weapons_console = 45
/var/const/access_helms_console = 46

	//BEGIN CENTCOM ACCESS
	/*Should leave plenty of room if we need to add more access levels.
/var/const/Mostly for admin fun times.
Unused; TODO: strip out
*/
/var/const/access_cent_general = 101//General facilities.
/var/const/access_cent_thunder = 102//Thunderdome.
/var/const/access_cent_specops = 103//Special Ops.
/var/const/access_cent_medical = 104//Medical/Research
/var/const/access_cent_living = 105//Living quarters.
/var/const/access_cent_storage = 106//Generic storage areas.
/var/const/access_cent_teleporter = 107//Teleporter.
/var/const/access_cent_captain = 109//Captain's office/ID comp/AI.
/var/const/access_cent_bar = 110 // The non-existent Centcom Bar

	//The Syndicate
/var/const/access_syndicate = 150//General Syndicate Access
/var/const/access_syndicate_leader = 151//Nuke Op Leader Access

/obj/var/list/req_access = null
/obj/var/req_access_txt = "0"
/obj/var/list/req_one_access = null
/obj/var/req_one_access_txt = "0"

//returns 1 if this mob has sufficient access to use this object
/obj/proc/allowed(mob/M)
	//check if it doesn't require any access at all
	if(src.check_access(null))
		return 1
	if(istype(M, /mob/living/silicon))
		//AI can do whatever he wants
		return 1
	if(IsAdminGhost(M))
		//Access can't stop the abuse
		return 1
	else if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		//if they are holding or wearing a card that has access, that works
		if(src.check_access(H.get_active_hand()) || src.check_access(H.wear_id))
			return 1
	else if(istype(M, /mob/living/carbon/monkey) || istype(M, /mob/living/carbon/alien/humanoid))
		var/mob/living/carbon/george = M
		//they can only hold things :(
		if(src.check_access(george.get_active_hand()))
			return 1
	else if(isanimal(M))
		var/mob/living/simple_animal/A = M
		if(check_access(A.access_card))
			return 1
	return 0

/obj/item/proc/GetAccess()
	return list()

/obj/item/proc/GetID()
	return null

/obj/proc/check_access(obj/item/I)
	//These generations have been moved out of /obj/New() because they were slowing down the creation of objects that never even used the access system.
	if(!src.req_access)
		src.req_access = list()
		if(src.req_access_txt)
			var/list/req_access_str = splittext(req_access_txt,";")
			for(var/x in req_access_str)
				var/n = text2num(x)
				if(n)
					req_access += n

	if(!src.req_one_access)
		src.req_one_access = list()
		if(src.req_one_access_txt)
			var/list/req_one_access_str = splittext(req_one_access_txt,";")
			for(var/x in req_one_access_str)
				var/n = text2num(x)
				if(n)
					req_one_access += n

	if(!istype(src.req_access, /list)) //something's very wrong
		return 1

	var/list/L = src.req_access
	if(!L.len && (!src.req_one_access || !src.req_one_access.len)) //no requirements
		return 1
	if(!I)
		return 0
	for(var/req in src.req_access)
		if(!(req in I.GetAccess())) //doesn't have this access
			return 0
	if(src.req_one_access && src.req_one_access.len)
		for(var/req in src.req_one_access)
			if(req in I.GetAccess()) //has an access from the single access list
				return 1
		return 0
	return 1


/obj/proc/check_access_list(list/L)
	if(!src.req_access  && !src.req_one_access)
		return 1
	if(!istype(src.req_access, /list))
		return 1
	if(!src.req_access.len && (!src.req_one_access || !src.req_one_access.len))
		return 1
	if(!L)
		return 0
	if(!istype(L, /list))
		return 0
	for(var/req in src.req_access)
		if(!(req in L)) //doesn't have this access
			return 0
	if(src.req_one_access && src.req_one_access.len)
		for(var/req in src.req_one_access)
			if(req in L) //has an access from the single access list
				return 1
		return 0
	return 1

/proc/get_centcom_access(job)
	switch(job)
		if("VIP Guest")
			return list(access_cent_general)
		if("Custodian")
			return list(access_cent_general, access_cent_living, access_cent_storage)
		if("Thunderdome Overseer")
			return list(access_cent_general, access_cent_thunder)
		if("Centcom Official")
			return list(access_cent_general, access_cent_living)
		if("Medical Officer")
			return list(access_cent_general, access_cent_living, access_cent_medical)
		if("Death Commando")
			return list(access_cent_general, access_cent_specops, access_cent_living, access_cent_storage)
		if("Research Officer")
			return list(access_cent_general, access_cent_specops, access_cent_medical, access_cent_teleporter, access_cent_storage)
		if("Special Ops Officer")
			return list(access_cent_general, access_cent_thunder, access_cent_specops, access_cent_living, access_cent_storage)
		if("Admiral")
			return get_all_centcom_access()
		if("Centcom Commander")
			return get_all_centcom_access()
		if("Emergency Response Team Commander")
			return get_ert_access("commander")
		if("Security Response Officer")
			return get_ert_access("sec")
		if("Engineer Response Officer")
			return get_ert_access("eng")
		if("Medical Response Officer")
			return get_ert_access("med")
		if("Centcom Bartender")
			return list(access_cent_general, access_cent_living, access_cent_bar)

/proc/get_all_accesses()
	return list(access_security, access_brig, access_armory, access_medical, access_genetics, access_morgue, access_rd, access_detective, access_sec_doors,
	            access_chemistry, access_engine, access_engine_equip, access_literal_engine, access_maint_tunnels, access_external_airlocks, access_change_ids,
	            access_heads, access_captain, access_all_personal_lockers, access_atmospherics, access_kitchen, access_janitor, access_waste, access_ai_chamber,
	            access_bar, access_robotics, access_cargo, access_munitions, access_hydroponics, access_virology, access_cmo, access_surgery, access_moffice, access_weapons_console,
	            access_research, access_mining, access_xenobiology, access_ce, access_xo, access_hos, access_RC_announce, access_tcomms, access_helm, access_helms_console)

/proc/get_all_centcom_access()
	return list(access_cent_general, access_cent_thunder, access_cent_specops, access_cent_medical, access_cent_living, access_cent_storage, access_cent_teleporter, access_cent_captain)

/proc/get_ert_access(class)
	switch(class)
		if("commander")
			return get_all_centcom_access()
		if("sec")
			return list(access_cent_general, access_cent_specops, access_cent_living)
		if("eng")
			return list(access_cent_general, access_cent_specops, access_cent_living, access_cent_storage)
		if("med")
			return list(access_cent_general, access_cent_specops, access_cent_medical, access_cent_living)

/proc/get_all_syndicate_access()
	return list(access_syndicate, access_syndicate)

/proc/get_region_accesses(code)
	switch(code)
		if(0)
			return get_all_accesses()
		if(1) //ship general
			return list(access_kitchen, access_bar, access_hydroponics, access_janitor, access_waste)
		if(2) //security
			return list(access_security, access_brig, access_armory, access_hos, access_munitions, access_detective)
		if(3) //medbay
			return list(access_medical, access_genetics, access_morgue, access_chemistry, access_virology, access_surgery, access_cmo)
		if(4) //research
			return list(access_research, access_robotics, access_xenobiology, access_rd)
		if(5) //engineering and maintenance
			return list(access_maint_tunnels, access_engine, access_engine_equip, access_literal_engine, access_external_airlocks, access_atmospherics, access_tcomms, access_ce)
		if(6) //supply
			return list(access_mining, access_cargo, access_munitions, access_waste, access_moffice)
		if(7) //command
			return list(access_heads, access_RC_announce, access_change_ids, access_all_personal_lockers, access_xo, access_captain, access_helm, access_ai_chamber, access_helms_console, access_weapons_console)

/proc/get_region_accesses_name(code)
	switch(code)
		if(0)
			return "All"
		if(1) //ship general
			return "General"
		if(2) //security
			return "Security"
		if(3) //medbay
			return "Medbay"
		if(4) //research
			return "Research"
		if(5) //engineering and maintenance
			return "Engineering"
		if(6) //supply
			return "Supply"
		if(7) //command
			return "Command"

/proc/get_access_desc(A)
	switch(A)
		if(access_cargo)
			return "Cargo Office"
		if(access_security)
			return "Security"
		if(access_brig)
			return "Holding Cells"
		if(access_medical)
			return "Medical"
		if(access_genetics)
			return "Genetics Lab"
		if(access_morgue)
			return "Morgue"
		if(access_chemistry)
			return "Chemistry Lab"
		if(access_rd)
			return "RD Office"
		if(access_bar)
			return "Bar"
		if(access_engine)
			return "Engineering"
		if(access_engine_equip)
			return "Engineering Equipment"
		if(access_maint_tunnels)
			return "Maintenance"
		if(access_external_airlocks)
			return "External Airlocks"
		if(access_change_ids)
			return "ID Console"
		if(access_heads)
			return "Outer Bridge"
		if(access_captain)
			return "Captain"
		if(access_all_personal_lockers)
			return "Personal Lockers"
		if(access_atmospherics)
			return "Atmospherics"
		if(access_armory)
			return "Armory"
		if(access_kitchen)
			return "Kitchen"
		if(access_hydroponics)
			return "Hydroponics"
		if(access_robotics)
			return "Robotics"
		if(access_virology)
			return "Virology"
		if(access_cmo)
			return "CMO Office"
		if(access_surgery)
			return "Surgery"
		if(access_research)
			return "Science"
		if(access_mining)
			return "Mining"
		if(access_xenobiology)
			return "Xenobiology Lab"
		if(access_xo)
			return "XO Office"
		if(access_hos)
			return "HoS Office"
		if(access_ce)
			return "CE Office"
		if(access_RC_announce)
			return "RC Announcements"
		if(access_tcomms)
			return "Telecommunications"
		if(access_sec_doors)
			return "Brig"
		if(access_literal_engine)
			return "Engine"
		if(access_munitions)
			return "Munitions"
		if(access_janitor)
			return "Custodial"
		if(access_waste)
			return "Waste Disposal"
		if(access_detective)
			return "Detective Office"
		if(access_helm)
			return "Bridge"
		if(access_moffice)
			return "MO Office"
		if(access_ai_chamber)
			return "AI Chamber"
		if(access_helms_console)
			return "Helms Console"
		if(access_weapons_console)
			return "Weapons Console"

/proc/get_centcom_access_desc(A)
	switch(A)
		if(access_cent_general)
			return "Code Grey"
		if(access_cent_thunder)
			return "Code Yellow"
		if(access_cent_storage)
			return "Code Orange"
		if(access_cent_living)
			return "Code Green"
		if(access_cent_medical)
			return "Code White"
		if(access_cent_teleporter)
			return "Code Blue"
		if(access_cent_specops)
			return "Code Black"
		if(access_cent_captain)
			return "Code Gold"
		if(access_cent_bar)
			return "Code Scotch"

/proc/get_all_jobs()
	return list("Assistant", "Captain", "Executive Officer", "Bartender", "Cook", "Botanist", "Quartermaster", "Cargo Technician",
				"Shaft Miner", "Clown", "Mime", "Janitor", "Librarian", "Lawyer", "Chaplain", "Chief Engineer", "Ship Engineer",
				"Atmospheric Technician", "Chief Medical Officer", "Medical Doctor", "Chemist", "Geneticist", "Virologist",
				"Research Director", "Scientist", "Roboticist", "Head of Security", "Warden", "Detective", "Security Officer", "Bridge Officer")

/proc/get_all_job_icons() //For all existing HUD icons
	return get_all_jobs() + list("Prisoner")

/proc/get_all_centcom_jobs()
	return list("VIP Guest","Custodian","Thunderdome Overseer","Centcom Official","Medical Officer","Death Commando","Research Officer","Special Ops Officer","Admiral","Centcom Commander","Emergency Response Team Commander","Security Response Officer","Engineer Response Officer", "Medical Response Officer","Centcom Bartender")

/obj/item/proc/GetJobName() //Used in secHUD icon generation
	var/obj/item/weapon/card/id/I = GetID()
	if(!I)
		return
	var/jobName = I.assignment
	if(jobName in get_all_job_icons()) //Check if the job has a hud icon
		return jobName
	if(jobName in get_all_centcom_jobs()) //Return with the NT logo if it is a Centcom job
		return "Centcom"
	return "Unknown" //Return unknown if none of the above apply
