/client/proc/cmd_mentor_say(msg as text)
	set category = "Special Verbs"
	set name = "Msay"
	set hidden = FALSE
	if(!check_rights(0))
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)
		return

	log_adminsay("[key_name(src)] : MSay : [msg]")
	msg = keywords_lookup(msg)
	if(check_rights(R_MENTOR,0))
		msg = "<span class='admin'><span class='prefix'>MENTOR:</span> <EM>[key_name(usr, 1)]</EM> (<a href='?_src_=holder;adminplayerobservefollow=\ref[mob]'>FLW</A>): <font color='[prefs.ooccolor ? prefs.ooccolor : GLOB.normal_ooc_colour]'><span class='message'>[msg]</span></span></font>"
		to_chat(GLOB.admins, msg)
	else
		msg = "<span class='adminobserver'><span class='prefix'>MENTOR:</span> <EM>[key_name(usr, 1)]:</EM> <span class='message'>[msg]</span></span>"
		to_chat(GLOB.admins, msg)

	SSblackbox.add_details("mentor_verb","Msay") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
