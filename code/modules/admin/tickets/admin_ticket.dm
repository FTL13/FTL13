var/list/tickets_list = list()
var/ticket_count = 0
var/ticket_counter_visible_to_everyone = 0

/datum/ticket_log
	var/datum/admin_ticket/parent
	var/gametime
	var/user
	var/user_admin = 0
	var/text
	var/text_admin
	var/for_admins

/datum/ticket_log/New(var/datum/admin_ticket/parent, var/user, var/text, var/for_admins = 0)
	src.gametime = gameTimestamp()
	src.parent = parent
	if(istype(user, /client))
		src.user_admin = is_admin(user)
	else
		src.user_admin = text
	src.for_admins = for_admins
	if(istype(user, /client))
		src.user = get_fancy_key(user)
	else
		src.user = user
	src.text = text
	src.text_admin = generate_admin_info(text)

/datum/ticket_log/proc/isAdminComment()
	return istype(user, /client) && (for_admins && !(compare_ckey(parent.owner_ckey, user) || compare_ckey(parent.handling_admin, user)) ? 1 : 0)

/datum/ticket_log/proc/toSanitizedString()
	return "[gametime] - [user] - [text]"
/datum/ticket_log/proc/toString()
	return "[gametime] - [isAdminComment() ? "<font color='red'>" : ""]<b>[istype(user, /client) ? key_name_params(user, 0, 0, null, parent) : user]</b>[isAdminComment() ? "</font>" : ""] - [text]"

/datum/ticket_log/proc/toAdminString()
	return "[gametime] - [isAdminComment() ? "<font color='red'>" : ""]<b>[istype(user, /client) ? key_name_params(user, 0, 1, null, parent) : user]</b>[isAdminComment() ? "</font>" : ""] - [text_admin]"

/datum/ticket_log/proc/toLogString()
	return "[isAdminComment() ? "COMMENT - " : ""][istype(user, /client) ? key_name_params(user, 0, 1, null, parent) : user] - [text]"



/datum/admin_ticket
	var/ticket_id
	var/client/owner
	var/owner_ckey
	var/title
	var/list/log = list()
	var/resolved = 0
	var/list/monitors = list()
	var/client/handling_admin = null
	var/client/pm_started_user = null
	var/pm_started_flag = 0
	var/error = 0
	var/force_popup = 0
	//var/log_file
	var/admin_started_ticket = 0

/datum/admin_ticket/New(nowner, ntitle, ntarget)
	if(compare_ckey(nowner, ntarget))
		to_chat(usr, "<span class='ticket-status'>You cannot make a ticket for yourself</span>")
		error = 1
		return

	owner = get_client(nowner)
	owner_ckey = get_ckey(owner)

	if(owner.holder && ntarget)
		handling_admin = get_client(owner)
		owner = get_client(ntarget)
		owner_ckey = get_ckey(ntarget)
		admin_started_ticket = 1

	for(var/datum/admin_ticket/T in tickets_list)
		if(!T.resolved && (compare_ckey(owner_ckey, T.owner_ckey)))
			error = 1
			to_chat(usr, "<span class='ticket-status'>Ticket not created. This user already has a ticket. You can view it here: [T.get_view_link(usr)]</span>")
			return

	if(ntitle)
		title = format_text(ntitle)
	ticket_count++
	ticket_id = ticket_count

	var/admin_title = generate_admin_info(title)

	log += new /datum/ticket_log(src, usr, title, 0)

	var/msg = "<span class='ticket-text-received'><b>[get_view_link(usr)] created: [key_name_params(owner, 1, 1, "new=1", src)]: [admin_title] (<a href='?_src_=holder;adminmoreinfo=\ref[owner.mob]'>?</a> | <a href='?_src_=holder;adminplayerobservefollow=\ref[owner.mob]'>FLW</A>)</span>"

	var/tellAdmins = 1
	if(compare_ckey(owner, ntarget))
		tellAdmins = 0
		if(!is_admin(owner)) to_chat(owner, "<span class='ticket-header-recieved'>-- Administrator private message --</span>")
		to_chat(owner, "<span class='ticket-text-received'>Ticket created by [is_admin(owner) ? key_name_params(handling_admin, 1, 1, null, src) : key_name_params(handling_admin, 1, 0, null, src)] for you: \"[title]\"</span>")
		if(!is_admin(owner)) to_chat(owner, "<span class='ticket-admin-reply'>Click on the administrator's name to reply.</span>")
		to_chat(handling_admin, "<span class='ticket-text-sent'>Ticket created by you for [is_admin(handling_admin) ? key_name_params(ntarget, 1, 1, null, src) : key_name_params(ntarget, 1, 0, null, src)]: \"[admin_title]\"</span>")
		log += new /datum/ticket_log(src, usr, "Ticket created by <b>[handling_admin] for [ntarget]</b>", 0)
		if(has_pref(owner, SOUND_ADMINHELP))
			owner << 'sound/effects/adminhelp.ogg'
		if(has_pref(handling_admin, SOUND_ADMINHELP))
			handling_admin << 'sound/effects/adminhelp.ogg'
	else
		log += new /datum/ticket_log(src, usr, "Ticket created by <b>[owner]</b>", 0)
		to_chat(owner, "<span class='ticket-status'>Ticket created for Admins: \"[title]\"</span>")
		if(has_pref(owner, SOUND_ADMINHELP))
			owner << 'sound/effects/adminhelp.ogg'

	if(usr.client.holder && owner && !owner.holder && compare_ckey(usr, handling_admin) && force_popup)
		spawn()	//so we don't hold the caller proc up
			var/sender = usr.client
			var/sendername = usr.client.key
			var/reply = input(owner, title,"Admin PM from-[sendername]", "") as text|null		//show message and await a reply
			if(reply && sender)
				owner.cmd_admin_pm(sender,reply)										//sender is still about, let's reply to them

	var/admin_number_total = 0		//Total number of admins
	var/admin_number_afk = 0		//Holds the number of admins who are afk
	var/admin_number_ignored = 0	//Holds the number of admins without +BAN (so admins who are not really admins)
	var/admin_number_decrease = 0	//Holds the number of admins with are afk, ignored or both
	if(tellAdmins)
		//send this msg to all admins
		for(var/client/X in admins)
			if(compare_ckey(owner, X) || compare_ckey(ntarget, X))
				continue
			admin_number_total++
			var/invalid = 0
			if(!check_rights_for(X, R_BAN))
				admin_number_ignored++
				invalid = 1
			if(X.is_afk())
				admin_number_afk++
				invalid = 1
			if(invalid)
				admin_number_decrease++
			if(has_pref(X, SOUND_ADMINHELP))
				X << 'sound/effects/adminhelp.ogg'
			to_chat(X, msg)

	var/admin_number_present = admin_number_total - admin_number_decrease	//Number of admins who are neither afk nor invalid
	log_admin("Ticket #[ticket_id]: [key_name(owner)]: [title] - heard by [admin_number_present] non-AFK admins who have +BAN.")
	if(admin_number_present <= 0)
		if(!admin_number_afk && !admin_number_ignored)
			send2irc(owner.ckey, "Ticket - [title] - No admins online")
		else
			send2irc(owner.ckey, "Ticket - [title] - All admins AFK ([admin_number_afk]/[admin_number_total]) or skipped ([admin_number_ignored]/[admin_number_total])")

	check_unclaimed()