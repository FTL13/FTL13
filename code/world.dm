/var/round_number = 0

/world
	mob = /mob/dead/new_player
	turf = /turf/open/space/basic
	area = /area/space
	view = "15x15"
	cache_lifespan = 7
	hub = "Exadv1.spacestation13"
	hub_password = "kMZy3U5jJHSiBQjr"
	name = "/tg/ Station 13"
	fps = 20
	visibility = 0
#ifdef GC_FAILURE_HARD_LOOKUP
	loop_checks = FALSE
#endif

/world/New()
<<<<<<< HEAD
	log_world("World loaded at [time_stamp()]")
=======
	check_for_cleanbot_bug()
	map_ready = 1
	space_manager.initialize()
>>>>>>> master

#if (PRELOAD_RSC == 0)
	external_rsc_urls = world.file2list("config/external_rsc_urls.txt","\n")
	var/i=1
	while(i<=external_rsc_urls.len)
		if(external_rsc_urls[i])
			i++
		else
			external_rsc_urls.Cut(i,i+1)
#endif
<<<<<<< HEAD
	GLOB.config_error_log = file("data/logs/config_error.log") //temporary file used to record errors with loading config, moved to log directory once logging is set bl
=======
	//logs
	var/date_string = time2text(world.realtime, "YYYY/MM-Month/DD-Day")
	href_logfile = file("data/logs/[date_string] hrefs.htm")
	diary = file("data/logs/[date_string].log")
	diaryofmeanpeople = file("data/logs/[date_string] Attack.log")
	diary << "\n\nStarting up. [time2text(world.timeofday, "hh:mm.ss")]\n---------------------"
	diaryofmeanpeople << "\n\nStarting up. [time2text(world.timeofday, "hh:mm.ss")]\n---------------------"
	changelog_hash = md5('html/changelog.html')					//used for telling if the changelog has changed recently

	var/roundfile = file("data/roundcount.txt")
	round_number = text2num(file2text(roundfile))
	if(round_number == null || round_number == "" || round_number == 0)
		round_number = 1
	else
		round_number++
	fdel(roundfile)
	text2file(num2text(round_number), roundfile)

>>>>>>> master
	make_datum_references_lists()	//initialises global lists for referencing frequently used datums (so that we only ever do it once)
	config = new
	GLOB.log_directory = "data/logs/[time2text(world.realtime, "YYYY/MM/DD")]/round-"
	if(config.sql_enabled)
		if(SSdbcore.Connect())
			log_world("Database connection established.")
			var/datum/DBQuery/query_feedback_create_round = SSdbcore.NewQuery("INSERT INTO [format_table_name("feedback")] SELECT null, Now(), MAX(round_id)+1, \"server_ip\", 0, \"[world.internet_address]:[world.port]\" FROM [format_table_name("feedback")]")
			query_feedback_create_round.Execute()
			var/datum/DBQuery/query_feedback_max_id = SSdbcore.NewQuery("SELECT MAX(round_id) FROM [format_table_name("feedback")]")
			query_feedback_max_id.Execute()
			if(query_feedback_max_id.NextRow())
				GLOB.round_id = query_feedback_max_id.item[1]
				GLOB.log_directory += "[GLOB.round_id]"
		else
			log_world("Your server failed to establish a connection with the database.")
	if(!GLOB.round_id)
		GLOB.log_directory += "[replacetext(time_stamp(), ":", ".")]"
	GLOB.world_game_log = file("[GLOB.log_directory]/game.log")
	GLOB.world_attack_log = file("[GLOB.log_directory]/attack.log")
	GLOB.world_runtime_log = file("[GLOB.log_directory]/runtime.log")
	GLOB.world_href_log = file("[GLOB.log_directory]/hrefs.html")
	GLOB.world_game_log << "\n\nStarting up round ID [GLOB.round_id]. [time_stamp()]\n---------------------"
	GLOB.world_attack_log << "\n\nStarting up round ID [GLOB.round_id]. [time_stamp()]\n---------------------"
	GLOB.world_runtime_log << "\n\nStarting up round ID [GLOB.round_id]. [time_stamp()]\n---------------------"
	GLOB.changelog_hash = md5('html/changelog.html')					//used for telling if the changelog has changed recently
	if(fexists(GLOB.config_error_log))
		fcopy(GLOB.config_error_log, "[GLOB.log_directory]/config_error.log")
		fdel(GLOB.config_error_log)

	GLOB.revdata.DownloadPRDetails()
	load_mode()
	load_motd()
	load_admins()
	load_menu()
	if(config.usewhitelist)
		load_whitelist()
	LoadBans()
<<<<<<< HEAD

	GLOB.timezoneOffset = text2num(time2text(0,"hh")) * 36000
=======
	investigate_reset()


	if(config && global.bot_ip)
		var/query = "http://[global.bot_ip]/?serverStart=1&key=[global.comms_key]"
		world.Export(query)

	if(config && config.server_name != null && config.server_suffix && world.port > 0)
		config.server_name += " #[(world.port % 1000) / 100]"

	timezoneOffset = text2num(time2text(0,"hh")) * 36000

	if(config.sql_enabled)
		if(!setup_database_connection())
			log_world("Your server failed to establish a connection with the database.")
		else
			log_world("Database connection established.")


	data_core = new /datum/datacore()
>>>>>>> master

	GLOB.data_core = new /datum/datacore()

	Master.Initialize(10, FALSE)

#define IRC_STATUS_THROTTLE 50
/world/Topic(T, addr, master, key)
	if(config && config.log_world_topic)
		GLOB.world_game_log << "TOPIC: \"[T]\", from:[addr], master:[master], key:[key]"

	var/list/input = params2list(T)
	var/key_valid = (global.comms_allowed && input["key"] == global.comms_key)
	var/static/last_irc_status = 0

	if("ping" in input)
		var/x = 1
		for (var/client/C in GLOB.clients)
			x++
		return x

	else if("players" in input)
		var/n = 0
		for(var/mob/M in GLOB.player_list)
			if(M.client)
				n++
		return n

	else if("ircstatus" in input)
		if(world.time - last_irc_status < IRC_STATUS_THROTTLE)
			return
		var/list/adm = get_admin_counts()
		var/list/allmins = adm["total"]
		var/status = "Admins: [allmins.len] (Active: [english_list(adm["present"])] AFK: [english_list(adm["afk"])] Stealth: [english_list(adm["stealth"])] Skipped: [english_list(adm["noflags"])]). "
		status += "Players: [GLOB.clients.len] (Active: [get_active_player_count(0,1,0)]). Mode: [SSticker.mode.name]."
		send2irc("Status", status)
		last_irc_status = world.time

	else if("status" in input)
		var/list/s = list()
		s["version"] = GLOB.game_version
		s["mode"] = GLOB.master_mode
		s["respawn"] = config ? GLOB.abandon_allowed : 0
		s["enter"] = GLOB.enter_allowed
		s["vote"] = config.allow_vote_mode
		s["ai"] = config.allow_ai
		s["host"] = host ? host : null
		s["active_players"] = get_active_player_count()
		s["players"] = GLOB.clients.len
		s["revision"] = GLOB.revdata.commit
		s["revision_date"] = GLOB.revdata.date

		var/list/adm = get_admin_counts()
		var/list/presentmins = adm["present"]
		var/list/afkmins = adm["afk"]
		s["admins"] = presentmins.len + afkmins.len //equivalent to the info gotten from adminwho
		s["gamestate"] = 1
		if(SSticker)
			s["gamestate"] = SSticker.current_state

		s["map_name"] = SSmapping.config.map_name

		if(key_valid && SSticker.HasRoundStarted())
			s["real_mode"] = SSticker.mode.name
			// Key-authed callers may know the truth behind the "secret"

		s["security_level"] = get_security_level()
		s["round_duration"] = SSticker ? round((world.time-SSticker.round_start_time)/10) : 0
		// Amount of world's ticks in seconds, useful for calculating round duration

		if(SSshuttle && SSshuttle.emergency)
			s["shuttle_mode"] = SSshuttle.emergency.mode
			// Shuttle status, see /__DEFINES/stat.dm
			s["shuttle_timer"] = SSshuttle.emergency.timeLeft()
			// Shuttle timer, in seconds

		return list2params(s)

	else if("announce" in input)
		if(!key_valid)
			return "Bad Key"
		else
<<<<<<< HEAD
			AnnouncePR(input["announce"], json_decode(input["payload"]))
=======
#define CHAT_PULLR	64 //defined in preferences.dm, but not available here at compilation time
			for(var/client/C in clients)
				if(C.prefs && (C.prefs.chat_toggles & CHAT_PULLR))
					to_chat(C, "<span class='announce'>PR: [input["announce"]]</span>")
#undef CHAT_PULLR
>>>>>>> master

	else if("crossmessage" in input)
		if(!key_valid)
			return
		else
			if(input["crossmessage"] == "Ahelp")
				relay_msg_admins("<span class='adminnotice'><b><font color=red>HELP: </font> [input["source"]] [input["message_sender"]]: [input["message"]]</b></span>")
			if(input["crossmessage"] == "Comms_Console")
				minor_announce(input["message"], "Incoming message from [input["message_sender"]]")
				for(var/obj/machinery/computer/communications/CM in GLOB.machines)
					CM.overrideCooldown()
			if(input["crossmessage"] == "News_Report")
				minor_announce(input["message"], "Breaking Update From [input["message_sender"]]")

	else if("adminmsg" in input)
		if(!key_valid)
			return "Bad Key"
		else
			return IrcPm(input["adminmsg"],input["msg"],input["sender"])

	else if("namecheck" in input)
		if(!key_valid)
			return "Bad Key"
		else
			log_admin("IRC Name Check: [input["sender"]] on [input["namecheck"]]")
			message_admins("IRC name checking on [input["namecheck"]] from [input["sender"]]")
			return keywords_lookup(input["namecheck"],1)
	else if("adminwho" in input)
		if(!key_valid)
			return "Bad Key"
		else
			return ircadminwho()
	else if("server_hop" in input)
		show_server_hop_transfer_screen(input["server_hop"])

#define PR_ANNOUNCEMENTS_PER_ROUND 5 //The number of unique PR announcements allowed per round
									//This makes sure that a single person can only spam 3 reopens and 3 closes before being ignored

/world/proc/AnnouncePR(announcement, list/payload)
	var/static/list/PRcounts = list()	//PR id -> number of times announced this round
	var/id = "[payload["pull_request"]["id"]]"
	if(!PRcounts[id])
		PRcounts[id] = 1
	else
		++PRcounts[id]
		if(PRcounts[id] > PR_ANNOUNCEMENTS_PER_ROUND)
			return

#define CHAT_PULLR	64 //defined in preferences.dm, but not available here at compilation time
	for(var/client/C in GLOB.clients)
		if(C.prefs && (C.prefs.chat_toggles & CHAT_PULLR))
			C << "<span class='announce'>PR: [announcement]</span>"
#undef CHAT_PULLR

#define WORLD_REBOOT(X) log_world("World rebooted at [time_stamp()]"); ..(X); return;

/world/Reboot(var/reason, var/feedback_c, var/feedback_r, var/time)
	if (reason == 1) //special reboot, do none of the normal stuff
		if (usr)
			log_admin("[key_name(usr)] Has requested an immediate world restart via client side debugging tools")
			message_admins("[key_name_admin(usr)] Has requested an immediate world restart via client side debugging tools")
		to_chat(world, "<span class='boldannounce'>Rebooting World immediately due to host request</span>")
<<<<<<< HEAD
		WORLD_REBOOT(1)
=======
		return ..(1)
>>>>>>> master
	var/delay
	if(time)
		delay = time
	else
		delay = config.round_end_countdown * 10
<<<<<<< HEAD
	if(SSticker.delay_end)
		to_chat(world, "<span class='boldannounce'>An admin has delayed the round end.</span>")
		return
	to_chat(world, "<span class='boldannounce'>Rebooting World in [delay/10] [(delay >= 10 && delay < 20) ? "second" : "seconds"]. [reason]</span>")
	var/round_end_sound_sent = FALSE
	if(SSticker.round_end_sound)
		round_end_sound_sent = TRUE
		for(var/thing in GLOB.clients)
			var/client/C = thing
			if (!C)
				continue
			C.Export("##action=load_rsc", SSticker.round_end_sound)
	sleep(delay)
	if(SSticker.delay_end)
		to_chat(world, "<span class='boldannounce'>Reboot was cancelled by an admin.</span>")
		return
	OnReboot(reason, feedback_c, feedback_r, round_end_sound_sent)
	WORLD_REBOOT(0)
#undef WORLD_REBOOT

/world/proc/OnReboot(reason, feedback_c, feedback_r, round_end_sound_sent)
	SSblackbox.set_details("[feedback_c]","[feedback_r]")
=======
	if(ticker.delay_end)
		to_chat(world, "<span class='boldannounce'>An admin has delayed the round end.</span>")
		return
	to_chat(world, "<span class='boldannounce'>Rebooting World in [delay/10] [delay > 10 ? "seconds" : "second"]. [reason]</span>")
	sleep(delay)
	if(blackbox)
		blackbox.save_all_data_to_sql()
	if(ticker.delay_end)
		to_chat(world, "<span class='boldannounce'>Reboot was cancelled by an admin.</span>")
		return
	if(mapchanging)
		to_chat(world, "<span class='boldannounce'>Map change operation detected, delaying reboot.</span>")
		rebootingpendingmapchange = 1
		spawn(1200)
			if(mapchanging)
				mapchanging = 0 //map rotation can in some cases be finished but never exit, this is a failsafe
				Reboot("Map change timed out", time = 10)
		return
	feedback_set_details("[feedback_c]","[feedback_r]")
>>>>>>> master
	log_game("<span class='boldannounce'>Rebooting World. [reason]</span>")
	SSblackbox.set_val("ahelp_unresolved", GLOB.ahelp_tickets.active_tickets.len)
	Master.Shutdown()	//run SS shutdowns
	RoundEndAnimation(round_end_sound_sent)
	kick_clients_in_lobby("<span class='boldannounce'>The round came to an end with you in the lobby.</span>", 1) //second parameter ensures only afk clients are kicked
<<<<<<< HEAD
	to_chat(world, "<span class='boldannounce'>Rebooting world...</span>")
	for(var/thing in GLOB.clients)
		var/client/C = thing
		if(C && config.server)	//if you set a server location in config.txt, it sends you there instead of trying to reconnect to the same world address. -- NeoFite
			C << link("byond://[config.server]")

/world/proc/RoundEndAnimation(round_end_sound_sent)
	set waitfor = FALSE
	var/round_end_sound
	if(SSticker.round_end_sound)
		round_end_sound = SSticker.round_end_sound
		if (!round_end_sound_sent)
			for(var/thing in GLOB.clients)
				var/client/C = thing
				if (!C)
					continue
				C.Export("##action=load_rsc", round_end_sound)
	else
		round_end_sound = pick(\
		'sound/roundend/newroundsexy.ogg',
		'sound/roundend/apcdestroyed.ogg',
		'sound/roundend/bangindonk.ogg',
		'sound/roundend/leavingtg.ogg',
		'sound/roundend/its_only_game.ogg',
		'sound/roundend/yeehaw.ogg',
		'sound/roundend/disappointed.ogg'\
		)

	for(var/thing in GLOB.clients)
		var/obj/screen/splash/S = new(thing, FALSE)
		S.Fade(FALSE,FALSE)

	world << sound(round_end_sound)
=======
	#ifdef dellogging
	var/log = file("data/logs/del.log")
	log << time2text(world.realtime)
	for(var/index in del_counter)
		var/count = del_counter[index]
		if(count > 10)
			log << "#[count]\t[index]"
#endif
	spawn(0)
		if(ticker && ticker.round_end_sound)
			world << sound(ticker.round_end_sound)
		else
			world << sound(pick('sound/AI/newroundsexy.ogg','sound/misc/apcdestroyed.ogg','sound/misc/bangindonk.ogg','sound/misc/leavingtg.ogg','sound/misc/clownmac.ogg')) // random end sounds!! - LastyBatsy
	for(var/client/C in clients)
		if(config.server)	//if you set a server location in config.txt, it sends you there instead of trying to reconnect to the same world address. -- NeoFite
			C << link("byond://[config.server]")

	if (watchdog.waiting)
		to_chat(world, "<span class='notice'><B>Server will shut down for an automatic update in a few seconds.</B></span>")
		watchdog.signal_ready()
		return

	..(0)
>>>>>>> master

/world/proc/load_mode()
	var/list/Lines = world.file2list("data/mode.txt")
	if(Lines.len)
		if(Lines[1])
			GLOB.master_mode = Lines[1]
			GLOB.world_game_log << "Saved mode is '[GLOB.master_mode]'"

/world/proc/save_mode(the_mode)
	var/F = file("data/mode.txt")
	fdel(F)
	F << the_mode

/world/proc/load_motd()
	GLOB.join_motd = file2text("config/motd.txt") + "<br>" + GLOB.revdata.GetTestMergeInfo()

/world/proc/update_status()
	var/s = ""

	if (config && config.server_name)
		s += "<b>[config.server_name]</b> &#8212; "

	s += "<b><span style='font-size:8px'>[station_name()]</span></b>";
	s += " ("
	s += "<a href=\"http://ftl13.com\">" //Change this to wherever you want the hub to link to.
//	s += "[game_version]"
	s += "ftl13.com"  //Replace this with something else. Or ever better, delete it and uncomment the game version.
	s += "</a>"
	s += ")"

	var/list/features = list()

	if(SSticker)
		if(GLOB.master_mode)
			features += GLOB.master_mode
	else
		features += "<b>STARTING</b>"

	if (!GLOB.enter_allowed)
		features += "closed"

	features += GLOB.abandon_allowed ? "respawn" : "no respawn"

	if (config && config.allow_vote_mode)
		features += "vote"

	if (config && config.allow_ai)
		features += "AI allowed"

	var/n = 0
	for (var/mob/M in GLOB.player_list)
		if (M.client)
			n++

	if (n > 1)
		features += "~[n] players"
	else if (n > 0)
		features += "~[n] player"

	if (!host && config && config.hostedby)
		features += "hosted by <b>[config.hostedby]</b>"

	if (features)
		s += ": [jointext(features, ", ")]"

	status = s


<<<<<<< HEAD
/world/proc/has_round_started()
	return SSticker.HasRoundStarted()
=======
	var/user = sqlfdbklogin
	var/pass = sqlfdbkpass
	var/db = sqlfdbkdb
	var/address = sqladdress
	var/port = sqlport

	dbcon.Connect("dbi:mysql:[db]:[address]:[port]","[user]","[pass]")
	. = dbcon.IsConnected()
	if ( . )
		failed_db_connections = 0	//If this connection succeeded, reset the failed connections counter.
	else
		failed_db_connections++		//If it failed, increase the failed connections counter.
		if(config.sql_enabled)
			log_world("SQL error: " + dbcon.ErrorMsg())

	return .

//This proc ensures that the connection to the feedback database (global variable dbcon) is established
/proc/establish_db_connection()
	if(failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)
		return 0

	if(!dbcon || !dbcon.IsConnected())
		return setup_database_connection()
	else
		return 1

#undef FAILED_DB_CONNECTION_CUTOFF


/proc/maprotate()
	if (!SERVERTOOLS)
		return
	var/players = clients.len
	var/list/mapvotes = list()
	//count votes
	for (var/client/c in clients)
		var/vote = c.prefs.preferred_map
		if (!vote)
			if (config.defaultmap)
				mapvotes[config.defaultmap.name] += 1
			continue
		mapvotes[vote] += 1

	//filter votes
	for (var/map in mapvotes)
		if (!map)
			mapvotes.Remove(map)
		if (!(map in config.maplist))
			mapvotes.Remove(map)
			continue
		var/datum/votablemap/VM = config.maplist[map]
		if (!VM)
			mapvotes.Remove(map)
			continue
		if (VM.voteweight <= 0)
			mapvotes.Remove(map)
			continue
		if (VM.minusers > 0 && players < VM.minusers)
			mapvotes.Remove(map)
			continue
		if (VM.maxusers > 0 && players > VM.maxusers)
			mapvotes.Remove(map)
			continue

		mapvotes[map] = mapvotes[map]*VM.voteweight

	var/pickedmap = pickweight(mapvotes)
	if (!pickedmap)
		return
	var/datum/votablemap/VM = config.maplist[pickedmap]
	message_admins("Randomly rotating map to [VM.name]([VM.friendlyname])")
	. = changemap(VM)
	if (. == 0)
		to_chat(world, "<span class='boldannounce'>Map rotation has chosen [VM.friendlyname] for next round!</span>")

var/datum/votablemap/nextmap
var/mapchanging = 0
var/rebootingpendingmapchange = 0
/proc/changemap(var/datum/votablemap/VM)
	if (!SERVERTOOLS)
		return
	if (!istype(VM))
		return
	mapchanging = 1
	log_game("Changing map to [VM.name]([VM.friendlyname])")
	var/file = file("setnewmap.bat")
	to_chat(file, "\nset MAPROTATE=[VM.name]\n")
	. = shell("..\\bin\\maprotate.bat")
	mapchanging = 0
	switch (.)
		if (null)
			message_admins("Failed to change map: Could not run map rotator")
			log_game("Failed to change map: Could not run map rotator")
		if (0)
			log_game("Changed to map [VM.friendlyname]")
			nextmap = VM
		//1x: file errors
		if (11)
			message_admins("Failed to change map: File error: Map rotator script couldn't find file listing new map")
			log_game("Failed to change map: File error: Map rotator script couldn't find file listing new map")
		if (12)
			message_admins("Failed to change map: File error: Map rotator script couldn't find tgstation-server framework")
			log_game("Failed to change map: File error: Map rotator script couldn't find tgstation-server framework")
		//2x: conflicting operation errors
		if (21)
			message_admins("Failed to change map: Conflicting operation error: Current server update operation detected")
			log_game("Failed to change map: Conflicting operation error: Current server update operation detected")
		if (22)
			message_admins("Failed to change map: Conflicting operation error: Current map rotation operation detected")
			log_game("Failed to change map: Conflicting operation error: Current map rotation operation detected")
		//3x: external errors
		if (31)
			message_admins("Failed to change map: External error: Could not compile new map:[VM.name]")
			log_game("Failed to change map: External error: Could not compile new map:[VM.name]")

		else
			message_admins("Failed to change map: Unknown error: Error code #[.]")
			log_game("Failed to change map: Unknown error: Error code #[.]")
	if(rebootingpendingmapchange)
		world.Reboot("Map change finished", time = 10)
>>>>>>> master
