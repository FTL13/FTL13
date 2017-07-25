//Adminpaper - it's like paper, but more adminny! Used for sending faxes.
/obj/item/weapon/paper/admin
	name = "administrative paper"
	desc = "If you see this, something has gone horribly wrong."
	var/datum/admins/admin_datum = null

	var/interactions = null
	//var/isCrayon = 0
	var/origin = null
	var/mob/sender = null
	var/obj/machinery/photocopier/faxmachine/destination

	var/header = null
	var/header_on = TRUE

	var/footer = null
	var/footer_on = TRUE

/obj/item/weapon/paper/admin/Initialize()
	. = ..()
	generate_interactions()


/obj/item/weapon/paper/admin/proc/generate_interactions()
	var/temp_interactions = null

	//Snapshot is crazy and likes putting each topic hyperlink on a seperate line from any other tags so it's nice and clean.
	temp_interactions += "<HR><center><font size= \"1\">The fax will transmit everything above this line</font><br>"
	temp_interactions += "<A href='?src=\ref[src];confirm=1'>Send fax</A> "
	temp_interactions += "<A href='?src=\ref[src];cancel=1'>Cancel fax</A> "
	temp_interactions += "<BR>"
	temp_interactions += "<A href='?src=\ref[src];toggleheader=1'>Toggle Header</A> "
	temp_interactions += "<A href='?src=\ref[src];togglefooter=1'>Toggle Footer</A> "
	temp_interactions += "<A href='?src=\ref[src];clear=1'>Clear page</A> "
	temp_interactions += "</center>"

	interactions = temp_interactions

/obj/item/weapon/paper/admin/proc/generate_header()
	var/originhash = md5("[origin]")
	var/challengehash = copytext(md5("[GLOB.round_id]"),1,10) // changed to a hash of the round ID so it's more consistant but changes every round.
	var/text = null
	text += "<b>[origin] Quantum Uplink Signed Message</b><br>"
	text += "<font size = \"1\">Encryption key: [originhash]<br>"
	text += "Challenge: [challengehash]<br></font></center><hr>"

	header = text

/obj/item/weapon/paper/admin/proc/generate_footer()
	var/text = null

	text = "<hr><font size= \"1\">"
	text += "This transmission is intended only for the addressee and may contain confidential information. Any unauthorized disclosure is strictly prohibited. <br><br>"
	text += "If this transmission is received in error, please notify both the sender and the office of Central Command Internal Affairs immediately so that corrective action may be taken."
	text += "Failure to comply is a breach of regulation and may be prosecuted to the fullest extent of the law, where applicable."
	text += "</font>"

	footer = text


/obj/item/weapon/paper/admin/proc/admin_browse()
	update_info_links()
	generate_header()
	generate_footer()
	update_display()

/obj/item/weapon/paper/admin/proc/update_display()
	usr << browse("<HTML><HEAD><TITLE>[name]</TITLE></HEAD><BODY>[header_on ? header : ""][info_links][stamps][footer_on ? footer : ""][interactions]</BODY></HTML>", "window=[name];can_close=0")

/obj/item/weapon/paper/admin/Topic(href, href_list)
	if(href_list["write"])
		var/id = href_list["write"]

		var/t = stripped_multiline_input("Enter what you want to write:", "Write", no_trim=TRUE)

		if(!t)
			return
		var/tparsed = parsepencode(t,,, 0) // Encode everything from pencode to html
		if(tparsed != null)	//No input from the user means nothing needs to be added
			if(id!="end")
				add_to_field(text2num(id), tparsed) // He wants to edit a field, let him.
			else
				info += tparsed // Oh, he wants to edit to the end of the file, let him.
				update_info_links()
			update_display()
			update_icon()

	if(href_list["confirm"])
		switch(alert("Are you sure you want to send the fax as is?",, "Yes", "No"))
			if("Yes")
				if(header_on)
					info = header + info
				if(footer_on)
					info += footer
				update_info_links()
				usr << browse(null, "window=[name]")
				admin_datum.faxCallback(src, destination)
		return

	if(href_list["cancel"])
		usr << browse(null, "window=[name]")
		qdel(src)
		return

	if(href_list["clear"])
		clearpaper()
		update_display()
		return

	if(href_list["toggleheader"])
		header_on = !header_on
		update_display()
		return

	if(href_list["togglefooter"])
		footer_on = !footer_on
		update_display()
		return

/obj/item/weapon/paper/admin/get_signature()
	return input(usr, "Enter the name you wish to sign the paper with (will prompt for multiple entries, in order of entry)", "Signature") as text|null
