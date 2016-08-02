/obj/machinery/computer/power_management
	name = "power distribution computer"
	desc = "Used for distributing power across the ship, setting priority areas, and disabling power to those which aren't as important"
	req_access = list(access_engine)
	var/active = 0
	circuit = /obj/item/weapon/circuitboard/computer/power_management
	icon_keyboard = "tech_key"
	icon_screen = "ai-fixer"
	var/breakers
	var/cooldown = 0

/obj/machinery/computer/power_management/attackby(obj/I, mob/user, params)
	if(istype(I, /obj/item/weapon/screwdriver))
		if(stat & (NOPOWER|BROKEN))
			user << "<span class='warning'>The screws on [name]'s screen won't budge.</span>"
		else
			user << "<span class='warning'>The screws on [name]'s screen won't budge and it emits a warning beep.</span>"
	else
		return ..()

/obj/machinery/computer/power_management/attack_hand(mob/user)
	if(..())
		return
	interact(user)


/obj/machinery/computer/power_management/interact(mob/user)
	var/dat = ""


	dat += "<b>Connected breaker boxes:</b><HR>"
	dat += scan_breakers()
	if(scan_breakers() != null)
		dat += "<br><br><br>"

	dat += "<a href='byond://?src=\ref[src];refresh=1'>Refresh</a><br>"

	//user << browse(dat, "window=computer;size=400x500")
	//onclose(user, "computer")
	var/datum/browser/popup = new(user, "computer", "Power Distribution Computer", 600, 880)
	popup.set_content(dat)
	popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()
	return

/obj/machinery/computer/power_management/Topic(href, href_list)
	if(..())
		return

	if(href_list["refresh"])
		updateUsrDialog()

	if(href_list["toggle_power"])
		var/obj/machinery/power/breakerbox/BB = locate(href_list["toggle_power"])
		BB.remote_toggle()
		updateUsrDialog()
		spawn(100)
			updateUsrDialog()

	if(href_list["change_id"])
		var/obj/machinery/power/breakerbox/BB = locate(href_list["change_id"])
		var/cid = copytext(sanitize(input(usr, "Enter an ID for this breaker box:", "Change ID") as text),1,MAX_MESSAGE_LEN) //never trust the player
		if(cid)
			BB.id = cid
			BB.id_cooldown = 1
			updateUsrDialog()
			spawn(1800)
				BB.id_cooldown = 0

/obj/machinery/computer/power_management/proc/scan_breakers()
	var/data = ""

	for(var/obj/machinery/power/breakerbox/BB in world)
		if(BB.z != ZLEVEL_CENTCOM && (!SSstarmap.current_planet || BB.z != SSstarmap.current_planet.z_level)) //yes, stolen from comms console, fite me
			continue
		if(BB.x == 0 && BB.y == 0 && BB.z == 0) //adminbus
			continue
		data += "Breaker box [BB.id], located at [BB.x], [BB.y], [BB.z]; assigned to [BB.department].<br>"
		data += "The breaker box is currently [BB.status]"

		if(!BB.busy && !BB.update_locked)
			data += "<a href='byond://?src=\ref[src];toggle_power=\ref[BB]'>Toggle power</a><br>"
		else
			data += "<font color='maroon'>Breaker box is locked. Please wait.</font><br>"

		if(!BB.id_cooldown)
			data += "<a href='byond://?src=\ref[src];change_id=\ref[BB]'>Change ID</a><HR>"
		else
			data += "<font color='maroon'>ID cooldown active. Please wait.</font><HR>"

	return data
