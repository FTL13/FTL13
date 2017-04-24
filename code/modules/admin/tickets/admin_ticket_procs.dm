
/datum/admin_ticket/proc/add_log(var/message, var/user_in)
	if(!owner && istext(owner_ckey))
		owner = directory[owner_ckey]

	var/client/user
	if(!user_in)
		user = get_client(usr)
	else
		if(ismob(user_in))
			var/mob/temp = user_in
			user = temp.client
		else if(istype(user_in, /client))
			var/client/temp = user_in
			user = temp
		else
			user = get_client(user_in)

	if(!log)
		return

	if(compare_ckey(user, owner_ckey))
		owner = user

	if(user.holder && !handling_admin)
		if(!compare_ckey(user, owner_ckey))
			handling_admin = get_client(user)
			world << output("[key_name_params(handling_admin, 1, 1, null, src)]", "ViewTicketLog[ticket_id].browser:handling_user")
			if(!is_admin(owner))
				for(var/client/X in admins)
					X << "<span class='ticket-status'>-- [get_view_link(X)] has been claimed by [key_name_params(handling_admin, 1, 1)]</span>"

	var/datum/ticket_log/log_item = null
	if(istype(message, /datum/ticket_log))
		log_item = message
	else
		log_item = new /datum/ticket_log(src, user, message, 0)

	log += log_item

	if(!log_item.for_admins)
		world << output(log_item.toString(), "ViewTicketLog[ticket_id].browser:add_message")
	else
		for(var/client/X in admins)
			X << output(log_item.toAdminString(), "ViewTicketLog[ticket_id].browser:add_message")

	var/list/messageSentTo = list()

	if(!compare_ckey(handling_admin, user))
		if(!(get_ckey(handling_admin) in messageSentTo))
			messageSentTo += get_ckey(handling_admin)
			handling_admin << "<span class='ticket-text-received'>-- [get_view_link(user)] [key_name_params(user, 1, 1, null, src)] -> [log_item.isAdminComment() ? get_view_link(user) : key_name_params(handling_admin, 0, 1, null, src)]: [log_item.text]</span>"
			if(has_pref(handling_admin, SOUND_ADMINHELP))
				handling_admin << 'sound/effects/adminhelp.ogg'

	if(!log_item.for_admins && compare_ckey(owner_ckey, user) || compare_ckey(handling_admin, user))
		if(!(get_ckey(owner) in messageSentTo))
			messageSentTo += get_ckey(owner)

			if(!compare_ckey(owner_ckey, user))
				if(!is_admin(owner)) owner << "<span class='ticket-header-recieved'>-- Administrator private message --</span>"
				if(has_pref(owner, SOUND_ADMINHELP))
					owner << 'sound/effects/adminhelp.ogg'

			if(compare_ckey(owner_ckey, user))
				var/toLink
				if(!handling_admin)
					toLink = "Admins"
				else
					toLink = is_admin(owner) ? key_name_params(handling_admin, 1, 1, null, src) : key_name_params(handling_admin, 1, 0, null, src)

				owner << "<span class='ticket-text-sent'>-- [key_name_params(owner, 0, 0, null, src)] -> [toLink]: [log_item.text]</span>"
			else
				owner << "<span class='ticket-text-received'>-- [is_admin(owner) ? key_name_params(user, 1, 1, null, src) : key_name_params(user, 1, 0, null, src)] -> [key_name_params(owner, 0, 0, null, src)]: [log_item.text]</span>"
				if(!is_admin(owner)) owner << "<span class='ticket-admin-reply'>Click on the administrator's name to reply.</span>"

	if(!compare_ckey(user, owner_ckey))
		if(!(get_ckey(user) in messageSentTo))
			messageSentTo += get_ckey(user)

			user << "<span class='ticket-text-sent'>-- [is_admin(user) ? key_name_params(user, 0, 1, null, src) : "[key_name_params(user, 0, 0, null, src)]"] -> [log_item.isAdminComment() ? get_view_link(user) : (is_admin(user) ? key_name_params(owner, 1, 1, null, src) : "[key_name_params(owner, 1, 0, null, src)]")]: [log_item.text] [is_admin(user) ? "(<a href='?src=\ref[src];user=\ref[usr];action=resolve_admin_ticket;ticket=\ref[src]'>Close</a>)" : ""]</span>"

	for(var/M in monitors)
		if(compare_ckey(owner_ckey, M) || compare_ckey(user, handling_admin))
			break
		if(get_ckey(M) in messageSentTo)
			continue
		messageSentTo += get_ckey(M)

		if(compare_ckey(user, owner))
			M << "<span class='ticket-text-sent'>-- [get_view_link(user)] [key_name_params(user, 1, 1, null, src)] -> [key_name_params(owner, 0, 1, null, src)]: [log_item.text_admin]</span>"
		else
			M << "<span class='ticket-text-received'>-- [get_view_link(user)] [key_name_params(user, 1, 1, null, src)] -> [key_name_params(handling_admin, 0, 1, null, src)]: [log_item.text_admin]</span>"

		if(has_pref(M, SOUND_ADMINHELP))
			M << 'sound/effects/adminhelp.ogg'

	for(var/client/X in admins)
		if(has_pref(X, TICKET_ALL))
			if(compare_ckey(owner, X) || compare_ckey(handling_admin, X) || X in monitors)
				continue
			if(get_ckey(X) in messageSentTo)
				continue
			messageSentTo += get_ckey(X)

			var/target
			if(compare_ckey(user, owner_ckey))
				target = key_name_params(handling_admin, 1, 1)
			else if(compare_ckey(user, handling_admin))
				target = key_name_params(owner, 1, 1)
			else
				target = get_view_link(user)

			if(!target || target == "*null*")
				target = "Admins"

			X << "<span class='ticket-text-[(compare_ckey(X, user) || compare_ckey(X, handling_admin) || target == "Admins") ? "received" : "sent"]'>-- [get_view_link(user)] [key_name_params(user, 1, 1)] -> [target]: [log_item.text_admin]</span>"

	if(compare_ckey(log_item.user, owner_ckey))
		log_admin("Ticket #[ticket_id]: [log_item.user] -> [handling_admin ? handling_admin : "Ticket"] - [log_item.text]")
	else if(compare_ckey(log_item.user, handling_admin))
		log_admin("Ticket #[ticket_id]: [log_item.user] -> [owner_ckey] - [log_item.text]")
	else
		log_admin("Ticket #[ticket_id]: [log_item.user] -> Ticket #[ticket_id] - [log_item.text]")

/datum/admin_ticket/proc/get_view_link(var/mob/user)
	return "<a href='?src=\ref[src];user=\ref[user];action=view_admin_ticket;ticket=\ref[src]'>Ticket #[src.ticket_id]</a>"

/datum/admin_ticket/proc/is_monitor(var/client/C)
	return (C in monitors) ? 1 : 0

/datum/admin_ticket/proc/check_unclaimed()
	spawn(600)
		if(!handling_admin && !resolved)
			check_unclaimed()
			for(var/client/X in admins)
				X << "<span class='ticket-status'>[get_view_link(X)] is still unclaimed.</span>"
				if(has_pref(X, SOUND_ADMINHELP))
					X << 'sound/effects/adminhelp.ogg'

/datum/admin_ticket/proc/toggle_monitor()
	var/foundMonitor = 0
	for(var/M in monitors)
		if(compare_ckey(M, usr))
			foundMonitor = 1

	var/monitoring
	if(!foundMonitor)
		log_admin("[usr] is now monitoring ticket #[ticket_id]")
		monitors += get_client(usr)
		usr << "<span class='ticket-status'>You are now monitoring this ticket</span>"
		monitoring = 1
	else
		log_admin("[usr] is no longer monitoring ticket #[ticket_id]")
		monitors -= get_client(usr)
		usr << "<span class='ticket-status'>You are no longer monitoring this ticket</span>"
		monitoring = 0

	var/monitors_text = ""
	if(monitors.len > 0)
		monitors_text += "Monitors:"
		for(var/MO in monitors)
			monitors_text += " <span class='monitor'>[get_fancy_key(MO)]</span>"

	world << output("[monitors_text] ", "ViewTicketLog[ticket_id].browser:set_monitors")

	return monitoring

/datum/admin_ticket/proc/toggle_resolved()
	resolved = !resolved

	//var/totalCount = 0
	var/unresolvedCount = 0
	for(var/datum/admin_ticket/T in tickets_list)
		//totalCount++
		if(!T.resolved)
			unresolvedCount++

	var/list/to_process = list()

	//to_process += owner
	to_process += handling_admin

	for(var/client/X in admins)
		if(has_pref(X, TICKET_ALL))
			if(!(X in to_process))
				to_process += X

	for(var/M in monitors)
		if(!(M in to_process))
			to_process += M

	for(var/client/C in to_process)
		C << "<span class='ticket-status'>-- [get_view_link(C)] has been set '<b>[resolved ? "resolved" : "unresolved"]</b>' by [key_name_params(usr, is_admin(C), is_admin(C))]</span>"

	if(resolved)
		log_admin("Ticket #[ticket_id] marked as resolved by [get_fancy_key(usr)].")
		owner << "<span class='ticket-text-received'>Your ticket has been marked as resolved.</span>"
	else
		log_admin("Ticket #[ticket_id] marked as unresolved by [get_fancy_key(usr)].")
		owner << "<span class='ticket-text-received'>Your ticket has been marked as unresolved.</span>"
	world << output("[resolved]", "ViewTicketLog[ticket_id].browser:set_resolved")

	if(resolved && ticker.delay_end)
		if(unresolvedCount == 0)
			if(check_rights_for(get_client(usr), R_TICKET)) //Only admins get to select whether to restart server or not
				if(alert(usr, "You have resolved the last ticket (the server restart is currently delayed!). Would you like to restart the server now?", "Restart Server", "Restart", "Cancel") == "Restart")
					ticker.delay_end = 0
					world.Reboot("Initiated by [usr.client.holder.fakekey ? "Admin" : usr.key].", "end_proper", "proper completion", 100)
				else
					message_admins("[usr.key] has closed the last ticket but chose not to restart the server. You can <A HREF='?_src_=holder;adminserverrestart=1'>restart the server</a> manually, if you choose to do so.")
			else
				message_admins("[usr.key] closed their ticket which was the last ticket. Server can now be <A HREF='?_src_=holder;adminserverrestart=1'>restarted</a>.")

	if(resolved)
		if(!establish_db_connection())
			log_world("Admin ticket database connection failure.")
			diary << "Admin ticket database connection failure."
			return

		var/DBQuery/query = dbcon.NewQuery("SELECT id FROM [format_table_name("admin_tickets")] WHERE round_id = [round_number] AND ticket_id = [ticket_id]")
		query.Execute()
		if(!query.NextRow())
			var/content = ""
			for(var/datum/ticket_log/line in log)
				content += "[line.user][line.user_admin ? " A" : ""]: [line.text]\n"
			var/DBQuery/insert = dbcon.NewQuery("INSERT INTO [format_table_name("admin_tickets")] (round_id, ticket_id, ckey, a_ckey, content) VALUES ([round_number], [ticket_id], '[owner_ckey]', '[get_client(handling_admin)]', '[content]')")
			insert.Execute()

/datum/admin_ticket/proc/view_log()
	if(!owner && istext(owner_ckey))
		owner = directory[owner_ckey]

	var/reply_link = "<a href='?src=\ref[src];user=\ref[usr];action=reply_to_ticket;ticket=\ref[src]'><img border='0' width='16' height='16' class='uiIcon16 icon-comment' /> Reply</a>"
	var/refresh_link = "<a href='?src=\ref[src];user=\ref[usr];action=refresh_admin_ticket;ticket=\ref[src]'><img border='0' width='16' height='16' class='uiIcon16 icon-refresh' /> Refresh</a>"

	var/content = ""
	content += "<p class='control-bar'><a href='#bottom' name='top'>To Bottom</a> [reply_link] [refresh_link]</p>"
	content += "<p class='title-bar'>[title]</p>"
	content += "<p class='info-bar'>Primary Admin: <span id='primary-admin'>[handling_admin != null ? (usr.client.holder ? key_name_params(handling_admin, 1, 1, null, src) : "[key_name_params(handling_admin, 1, 0, null, src)]") : "Unassigned"]</span></p>"

	content += "<p id='monitors' class='[monitors.len > 0 ? "shown" : "hidden"]'>Monitors:"
	for(var/M in monitors)
		content += " <span class='monitor'>[key_name(M, 0, 0)]</span>"
	content += "</p>"

	content += "<p class='resolved-bar [resolved ? "resolved" : "unresolved"]' id='resolved'>[resolved ? "Is resolved" : "Is not resolved"]</p>"

	if(usr.client.holder && owner)
		content += {"<div class='user-bar'>
			<p>[key_name(owner, 1)]</p>"}

		if(owner && owner.mob)
			content += {"<p style='margin-top: 5px;'>
					<a href='?_src_=holder;adminmoreinfo=\ref[owner.mob]'><img border='0' width='16' height='16' class='uiIcon16 icon-search' /> ?</a>
					<a href='?_src_=holder;adminplayeropts=\ref[owner.mob]'><img border='0' width='16' height='16' class='uiIcon16 icon-clipboard' /> PP</a>
					<a href='?_src_=vars;Vars=\ref[owner.mob]'><img border='0' width='16' height='16' class='uiIcon16 icon-clipboard' /> VV</a>
					<a href='?_src_=holder;subtlemessage=\ref[owner.mob]'><img border='0' width='16' height='16' class='uiIcon16 icon-mail-closed' /> SM</a>
					<a href='?_src_=holder;adminplayerobservefollow=\ref[owner.mob]'><img border='0' width='16' height='16' class='uiIcon16 icon-arrowthick-1-e' /> FLW</a>
					<a href='?_src_=holder;secretsadmin=check_antagonist'><img border='0' width='16' height='16' class='uiIcon16 icon-clipboard' /> CA</a>
					<a href='?src=\ref[src];user=\ref[usr];action=monitor_admin_ticket;ticket=\ref[src]' class='monitor-button'><img border='0' width='16' height='16' class='uiIcon16 icon-pin-s' /> <span>[!is_monitor(usr.client) ? "Un" : ""]Monitor</span></a>
					<a href='?src=\ref[src];user=\ref[usr];action=resolve_admin_ticket;ticket=\ref[src]' class='resolve-button'><img border='0' width='16' height='16' class='uiIcon16 icon-check' /> <span>[resolved ? "Un" : ""]Resolve</span></a>
					<a href='?src=\ref[src];user=\ref[usr];action=administer_admin_ticket;ticket=\ref[src]' class='admin-button'><img border='0' width='16' height='16' class='uiIcon16 icon-flag' /> <span>Administer</span></a>
					<a href='?src=\ref[src];user=\ref[usr];action=toggle_popup;ticket=\ref[src]' class='resolve-button'><img border='0' width='16' height='16' class='uiIcon16 icon-check' /> <span>[force_popup ? "De" : ""]Activate popups</span></a>
				</p>"}
		if(owner && owner.mob)
			if(owner.mob.mind && owner.mob.mind.assigned_role)
				content += "<p class='user-info-bar'>Role: [owner.mob.mind.assigned_role]</p>"
				if(owner.mob.mind.special_role)
					content += "<p class='user-info-bar'>Antagonist: [owner.mob.mind.special_role]</p>"
				else
					content += "<p class='user-info-bar'>Antagonist: No</p>"

			var/turf/T = get_turf(owner.mob)

			var/location = ""
			if(isturf(T))
				if(isarea(T.loc))
					location = "([owner.mob.loc == T ? "at " : "in [owner.mob.loc] at "] [T.x], [T.y], [T.z] in area <b>[T.loc]</b>)"
				else
					location = "([owner.mob.loc == T ? "at " : "in [owner.mob.loc] at "] [T.x], [T.y], [T.z])"

			if(location)
				content += "<p class='user-info-bar'>Location: [location]</p>"

		content += "</div>"
	else
		if(usr.client.holder)
			content += "<div class='user-bar'>"
			content += {"<p style='margin-top: 5px;'>
					<a href='?src=\ref[src];user=\ref[usr];action=monitor_admin_ticket;ticket=\ref[src]' class='monitor-button'><img border='0' width='16' height='16' class='uiIcon16 icon-pin-s' /> <span>[!is_monitor(usr.client) ? "Un" : ""]Monitor</span></a>
					<a href='?src=\ref[src];user=\ref[usr];action=resolve_admin_ticket;ticket=\ref[src]' class='resolve-button'><img border='0' width='16' height='16' class='uiIcon16 icon-check' /> <span>[resolved ? "Un" : ""]Resolve</span></a>
					<a href='?src=\ref[src];user=\ref[usr];action=administer_admin_ticket;ticket=\ref[src]' class='admin-button'><img border='0' width='16' height='16' class='uiIcon16 icon-flag' /> <span>Administer</span></a>
				</p>"}
			content += "</div>"
		else if(!admin_started_ticket)
			content += "<div class='user-bar'>"
			content += {"<p style='margin-top: 5px;'>
					<a href='?src=\ref[src];user=\ref[usr];action=resolve_admin_ticket;ticket=\ref[src]'><img border='0' width='16' height='16' class='uiIcon16 icon-check' /> Close ticket</a>
				</p>"}
			content += "</div>"

	content += "<div id='messages'>"

	var/i = 0
	for(i = 1; i <= log.len; i++)
		var/datum/ticket_log/item = log[i]
		if((item.for_admins && usr.client.holder) || !item.for_admins)
			content += "<p class='message-bar'>[item.toString()]</p>"

	// New ticket logs added to top - If reverting this, do not forget to prepend in the template!
	/*for(i = log.len; i > 0; i--)
		var/datum/ticket_log/item = log[i]
		if((item.for_admins && usr.client.holder) || !item.for_admins)
			content += "<p class='message-bar'>[item.toString()]</p>"*/

	content += "</div>"

	content += "<p class='control-bar'><a href='#top' name='bottom'>To Top</a> [reply_link] [refresh_link]</p>"
	content += "<br /></div></body></html>"

	var/html = get_html("Admin Ticket Interface", "", "", content)

	usr << browse(null, "window=ViewTicketLog[ticket_id]")
	usr << browse(html, "window=ViewTicketLog[ticket_id]")

/proc/total_unresolved_tickets()
	var/unresolved_tickets = 0
	for(var/datum/admin_ticket/T in tickets_list)
		if(!T.resolved)
			unresolved_tickets++
	return unresolved_tickets
