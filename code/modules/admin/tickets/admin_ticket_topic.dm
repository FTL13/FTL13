
/datum/admin_ticket/Topic(href, href_list[])
	..()
	var/mob/M = locate(href_list["user"])
	var/client/C = usr.client

	if(!C.holder && !M)
		message_admins("EXPLOIT \[admin_ticket\]: [usr] attempted to operate a ticket, it is missing a src key.")
		return

	if(href_list["action"] == "view_admin_ticket")
		var/datum/admin_ticket/T = locate(href_list["ticket"])
		if(!istype(T, /datum/admin_ticket))
			message_admins("EXPLOIT \[admin_ticket\]: [M] attempted to view a ticket, the ref supplied was not a ticket.")
			return

		if(!C.holder && !compare_ckey(M, T.owner_ckey))
			message_admins("EXPLOIT \[admin_ticket\]: [M] attempted to view a ticket, they are not an admin or the owner of the ticket.")
			return

		T.view_log(C.mob)
	else if(href_list["action"] == "reply_to_ticket")
		if(C.prefs.muted & MUTE_ADMINHELP)
			to_chat(M, "<font color='red'>Error: Admin-PM: You are unable to use admin PM-s (muted).</font>")
			return

		var/datum/admin_ticket/T = locate(href_list["ticket"])

		if(!istype(T, /datum/admin_ticket))
			message_admins("EXPLOIT \[admin_ticket\]: [M] attempted to reply to a ticket, the ref supplied was not a ticket.")
			return

		if(T.resolved && !C.holder)
			to_chat(usr, "<span class='ticket-status'>This ticket is marked as resolved. You may not add any more information to it.</span>")
			return

		if(!C.holder && !compare_ckey(M, T.owner_ckey))
			to_chat(usr, "<span class='ticket-status'>You are not the owner or primary admin of this ticket. You may not reply to it.</span>")
			return

		var/logtext = input("Please enter your [(!compare_ckey(usr, T.handling_admin) && !compare_ckey(usr, T.owner_ckey) ? "supplimentary comment" : "reply")]:") as text|null

		logtext = replacetext(logtext, "'", "\'")
		logtext = sanitize(copytext(logtext,1,MAX_MESSAGE_LEN))


		if(logtext)
			T.add_log(new /datum/ticket_log(src, C, logtext, (!compare_ckey(usr, T.handling_admin) && !compare_ckey(usr, T.owner_ckey)) ? 1 : 0), M)

			if(C.holder && T.owner && !T.owner.holder && compare_ckey(usr, T.handling_admin) && T.force_popup)
				spawn()	//so we don't hold the caller proc up
					var/sender = C
					var/sendername = C.key
					var/reply = input(T.owner, logtext,"Admin PM from-[sendername]", "") as text		//show message and await a reply
					if(reply)
						if(sender)
							T.owner.cmd_admin_pm(sender,reply)										//sender is still about, let's reply to them
						else
							C.admin_ticket(reply)													//sender has left, adminhelp instead
					return
	else if(href_list["action"] == "monitor_admin_ticket")
		// Limited to admins
		if(!C.holder)
			message_admins("EXPLOIT \[admin_ticket\]: [M] attempted to monitor a ticket, but the user is not an admin.")
			return

		var/datum/admin_ticket/T = locate(href_list["ticket"])
		if(!istype(T, /datum/admin_ticket))
			message_admins("EXPLOIT \[admin_ticket\]: [M] attempted to monitor a ticket, the ref supplied was not a ticket.")
			return

		T.toggle_monitor()
	else if(href_list["action"] == "toggle_popup")
		var/datum/admin_ticket/T = locate(href_list["ticket"])
		if(!istype(T, /datum/admin_ticket))
			message_admins("EXPLOIT \[admin_ticket\]: [M] attempted to toggle popups on a ticket, the ref supplied was not a ticket.")
			return

		if(!C.holder)
			message_admins("EXPLOIT \[admin_ticket\]: [M] attempted to toggle popups on a ticket, but the user is not an admin.")
			return

		T.force_popup = !T.force_popup
		T.view_log(C)

	else if(href_list["action"] == "administer_admin_ticket")
		var/datum/admin_ticket/T = locate(href_list["ticket"])
		if(!istype(T, /datum/admin_ticket))
			message_admins("EXPLOIT \[admin_ticket\]: [M] attempted to administer a ticket, the ref supplied was not a ticket.")
			return

		// This is limited to admins
		if(!C.holder)
			message_admins("EXPLOIT \[admin_ticket\]: [M] attempted to administer a ticket, but the user is not an admin.")
			return

		if(!is_admin(T.owner))
			for(var/client/X in admins)
				to_chat(X, "<span class='ticket-status'>-- [T.get_view_link(X)] has been claimed by [key_name_params(C, 1, 1)] [T.handling_admin ? "(was previously [key_name_params(T.handling_admin, 1, 1)])" : ""]</span>")

		T.handling_admin = C
		log_admin("[T.handling_admin] has been assigned to ticket #[T.ticket_id] as primary admin.")

		world << output("[usr != null ? "[key_name(usr, 1)]" : "Unassigned"]", "ViewTicketLog[T.ticket_id].browser:handling_user")

		if(href_list["reloadlist"])
			C.view_tickets()
	else if(href_list["action"] == "resolve_admin_ticket")
		var/datum/admin_ticket/T = locate(href_list["ticket"])
		if(!istype(T, /datum/admin_ticket))
			message_admins("EXPLOIT \[admin_ticket\]: [M] attempted to resolve a ticket, the ref supplied was not a ticket.")
			return

		// This is limited to admins or ticket owners
		if(!C.holder && !compare_ckey(M, T.owner_ckey))
			message_admins("EXPLOIT \[admin_ticket\]: [M] attempted to resolve a ticket, but the user is not an admin or the ticket owner.")
			return

		if(C.holder || (compare_ckey(M, T.owner_ckey) && !T.resolved && !T.admin_started_ticket))
			T.toggle_resolved()
		else if(compare_ckey(M, T.owner_ckey) && T.resolved)
			to_chat(C, "<span class='ticket-status'>-- Your ticket is already closed. You cannot reopen it.</span>")

		if(href_list["reloadlist"])
			C.view_tickets()
	else if(href_list["action"] == "refresh_admin_ticket")
		var/datum/admin_ticket/T = locate(href_list["ticket"])
		if(!istype(T, /datum/admin_ticket))
			message_admins("EXPLOIT \[admin_ticket\]: [M] attempted to refresh a ticket, the ref supplied was not a ticket.")
			return

		if(!C.holder && !compare_ckey(M, T.owner_ckey))
			message_admins("EXPLOIT \[admin_ticket\]: [M] attempted to view a ticket, but the user is not an admin or the ticket owner.")
			return

		T.view_log(C)
	else if(href_list["vv"])
		if(!C.holder || !ismob(locate(href_list["vv"])))
			return
		C.debug_variables(locate(href_list["vv"]))
	else if(href_list["pp"])
		if(!C.holder || !ismob(locate(href_list["pp"])))
			return
		C.holder.show_player_panel(locate(href_list["pp"]))
	else if(href_list["pm"])
		C.cmd_admin_pm(href_list["pm"],null)
	else if(href_list["sm"])
		if(!C.holder || !ismob(locate(href_list["sm"])))
			return
		C.cmd_admin_subtle_message(locate(href_list["sm"]))
	else if(href_list["jmp"])
		if(!C.holder || !ismob(locate(href_list["jmp"])))
			return
		var/mob/N = locate(href_list["jmp"])
		if(N)
			if(!isobserver(usr))	C.admin_ghost()
			sleep(2)
			C.jumptomob(N)

/client/Topic(href, href_list, hsrc)
	..()

	if(href_list["action"] == "refresh_admin_ticket_list")
		var/client/C = usr.client
		var/flag = href_list["flag"]
		if(!flag)
			flag = TICKET_FLAG_LIST_ALL
		C.view_tickets_main(flag)