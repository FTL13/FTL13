/client/var/mentorhelptimerid = 0	//a timer id for returning the mhelp verb
/client/var/datum/mentor_help/mentor_current_ticket	//the current ticket the (usually) not-mentor client is dealing with

//
//TICKET MANAGER
//

GLOBAL_DATUM_INIT(mhelp_tickets, /datum/mentor_help_tickets, new)

/datum/mentor_help_tickets
	var/list/m_active_tickets = list()
	var/list/m_closed_tickets = list()
	var/list/m_resolved_tickets = list()

	var/obj/effect/statclick/ticket_list/astatclick = new(null, null, MHELP_ACTIVE)
	var/obj/effect/statclick/ticket_list/cstatclick = new(null, null, MHELP_CLOSED)
	var/obj/effect/statclick/ticket_list/rstatclick = new(null, null, MHELP_RESOLVED)

/datum/mentor_help_tickets/Destroy()
	QDEL_LIST(m_active_tickets)
	QDEL_LIST(m_closed_tickets)
	QDEL_LIST(m_resolved_tickets)
	QDEL_NULL(astatclick)
	QDEL_NULL(cstatclick)
	QDEL_NULL(rstatclick)
	return ..()

/datum/mentor_help_tickets/proc/TicketByID(id)
	var/list/lists = list(m_active_tickets, m_closed_tickets, m_resolved_tickets)
	for(var/I in lists)
		for(var/J in I)
			var/datum/mentor_help/MH = J
			if(MH.id == id)
				return J

/datum/mentor_help_tickets/proc/TicketsByCKey(ckey)
	. = list()
	var/list/lists = list(m_active_tickets, m_closed_tickets, m_resolved_tickets)
	for(var/I in lists)
		for(var/J in I)
			var/datum/mentor_help/MH = J
			if(MH.initiator_ckey == ckey)
				. += MH

//private
/datum/mentor_help_tickets/proc/ListInsert(datum/mentor_help/new_ticket)
	var/list/ticket_list
	switch(new_ticket.state)
		if(MHELP_ACTIVE)
			ticket_list = m_active_tickets
		if(MHELP_CLOSED)
			ticket_list = m_closed_tickets
		if(MHELP_RESOLVED)
			ticket_list = m_resolved_tickets
		else
			CRASH("Invalid ticket state: [new_ticket.state]")
	var/num_closed = ticket_list.len
	if(num_closed)
		for(var/I in 1 to num_closed)
			var/datum/mentor_help/AH = ticket_list[I]
			if(AH.id > new_ticket.id)
				ticket_list.Insert(I, new_ticket)
				return
	ticket_list += new_ticket

//opens the ticket listings for one of the 3 states
/datum/mentor_help_tickets/proc/BrowseTickets(state)
	var/list/l2b
	var/title
	switch(state)
		if(MHELP_ACTIVE)
			l2b = m_active_tickets
			title = "Active Tickets"
		if(MHELP_CLOSED)
			l2b = m_closed_tickets
			title = "Closed Tickets"
		if(MHELP_RESOLVED)
			l2b = m_resolved_tickets
			title = "Resolved Tickets"
	if(!l2b)
		return
	var/list/dat = list("<html><head><title>[title]</title></head>")
	dat += "<A HREF='?_src_=holder;mhelp_tickets=[state]'>Refresh</A><br><br>"
	for(var/I in l2b)
		var/datum/mentor_help/MH = I
		dat += "<span class='adminnotice'><span class='adminhelp'>Mentor Ticket #[MH.id]</span>: <A HREF='?_src_=holder;mhelp=\ref[MH];mhelp_action=ticket'>[MH.initiator_key_name]: [MH.name]</A></span><br>"

	usr << browse(dat.Join(), "window=mhelp_list[state];size=600x480")

//Tickets statpanel
/datum/mentor_help_tickets/proc/stat_entry()
	var/m_num_disconnected = 0
	stat("Active Tickets:", astatclick.update("[m_active_tickets.len]"))
	for(var/I in m_active_tickets)
		var/datum/mentor_help/MH = I
		if(MH.initiator)
			stat("#[MH.id]. [MH.initiator_key_name]:", MH.statclick.update())
		else
			++m_num_disconnected
	if(m_num_disconnected)
		stat("Disconnected:", astatclick.update("[m_num_disconnected]"))
	stat("Closed Tickets:", cstatclick.update("[m_closed_tickets.len]"))
	stat("Resolved Tickets:", rstatclick.update("[m_resolved_tickets.len]"))

//Reassociate still open ticket if one exists
/datum/mentor_help_tickets/proc/ClientLogin(client/C)
	C.mentor_current_ticket = CKey2ActiveTicket(C.ckey)
	if(C.mentor_current_ticket)
		C.mentor_current_ticket.AddInteraction("Client reconnected.")
		C.mentor_current_ticket.initiator = C

//Dissasociate ticket
/datum/mentor_help_tickets/proc/ClientLogout(client/C)
	if(C.mentor_current_ticket)
		C.mentor_current_ticket.AddInteraction("Client disconnected.")
		C.mentor_current_ticket.initiator = null
		C.mentor_current_ticket = null

//Get a ticket given a ckey
/datum/mentor_help_tickets/proc/CKey2ActiveTicket(ckey)
	for(var/I in m_active_tickets)
		var/datum/mentor_help/AH = I
		if(AH.initiator_ckey == ckey)
			return AH

//
//TICKET LIST STATCLICK
//

/obj/effect/statclick/ticket_list
	var/mentor_current_state

/obj/effect/statclick/ticket_list/New(loc, name, state)
	mentor_current_state = state
	..()

/obj/effect/statclick/ticket_list/Click()
	GLOB.mhelp_tickets.BrowseTickets(mentor_current_state)

//
//TICKET DATUM
//

/datum/mentor_help
	var/id
	var/name
	var/state = MHELP_ACTIVE

	var/opened_at
	var/closed_at

	var/client/initiator	//semi-misnomer, it's the person who mhelped
	var/initiator_ckey
	var/initiator_key_name

	var/list/_interactions	//use AddInteraction() or, preferably, mentor_ticket_log()

	var/obj/effect/statclick/mhelp/statclick

	var/static/ticket_counter = 0

//call this on its own to create a ticket, don't manually assign mentor_current_ticket
//msg is the title of the ticket: usually the mhelp text
//is_bwoink is TRUE if this ticket was started by an mentor PM. This should be falsefor mentors.
/datum/mentor_help/New(msg, client/C, is_bwoink)
	//clean the input msg
	msg = sanitize(copytext(msg,1,MAX_MESSAGE_LEN))
	if(!msg || !C || !C.mob)
		qdel(src)
		return

	id = ++ticket_counter
	opened_at = world.time

	name = msg

	initiator = C
	initiator_ckey = initiator.ckey
	initiator_key_name = key_name(initiator, FALSE, TRUE)
	if(initiator.mentor_current_ticket)	//This is a bug
		stack_trace("Multiple mhelp mentor_current_tickets")
		initiator.mentor_current_ticket.AddInteraction("Ticket erroneously left open by code")
		initiator.mentor_current_ticket.Close()
	initiator.mentor_current_ticket = src

	TimeoutVerb()

	var/parsed_message = keywords_lookup(msg)

	statclick = new(null, src)
	_interactions = list()

	if(is_bwoink) //Should be false.
		AddInteraction("<font color='blue'>[key_name_admin(usr)] PM'd [LinkedReplyName()]</font>")
		message_staff("<font color='blue'>Mentor Ticket [TicketHref("#[id]")] created</font>")
		message_staff("Mentors should not be creating tickets. This is a bug.")
	else
		MessageNoRecipient(parsed_message)

	GLOB.mhelp_tickets.m_active_tickets += src

/datum/mentor_help/Destroy()
	RemoveActive()
	GLOB.mhelp_tickets.m_closed_tickets -= src
	GLOB.mhelp_tickets.m_resolved_tickets -= src
	return ..()

/datum/mentor_help/proc/AddInteraction(formatted_message)
	_interactions += "[gameTimestamp()]: [formatted_message]"

//Removes the mhelp verb and returns it after 2 minutes
/datum/mentor_help/proc/TimeoutVerb()
	initiator.verbs -= /client/verb/mentorhelp
	initiator.mentorhelptimerid = addtimer(CALLBACK(initiator, /client/proc/givementorhelpverb), 1200, TIMER_STOPPABLE) //2 minute cooldown of mentor helps

//private
/datum/mentor_help/proc/FullMonty(ref_src)
	if(!ref_src)
		ref_src = "\ref[src]"
	. = ADMIN_FULLMONTY_NONAME(initiator.mob)
	if(state == MHELP_ACTIVE)
		. += ClosureLinks(ref_src)

//private
/datum/mentor_help/proc/ClosureLinks(ref_src)
	if(!ref_src)
		ref_src = "\ref[src]"
	. = " (<A HREF='?_src_=holder;mhelp=[ref_src];mhelp_action=reject'>REJT</A>)"
	. += " (<A HREF='?_src_=holder;mhelp=[ref_src];mhelp_action=icissue'>IC</A>)"
	. += " (<A HREF='?_src_=holder;mhelp=[ref_src];mhelp_action=close'>CLOSE</A>)"
	. += " (<A HREF='?_src_=holder;mhelp=[ref_src];mhelp_action=resolve'>RSLVE</A>)"

//private
/datum/mentor_help/proc/LinkedReplyName(ref_src)
	if(!ref_src)
		ref_src = "\ref[src]"
	return "<A HREF='?_src_=holder;mhelp=[ref_src];mhelp_action=reply'>[initiator_key_name]</A>"

//private
/datum/mentor_help/proc/TicketHref(msg, ref_src, action = "ticket")
	if(!ref_src)
		ref_src = "\ref[src]"
	return "<A HREF='?_src_=holder;mhelp=[ref_src];mhelp_action=[action]'>[msg]</A>"

//message from the initiator without a target, all admins will see this
//won't bug irc
/datum/mentor_help/proc/MessageNoRecipient(msg)
	var/ref_src = "\ref[src]"
	var/chat_msg = "<span class='adminnotice'><span class='adminhelp'>Mentor Ticket [TicketHref("#[id]", ref_src)]</span><b>: [LinkedReplyName(ref_src)] [FullMonty(ref_src)]:</b> [msg]</span>"

	AddInteraction("<font color='red'>[LinkedReplyName(ref_src)]: [msg]</font>")
	//send this msg to all admins

	for(var/client/X in GLOB.staff)
		if(X.prefs.toggles & SOUND_ADMINHELP)
			X << 'sound/effects/adminhelp.ogg'
		window_flash(X, ignorepref = TRUE)
		to_chat(X, chat_msg)

	//show it to the person mentorhelping too
	to_chat(initiator, "<span class='adminnotice'>Mentor PM to-<b>Staff</b>: [name]</span>")

//Reopen a closed ticket
/datum/mentor_help/proc/Reopen()
	if(state == MHELP_ACTIVE)
		to_chat(usr, "<span class='warning'>This ticket is already open.</span>")
		return

	if(GLOB.mhelp_tickets.CKey2ActiveTicket(initiator_ckey))
		to_chat(usr, "<span class='warning'>This user already has an active ticket, cannot reopen this one.</span>")
		return

	statclick = new(null, src)
	GLOB.mhelp_tickets.m_active_tickets += src
	GLOB.mhelp_tickets.m_closed_tickets -= src
	GLOB.mhelp_tickets.m_resolved_tickets -= src
	switch(state)
		if(MHELP_CLOSED)
			SSblackbox.dec("mhelp_close")
		if(MHELP_RESOLVED)
			SSblackbox.dec("mhelp_resolve")
	state = MHELP_ACTIVE
	closed_at = null
	if(initiator)
		initiator.mentor_current_ticket = src

	AddInteraction("<font color='purple'>Reopened by [key_name_admin(usr)]</font>")
	var/msg = "<span class='adminhelp'>Mentor Ticket [TicketHref("#[id]")] reopened by [key_name_admin(usr)].</span>"
	message_staff(msg)
	log_admin_private(msg)
	SSblackbox.inc("mhelp_reopen")
	TicketPanel()	//can only be done from here, so refresh it

//private
/datum/mentor_help/proc/RemoveActive()
	if(state != MHELP_ACTIVE)
		return
	closed_at = world.time
	QDEL_NULL(statclick)
	GLOB.mhelp_tickets.m_active_tickets -= src
	if(initiator && initiator.mentor_current_ticket == src)
		initiator.mentor_current_ticket = null

//Mark open ticket as closed/meme
/datum/mentor_help/proc/Close(key_name = key_name_admin(usr), silent = FALSE)
	if(state != MHELP_ACTIVE)
		return
	RemoveActive()
	state = MHELP_CLOSED
	GLOB.mhelp_tickets.ListInsert(src)
	AddInteraction("<font color='red'>Closed by [key_name].</font>")
	if(!silent)
		SSblackbox.inc("mhelp_close")
		var/msg = "Ticket [TicketHref("#[id]")] closed by [key_name]."
		message_staff(msg)
		log_admin_private(msg)

//Mark open ticket as resolved/legitimate, returns mhelp verb
/datum/mentor_help/proc/Resolve(key_name = key_name_admin(usr), silent = FALSE)
	if(state != MHELP_ACTIVE)
		return
	RemoveActive()
	state = MHELP_RESOLVED
	GLOB.mhelp_tickets.ListInsert(src)

	if(initiator)
		initiator.giveadminhelpverb()

	AddInteraction("<font color='green'>Resolved by [key_name].</font>")
	if(!silent)
		SSblackbox.inc("mhelp_resolve")
		var/msg = "Ticket [TicketHref("#[id]")] resolved by [key_name]"
		message_staff(msg)
		log_admin_private(msg)

//Close and return mhelp verb, use if ticket is incoherent
/datum/mentor_help/proc/Reject(key_name = key_name_admin(usr))
	if(state != MHELP_ACTIVE)
		return

	if(initiator)
		initiator.giveadminhelpverb()

		initiator << 'sound/effects/adminhelp.ogg'

		to_chat(initiator, "<font color='red' size='4'><b>- MentorHelp Rejected! -</b></font>")
		to_chat(initiator, "<font color='red'><b>Your mentor help was rejected.</b> The mentorhelp verb has been returned to you so that you may try again.</font>")
		to_chat(initiator, "Please try to be calm, clear, and descriptive in mentor helps, they will try and help to the best of their abilities.")

	SSblackbox.inc("mhelp_reject")
	var/msg = "Mentor Ticket [TicketHref("#[id]")] rejected by [key_name]"
	message_staff(msg)
	log_admin_private(msg)
	AddInteraction("Rejected by [key_name].")
	Close(silent = TRUE)

//Resolve ticket with IC Issue message
/datum/mentor_help/proc/ICIssue(key_name = key_name_admin(usr))
	if(state != MHELP_ACTIVE)
		return

	var/msg = "<font color='red' size='4'><b>- MentorHelp marked as IC issue! -</b></font><br>"
	msg += "<font color='red'><b>Losing is part of the game!</b></font><br>"
	msg += "<font color='red'>Your character will frequently die, sometimes without even a possibility of avoiding it. Events will often be out of your control. No matter how good or prepared you are, sometimes you just lose.</font>"

	if(initiator)
		to_chat(initiator, msg)

	SSblackbox.inc("mhelp_icissue")
	msg = "Mentor Ticket [TicketHref("#[id]")] marked as IC by [key_name]"
	message_staff(msg)
	log_admin_private(msg)
	AddInteraction("Marked as IC issue by [key_name]")
	Resolve(silent = TRUE)

//Show the ticket panel
/datum/mentor_help/proc/TicketPanel()
	var/list/dat = list("<html><head><title>Mentor Ticket #[id]</title></head>")
	var/ref_src = "\ref[src]"
	dat += "<h4>Mentor Help Ticket #[id]: [LinkedReplyName(ref_src)]</h4>"
	dat += "<b>State: "
	switch(state)
		if(MHELP_ACTIVE)
			dat += "<font color='red'>OPEN</font>"
		if(MHELP_RESOLVED)
			dat += "<font color='green'>RESOLVED</font>"
		if(MHELP_CLOSED)
			dat += "CLOSED"
		else
			dat += "UNKNOWN"
	dat += "</b>[GLOB.TAB][TicketHref("Refresh", ref_src)][GLOB.TAB][TicketHref("Re-Title", ref_src, "retitle")]"
	if(state != MHELP_ACTIVE)
		dat += "[GLOB.TAB][TicketHref("Reopen", ref_src, "reopen")]"
	dat += "<br><br>Mentor Help Opened at: [gameTimestamp(wtime = opened_at)] (Approx [(world.time - opened_at) / 600] minutes ago)"
	if(closed_at)
		dat += "<br>Mentor Help Closed at: [gameTimestamp(wtime = closed_at)] (Approx [(world.time - closed_at) / 600] minutes ago)"
	dat += "<br><br>"
	if(initiator)
		dat += "<b>Actions:</b> [FullMonty(ref_src)]<br>"
	else
		dat += "<b>Mentor Help DISCONNECTED</b>[GLOB.TAB][ClosureLinks(ref_src)]<br>"
	dat += "<br><b>Log:</b><br><br>"
	for(var/I in _interactions)
		dat += "[I]<br>"

	usr << browse(dat.Join(), "window=mhelp[id];size=620x480")

/datum/mentor_help/proc/Retitle()
	var/new_title = input(usr, "Enter a title for the ticket", "Rename Ticket", name) as text|null
	if(new_title)
		name = new_title
		//not saying the original name cause it could be a long ass message
		var/msg = "Ticket [TicketHref("#[id]")] titled [name] by [key_name_admin(usr)]"
		message_staff(msg)
		log_admin_private(msg)
	TicketPanel()	//we have to be here to do this

//Forwarded action from mentor/Topic
/datum/mentor_help/proc/Action(action)
	testing("Mhelp action: [action]")
	switch(action)
		if("ticket")
			TicketPanel()
		if("retitle")
			Retitle()
		if("reject")
			Reject()
		if("reply")
			usr.client.cmd_mhelp_reply(initiator)
		if("icissue")
			ICIssue()
		if("close")
			Close()
		if("resolve")
			Resolve()
		if("reopen")
			Reopen()

//
// TICKET STATCLICK
//

/obj/effect/statclick/mhelp
	var/datum/mentor_help/mhelp_datum

/obj/effect/statclick/mhelp/Initialize(mapload, datum/mentor_help/MH)
	mhelp_datum = MH
	. = ..()

/obj/effect/statclick/mhelp/update()
	return ..(mhelp_datum.name)

/obj/effect/statclick/mhelp/Click()
	mhelp_datum.TicketPanel()

/obj/effect/statclick/mhelp/Destroy()
	mhelp_datum = null
	return ..()

//
// CLIENT PROCS
//

/client/proc/givementorhelpverb()
	src.verbs |= /client/verb/mentorhelp
	deltimer(mentorhelptimerid)
	mentorhelptimerid = 0

/client/verb/mentorhelp(msg as text)
	set category = "Admin"
	set name = "Mentorhelp"

	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='danger'>Speech is currently admin-disabled.</span>")
		return

	//handle muting and automuting
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, "<span class='danger'>Error: Mentor-PM: You cannot send mentorhelps (Muted).</span>")
		return
	if(handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

	if(!msg)
		return

	SSblackbox.add_details("mentor_verb","Mentorhelp") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	if(mentor_current_ticket)
		if(alert(usr, "You already have a mentor ticket open. Is this for the same issue?",,"Yes","No") != "No")
			if(mentor_current_ticket)
				mentor_current_ticket.MessageNoRecipient(msg)
				mentor_current_ticket.TimeoutVerb()
				return
			else
				to_chat(usr, "<span class='warning'>Ticket not found, creating new one...</span>")
		else
			mentor_current_ticket.AddInteraction("[key_name_admin(usr)] opened a new ticket.")
			mentor_current_ticket.Close()

	new /datum/mentor_help(msg, src, FALSE)

//mentor proc
/client/proc/cmd_mentor_ticket_panel()
	set name = "Show Mentor Ticket List"
	set category = "Admin"

	if(!check_rights(R_MENTOR, TRUE))
		return

	var/browse_to

	switch(input("Display which mentor ticket list?") as null|anything in list("Active Tickets", "Closed Tickets", "Resolved Tickets"))
		if("Active Tickets")
			browse_to = MHELP_ACTIVE
		if("Closed Tickets")
			browse_to = MHELP_CLOSED
		if("Resolved Tickets")
			browse_to = MHELP_RESOLVED
		else
			return

	GLOB.mhelp_tickets.BrowseTickets(browse_to)

//
// LOGGING
//

//Use this proc when an mentor takes action that may be related to an open ticket on what
//what can be a client, ckey, or mob
/proc/mentor_ticket_log(what, message)
	var/client/C
	var/mob/Mob = what
	if(istype(Mob))
		C = Mob.client
	else
		C = what
	if(istype(C) && C.mentor_current_ticket)
		C.mentor_current_ticket.AddInteraction(message)
		return C.mentor_current_ticket
	if(istext(what))	//ckey
		var/datum/mentor_help/MH = GLOB.mhelp_tickets.CKey2ActiveTicket(what)
		if(MH)
			MH.AddInteraction(message)
			return MH

//
// HELPER PROCS
//

/proc/get_mentor_counts(requiredflags = R_BAN)
	. = list("total" = list(), "noflags" = list(), "afk" = list(), "stealth" = list(), "present" = list())
	for(var/client/X in GLOB.staff)
		.["total"] += X
		if(requiredflags != 0 && !check_rights_for(X, requiredflags))
			.["noflags"] += X
		else if(X.is_afk())
			.["afk"] += X
		else if(X.holder.fakekey)
			.["stealth"] += X
		else
			.["present"] += X
