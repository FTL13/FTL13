/proc/load_mentors(target = null)
	//clear the datums references
	if(!target)
		for(var/client/C in GLOB.mentors)
			C.remove_admin_verbs()
			C.holder = null
		GLOB.mentors.Cut()
	if(!config.mentor_legacy_system)
		if(!SSdbcore.IsConnected())
			log_world("Failed to connect to database in load_mentors().")
			config.mentor_legacy_system = 1
			load_mentors()
			return

		var/datum/DBQuery/query = SSdbcore.NewQuery("SELECT ckey FROM [format_table_name("mentor")]")
		query.Execute()
		while(query.NextRow())
			var/ckey = ckey(query.item[1])
			var/datum/mentors/D = new(ckey)				//create the mentor datum and store it for later use
			if(!D)  //will occur if an invalid rank is provided
				continue
			D.associate(GLOB.directory[ckey])	//find the client for a ckey if they are connected and associate them with the new mentor datum
	else
		log_world("Using legacy mentor system.")
		var/list/Lines = world.file2list("config/mentors.txt")

		//process each line seperately
		for(var/line in Lines)
			if(!length(line))
				continue
			if(findtextEx(line,"#",1,2))
				continue

			//ckey is before the first "="
			var/ckey = ckey(line)
			if(!ckey)
				continue

			var/datum/mentors/D = new(ckey)	//create the mentor datum and store it for later use
			if(!D) //will occur if an invalid rank is provided
				continue
			D.associate(GLOB.directory[ckey])	//find the client for a ckey if they are connected and associate them with the new mentor datum

	#ifdef TESTING
	var/msg = "mentors Built:\n"
	for(var/ckey in GLOB.mentor_datums)
		msg += "\t[ckey] - mentor\n"
	testing(msg)
	#endif
