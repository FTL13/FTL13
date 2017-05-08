atom/proc/investigate_log(message, subject)
	if(!message || !subject)
		return
	var/F = file("[GLOB.log_directory]/[subject].html")
	F << "<small>[time_stamp()] \ref[src] ([x],[y],[z])</small> || [src] [message]<br>"


/client/proc/investigate_show( subject in list("hrefs","notes, memos, watchlist","singulo","wires","telesci", "gravity", "records", "cargo", "supermatter", "atmos", "experimentor", "botany") )
	set name = "Investigate"
	set category = "Admin"
	if(!holder)
		return
	switch(subject)
<<<<<<< HEAD
		if("notes, memos, watchlist")
			browse_messages()
		else
			var/F = file("[GLOB.log_directory]/[subject].html")
			if(!fexists(F))
				to_chat(src, "<span class='danger'>No [subject] logfile was found.</span>")
=======
		if("singulo", "wires", "telesci", "gravity", "records", "cargo", "supermatter", "atmos", "kudzu")			//general one-round-only stuff
			var/F = investigate_subject2file(subject)
			if(!F)
				to_chat(src, "<font color='red'>Error: admin_investigate: [INVESTIGATE_DIR][subject] is an invalid path or cannot be accessed.</font>")
				return
			src << browse(F,"window=investigate[subject];size=800x300")

		if("hrefs")				//persistant logs and stuff
			if(config && config.log_hrefs)
				if(href_logfile)
					src << browse(href_logfile,"window=investigate[subject];size=800x300")
				else
					to_chat(src, "<font color='red'>Error: admin_investigate: No href logfile found.</font>")
					return
			else
				to_chat(src, "<font color='red'>Error: admin_investigate: Href Logging is not on.</font>")
>>>>>>> master
				return
			src << browse(F,"window=investigate[subject];size=800x300")