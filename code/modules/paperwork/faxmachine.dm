GLOBAL_LIST_EMPTY(all_faxes)
GLOBAL_LIST_EMPTY(all_departments)

GLOBAL_LIST_EMPTY(admin_faxes)	//cache for faxes that have been sent to admins

/obj/machinery/photocopier/faxmachine
	name = "fax machine"
	icon = 'icons/obj/library.dmi'
	icon_state = "fax"
	req_one_access = list(ACCESS_HEADS, ACCESS_ARMORY, ACCESS_LAWYER, ACCESS_QM)

	use_power = IDLE_POWER_USE
	idle_power_usage = 30
	active_power_usage = 200

	var/obj/item/weapon/card/id/scan // identification
	var/authenticated = 0
	var/sendcooldown = 0 // to avoid spamming fax messages
	var/department = "Unknown" // our department
	var/destination // the department we're sending to

	var/static/list/admin_departments

/obj/machinery/photocopier/faxmachine/Initialize()
	. = ..()

	department = get_area_name(src)

	if(!admin_departments)
		admin_departments = list("Central Command", "Centcomm Bureau of Bureaucracy", "Centcomm Supply", "Central Command Internal Affairs")
	GLOB.all_faxes += src
	if(!destination)
		destination = "Central Command"
	if( !(("[department]" in GLOB.all_departments) || ("[department]" in admin_departments)))
		GLOB.all_departments |= department

/obj/machinery/photocopier/faxmachine/do_insertion(obj/item/O, mob/user)
	O.loc = src
	to_chat(user, "<span class ='notice'>You insert [O] into [src].</span>")
	updateUsrDialog()

/obj/machinery/photocopier/faxmachine/attack_hand(mob/user as mob)
	user.set_machine(src)

	var/dat = "Fax Machine<BR>"

	var/scan_name
	if(scan)
		scan_name = scan.name
	else
		scan_name = "--------"

	dat += "Confirm Identity: <a href='byond://?src=\ref[src];scan=1'>[scan_name]</a><br>"

	if(authenticated)
		dat += "<a href='byond://?src=\ref[src];logout=1'>{Log Out}</a>"
	else
		dat += "<a href='byond://?src=\ref[src];auth=1'>{Log In}</a>"

	dat += "<hr>"

	if(authenticated)
		dat += "<b>Logged in to:</b> Central Command Quantum Entanglement Network<br><br>"

		if(copy)
			dat += "<a href='byond://?src=\ref[src];remove=1'>Remove Item</a><br><br>"

			if(sendcooldown)
				dat += "<b>Transmitter arrays realigning. Please stand by.</b><br>"

			else

				dat += "<a href='byond://?src=\ref[src];send=1'>Send</a><br>"
				dat += "<b>Currently sending:</b> [copy.name]<br>"
				dat += "<b>Sending to:</b> <a href='byond://?src=\ref[src];dept=1'>[destination]</a><br>"

		else
			if(sendcooldown)
				dat += "Please insert paper to send via secure connection.<br><br>"
				dat += "<b>Transmitter arrays realigning. Please stand by.</b><br>"
			else
				dat += "Please insert paper to send via secure connection.<br><br>"

	else
		dat += "Proper authentication is required to use this device.<br><br>"

		if(copy)
			dat += "<a href ='byond://?src=\ref[src];remove=1'>Remove Item</a><br>"

	user << browse(dat, "window=copier")
	onclose(user, "copier")
	return

/obj/machinery/photocopier/faxmachine/Topic(href, href_list)
	if(href_list["send"] && copy)
		if (destination in admin_departments)
			send_admin_fax(usr, destination)
		else
			sendfax(destination)

		if (sendcooldown)
			spawn(sendcooldown) // cooldown time
				sendcooldown = 0
				updateUsrDialog()

	else if(href_list["remove"] && copy)
		copy.loc = usr.loc
		usr.put_in_hands(copy)
		to_chat(usr, "<span class='notice'>You take \the [copy] out of \the [src].</span>")
		copy = null
		updateUsrDialog()

	if(href_list["scan"])
		if (scan)
			if(ishuman(usr))
				scan.loc = usr.loc
				if(!usr.get_empty_held_indexes())
					usr.put_in_hands(scan)
				scan = null
			else
				scan.loc = src.loc
				scan = null
		else
			var/obj/item/I = usr.get_active_held_item()
			if (istype(I, /obj/item/weapon/card/id))
				if(!usr.drop_item())
					return
				I.loc = src
				scan = I
		authenticated = 0

	if(href_list["dept"])
		var/lastdestination = destination
		destination = input(usr, "Which department?", "Choose a department", "") as null|anything in (GLOB.all_departments + admin_departments)
		if(!destination)
			destination = lastdestination

	if(href_list["auth"])
		if(!authenticated && scan && check_access(scan))
			authenticated = 1

	if(href_list["logout"])
		authenticated = 0

	updateUsrDialog()

/obj/machinery/photocopier/faxmachine/proc/sendfax(var/destination)
	if(stat & (BROKEN|NOPOWER))
		return

	use_power(200)

	var/success = 0
	for(var/thing in GLOB.all_faxes)
		var/obj/machinery/photocopier/faxmachine/F = thing
		if(F.department == destination)
			success = F.recievefax(copy)

	if (success)
		visible_message("[src] beeps, \"Message transmitted successfully.\"")
		flick("faxsend", src)
		sendcooldown = 600 //1 minute. Sending to other fax machines on the ship is fast.
	else
		visible_message("[src] beeps, \"Error transmitting message.\"")

/obj/machinery/photocopier/faxmachine/proc/recievefax(var/obj/item/incoming)
	if(stat & (BROKEN|NOPOWER))
		return 0

	if(department == "Unknown")
		return 0	//You can't send faxes to "Unknown"

	flick("faxreceive", src)
	playsound(loc, "sound/machines/dotprinter.ogg", 50, 1)

	// give the sprite some time to flick
	sleep(20)

	if (istype(incoming, /obj/item/weapon/paper))
		copy(incoming)
	else if (istype(incoming, /obj/item/weapon/photo))
		photocopy(incoming)
	else
		return 0

	use_power(active_power_usage)
	return 1

/obj/machinery/photocopier/faxmachine/proc/send_admin_fax(var/mob/sender, var/destination)
	if(stat & (BROKEN|NOPOWER))
		return

	use_power(200)

	//recieved copies should not use toner since it's being used by admins only.
	var/obj/item/rcvdcopy
	if (istype(copy, /obj/item/weapon/paper))
		rcvdcopy = copy(copy, 0)
	else if (istype(copy, /obj/item/weapon/photo))
		rcvdcopy = photocopy(copy, 0)
	else
		visible_message("[src] beeps, \"Error transmitting message.\"")
		return

	rcvdcopy.loc = null //hopefully this shouldn't cause trouble
	GLOB.admin_faxes += rcvdcopy

	//message badmins that a fax has arrived
	if (destination == "Central Command")
		message_admins(sender, "[uppertext(destination)] FAX", rcvdcopy, destination, "#006100")
	else if (destination == "Centcomm Bureau of Bureaucracy")
		message_admins(sender, "[uppertext(destination)] FAX", rcvdcopy, destination, "#1F66A0")
	else if (destination == "Centcomm Supply")
		message_admins(sender, "[uppertext(destination)] FAX", rcvdcopy, destination, "#5F4519")
	else if (destination == "Central Command Internal Affairs")
		message_admins(sender, "[uppertext(destination)] FAX", rcvdcopy, destination, "#510B74")
	else
		message_admins(sender, "[uppertext(destination)] FAX", rcvdcopy, "UNKNOWN")

	sendcooldown = 1800 //3 minutes. Sending to centcomm is slow
	visible_message("[src] beeps, \"Message transmitted successfully.\"")

/obj/machinery/photocopier/faxmachine/proc/message_admins(var/mob/sender, var/faxname, var/obj/item/sent, var/reply_type, font_colour="#006100")
	var/msg = "<span class='notice'><b><font color='[font_colour]'>[faxname]: </font>[key_name(sender)]"
	msg += "(<A HREF='?_src_=holder;take_ic=\ref[sender]'>TAKE</a>) (<a href='?_src_=holder;FaxReply=\ref[sender];originfax=\ref[src];replyorigin=[reply_type]'>REPLY</a>)</b>: "
	msg += "Receiving '[sent.name]' via secure connection ... <a href='?_src_=holder;AdminFaxView=\ref[sent]'>view message</a></span>"

	for(var/client/C in GLOB.admins)
		if(check_rights((R_ADMIN),0,C))
			to_chat(C, msg)
			C << 'sound/machines/dotprinter.ogg'
