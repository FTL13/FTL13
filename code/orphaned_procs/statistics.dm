/proc/sql_record_stats()
	if(!config.sql_enabled)
		return
	var/list/data = list()
	var/playercount = 0
	var/ghostcount = 0
	var/newplayercount = 0
	for(var/mob/M in GLOB.player_list)
		if(M.client)
			playercount++
			if(istype(M, /mob/dead/observer))
				ghostcount++
			if(M.client.player_age < 3)
				newplayercount++
	data["player_count"] = playercount
	data["new_player_count"] = newplayercount
	data["admin_count"] = admins.len
	data["ghost_count"] = ghostcount
	data["cpu"] = world.cpu
	data["power_generated"] = round(SSpower.last_total_gen_power)

	establish_db_connection()
	if(!dbcon.IsConnected())
		log_game("SQL ERROR during stat polling. Failed to connect.")
	else
		var/querytext = "INSERT INTO [format_table_name("stats")] (round_id, timestamp, stat_key, stat_val) VALUES "
		var/isfirst = 0
		for(var/key in data)
			if(!isfirst)
				isfirst = 1
			else
				querytext += ","
			querytext += "([round_number], Now(), '[key]', [data[key]])"
		var/DBQuery/query = dbcon.NewQuery(querytext)
		if(!query.Execute())
			var/err = query.ErrorMsg()
			log_game("SQL ERROR during stat polling. Error : \[[err]\]\n")

/proc/sql_report_round_start()
	// TODO
	if(!config.sql_enabled)
		return

/proc/sql_report_round_end()
	// TODO
	if(!config.sql_enabled)
		return

/proc/sql_report_death(mob/living/carbon/human/H)
	if(!config.sql_enabled)
		return
	if(!H)
		return
	if(!H.key || !H.mind)
		return

	var/turf/T = H.loc
	var/area/placeofdeath = get_area(T.loc)
	var/podname = placeofdeath.name

	var/sqlname = sanitizeSQL(H.real_name)
	var/sqlkey = sanitizeSQL(H.key)
	var/sqlpod = sanitizeSQL(podname)
	var/sqlspecial = sanitizeSQL(H.mind.special_role)
	var/sqljob = sanitizeSQL(H.mind.assigned_role)
	var/laname
	var/lakey
	if(H.lastattacker)
		laname = sanitizeSQL(H.lastattacker:real_name)
		lakey = sanitizeSQL(H.lastattacker:key)
	var/sqltime = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")
	var/coord = "[H.x], [H.y], [H.z]"
	//to_chat(world, "INSERT INTO death (name, byondkey, job, special, pod, tod, laname, lakey, gender, bruteloss, fireloss, brainloss, oxyloss) VALUES ('[sqlname]', '[sqlkey]', '[sqljob]', '[sqlspecial]', '[sqlpod]', '[sqltime]', '[laname]', '[lakey]', '[H.gender]', [H.bruteloss], [H.getFireLoss()], [H.brainloss], [H.getOxyLoss()])")
	establish_db_connection()
	if(!dbcon.IsConnected())
		log_game("SQL ERROR during death reporting. Failed to connect.")
	else
		var/DBQuery/query = dbcon.NewQuery("INSERT INTO [format_table_name("death")] (name, byondkey, job, special, pod, tod, laname, lakey, gender, bruteloss, fireloss, brainloss, oxyloss, coord) VALUES ('[sqlname]', '[sqlkey]', '[sqljob]', '[sqlspecial]', '[sqlpod]', '[sqltime]', '[laname]', '[lakey]', '[H.gender]', [H.getBruteLoss()], [H.getFireLoss()], [H.brainloss], [H.getOxyLoss()], '[coord]')")
		if(!query.Execute())
			var/err = query.ErrorMsg()
			log_game("SQL ERROR during death reporting. Error : \[[err]\]\n")


/proc/sql_report_cyborg_death(mob/living/silicon/robot/H)
	if(!config.sql_enabled)
		return
	if(!H)
		return
	if(!H.key || !H.mind)
		return

	var/turf/T = H.loc
	var/area/placeofdeath = get_area(T.loc)
	var/podname = placeofdeath.name

	var/sqlname = sanitizeSQL(H.real_name)
	var/sqlkey = sanitizeSQL(H.key)
	var/sqlpod = sanitizeSQL(podname)
	var/sqlspecial = sanitizeSQL(H.mind.special_role)
	var/sqljob = sanitizeSQL(H.mind.assigned_role)
	var/laname
	var/lakey
	if(H.lastattacker)
		laname = sanitizeSQL(H.lastattacker:real_name)
		lakey = sanitizeSQL(H.lastattacker:key)
	var/sqltime = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")
	var/coord = "[H.x], [H.y], [H.z]"
	//to_chat(world, "INSERT INTO death (name, byondkey, job, special, pod, tod, laname, lakey, gender, bruteloss, fireloss, brainloss, oxyloss) VALUES ('[sqlname]', '[sqlkey]', '[sqljob]', '[sqlspecial]', '[sqlpod]', '[sqltime]', '[laname]', '[lakey]', '[H.gender]', [H.bruteloss], [H.getFireLoss()], [H.brainloss], [H.getOxyLoss()])")
	establish_db_connection()
	if(!dbcon.IsConnected())
		log_game("SQL ERROR during death reporting. Failed to connect.")
	else
		var/DBQuery/query = dbcon.NewQuery("INSERT INTO [format_table_name("death")] (name, byondkey, job, special, pod, tod, laname, lakey, gender, bruteloss, fireloss, brainloss, oxyloss, coord) VALUES ('[sqlname]', '[sqlkey]', '[sqljob]', '[sqlspecial]', '[sqlpod]', '[sqltime]', '[laname]', '[lakey]', '[H.gender]', [H.getBruteLoss()], [H.getFireLoss()], [H.brainloss], [H.getOxyLoss()], '[coord]')")
		if(!query.Execute())
			var/err = query.ErrorMsg()
			log_game("SQL ERROR during death reporting. Error : \[[err]\]\n")




//This proc is used for feedback. It is executed at round end.
/proc/sql_commit_feedback()
	if(!blackbox)
		log_game("Round ended without a blackbox recorder. No feedback was sent to the database.")
		return

	//content is a list of lists. Each item in the list is a list with two fields, a variable name and a value. Items MUST only have these two values.
	var/list/datum/feedback_variable/content = blackbox.get_round_feedback()

	if(!content)
		log_game("Round ended without any feedback being generated. No feedback was sent to the database.")
		return

	establish_db_connection()
	if(!dbcon.IsConnected())
		log_game("SQL ERROR during feedback reporting. Failed to connect.")
	else

		var/DBQuery/max_query = dbcon.NewQuery("SELECT MAX(roundid) AS max_round_id FROM [format_table_name("feedback")]")
		max_query.Execute()

		var/newroundid

		while(max_query.NextRow())
			newroundid = max_query.item[1]

		if(!(isnum(newroundid)))
			newroundid = text2num(newroundid)

		if(isnum(newroundid))
			newroundid++
		else
			newroundid = 1

		for(var/datum/feedback_variable/item in content)
			var/variable = item.get_variable()
			var/value = item.get_value()

			var/DBQuery/query = dbcon.NewQuery("INSERT INTO [format_table_name("feedback")] (id, roundid, time, variable, value) VALUES (null, [newroundid], Now(), '[variable]', '[value]')")
			if(!query.Execute())
				var/err = query.ErrorMsg()
				log_game("SQL ERROR during feedback reporting. Error : \[[err]\]\n")
