#define IRCREPLYCOUNT 2


//allows right clicking mobs to send an mentor PM to their client, forwards the selected mob's client to cmd_mentor_pm
/client/proc/cmd_mentor_pm_context(mob/M in GLOB.mob_list)
	set category = null
	set name = "Mentor PM Mob"
	if(!holder)
		to_chat(src, "<font color='red'>Error: Mentor-PM-Context: Only administrators and mentors may use this command.</font>")
		return
	if( !ismob(M) || !M.client )
		return
	cmd_mentor_pm(M.client,null)
	SSblackbox.add_details("mentor_verb","Mentor PM Mob") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/* Mentors should not be initiating PMs. Only recieving.
//shows a list of clients we could send PMs to, then forwards our choice to cmd_mentor_pm
/client/proc/cmd_mentor_pm_panel()
	set category = "Admin"
	set name = "Mentor PM"
	if(!holder)
		to_chat(src, "<font color='red'>Error: Mentor-PM-Panel: Only administrators and mentors may use this command.</font>")
		return
	var/list/client/targets[0]
	for(var/client/T)
		if(T.mob)
			if(isnewplayer(T.mob))
				targets["(New Player) - [T]"] = T
			else if(isobserver(T.mob))
				targets["[T.mob.name](Ghost) - [T]"] = T
			else
				targets["[T.mob.real_name](as [T.mob.name]) - [T]"] = T
		else
			targets["(No Mob) - [T]"] = T
	var/target = input(src,"To whom shall we send a message?","Mentor PM",null) as null|anything in sortList(targets)
	cmd_mentor_pm(targets[target],null)
	SSblackbox.add_details("mentor_verb","Mentor PM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
*/

/client/proc/cmd_mhelp_reply(whom)
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, "<font color='red'>Error: Mentor-PM: You are unable to use Mentor PM-s (muted).</font>")
		return
	var/client/C
	if(istext(whom))
		if(cmptext(copytext(whom,1,2),"@"))
			whom = findStealthKey(whom)
		C = GLOB.directory[whom]
	else if(istype(whom,/client))
		C = whom
	if(!C)
		if(holder)
			to_chat(src, "<font color='red'>Error: Mentor-PM: Client not found.</font>")
		return

	var/datum/mentor_help/MH = C.mentor_current_ticket

	if(MH)
		message_staff("[key_name_admin(src)] has started replying to [key_name(C, 0, 0)]'s mentor help.")
	var/msg = input(src,"Message:", "Private message to [key_name(C, 0, 0)]") as text|null
	if (!msg)
		message_staff("[key_name_admin(src)] has cancelled their reply to [key_name(C, 0, 0)]'s mentor help.")
		return
	cmd_mentor_pm(whom, msg)

//takes input from cmd_mentor_pm_context, cmd_mentor_pm_panel or /client/Topic and sends them a PM.
//Fetching a message if needed. src is the sender and C is the target client
/client/proc/cmd_mentor_pm(whom, msg)
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, "<font color='red'>Error: Mentor-PM: You are unable to use Mentor PM-s (muted).</font>")
		return

	if(!holder && !mentor_current_ticket)	//no ticket? https://www.youtube.com/watch?v=iHSPf6x1Fdo
		to_chat(src, "<font color='red'>You can no longer reply to this ticket, please open another one by using the Mentorhelp verb if need be.</font>")
		to_chat(src, "<font color='blue'>Message: [msg]</font>")
		return

	var/client/recipient
	var/irc = 0
	if(istext(whom))
		if(cmptext(copytext(whom,1,2),"@"))
			whom = findStealthKey(whom)
		if(whom == "IRCKEY")
			irc = 1
		else
			recipient = GLOB.directory[whom]
	else if(istype(whom,/client))
		recipient = whom

	if(irc)
		return

	else
		if(!recipient)
			if(holder)
				to_chat(src, "<font color='red'>Error: Mentor-PM: Client not found.</font>")
				to_chat(src, msg)
			else
				mentor_current_ticket.MessageNoRecipient(msg)
			return

		//get message text, limit it's length.and clean/escape html
		if(!msg)
			msg = input(src,"Message:", "Private message to [key_name(recipient, 0, 0)]") as text|null

			if(!msg)
				return

			if(prefs.muted & MUTE_ADMINHELP)
				to_chat(src, "<font color='red'>Error: Mentor-PM: You are unable to use Mentor PM-s (muted).</font>")
				return

			if(!recipient)
				if(holder)
					to_chat(src, "<font color='red'>Error: Mentor-PM: Client not found.</font>")
				else
					mentor_current_ticket.MessageNoRecipient(msg)
				return

	if (src.handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

	//clean the message if it's not sent by a mentor or above
	if(!check_rights(R_MENTOR,0)||irc)//no sending html to the poor bots
		msg = sanitize(copytext(msg,1,MAX_MESSAGE_LEN))
		if(!msg)
			return

	var/rawmsg = msg

	if(holder)
		msg = emoji_parse(msg)

	var/keywordparsedmsg = keywords_lookup(msg)

	if(irc)
		ircreplyamount--
		/* Mentor help should not be going to IRC.
		to_chat(src, "<font color='blue'>PM to-<b>Mentors</b>: [rawmsg]</font>")
		var/datum/mentor_help/MH = mentor_ticket_log(src, "<font color='red'>Reply PM from-<b>[key_name(src, TRUE, TRUE)] to <i>IRC</i>: [keywordparsedmsg]</font>")
		send2irc("[AH ? "#[AH.id] " : ""]Reply: [ckey]", rawmsg)
		*/
	else
		if(recipient.holder)
			if(holder)	//both are admins or mentors
				to_chat(recipient, "<font color='red'>Mentor PM from-<b>[key_name(src, recipient, 1)]</b>: [keywordparsedmsg]</font>")
				to_chat(src, "<font color='blue'>Mentor PM to-<b>[key_name(recipient, src, 1)]</b>: [keywordparsedmsg]</font>")

				//omg this is dumb, just fill in both their tickets
				var/interaction_message = "<font color='purple'>PM from-<b>[key_name(src, recipient, 1)]</b> to-<b>[key_name(recipient, src, 1)]</b>: [keywordparsedmsg]</font>"
				mentor_ticket_log(src, interaction_message)
				if(recipient != src)	//reeee
					mentor_ticket_log(recipient, interaction_message)

			else		//recipient is an mentor but sender is not
				var/replymsg = "<font color='red'>Reply PM from-<b>[key_name(src, recipient, 1)]</b>: [keywordparsedmsg]</font>"
				mentor_ticket_log(src, replymsg)
				to_chat(recipient, replymsg)
				to_chat(src, "<font color='blue'>PM to-<b>Mentors</b>: [msg]</font>")

			//play the recieving admin the adminhelp sound (if they have them enabled)
			if(recipient.prefs.toggles & SOUND_ADMINHELP)
				recipient << 'sound/effects/adminhelp.ogg'

		else
			if(holder)
				if(!recipient.mentor_current_ticket)
				/* Mentors should not be initiating PMs. Use AdminPM.
					new /datum/mentor_help(msg, recipient, TRUE)
					*/
					to_chat(src, "<font color='red'>Error: Mentor-PM: Mentors should not be initiating PMs. Use AdminPM.</font>")
				to_chat(recipient, "<font color='red' size='4'><b>-- Mentor private message --</b></font>")
				to_chat(recipient, "<font color='red'>Mentor PM from-<b>[key_name(src, recipient, 0)]</b>: [msg]</font>")
				to_chat(recipient, "<font color='red'><i>Click on the mentor's name to reply.</i></font>")
				to_chat(src, "<font color='blue'>Mentor PM to-<b>[key_name(recipient, src, 1)]</b>: [msg]</font>")

				mentor_ticket_log(recipient, "<font color='blue'>PM From [key_name_admin(src)]: [keywordparsedmsg]</font>")

				//always play non-admin recipients the adminhelp sound
				recipient << 'sound/effects/adminhelp.ogg'

			else		//neither are admins
				to_chat(src, "<font color='red'>Error: Mentor-PM: Non-mentor to non-mentor PM communication is forbidden.</font>")
				return

		window_flash(recipient, ignorepref = TRUE)
		log_admin_private("PM: [key_name(src)]->[key_name(recipient)]: [rawmsg]")
		//we don't use message_admins here because the sender/receiver might get it too
		for(var/client/X in GLOB.staff)
			if(X.key!=key && X.key!=recipient.key)	//check client/X is an admin and isn't the sender or recipient
				to_chat(X, "<font color='blue'><B>Mentor PM: [key_name(src, X, 0)]-&gt;[key_name(recipient, X, 0)]:</B> [keywordparsedmsg]</font>" )
