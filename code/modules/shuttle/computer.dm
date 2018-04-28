/obj/machinery/computer/shuttle
	name = "shuttle console"
	icon_screen = "shuttle"
	icon_keyboard = "tech_key"
	light_color = LIGHT_COLOR_CYAN
	req_access = list( )
	circuit = /obj/item/weapon/circuitboard/computer/shuttle
	var/shuttleId
	var/possible_destinations = ""
	var/admin_controlled
	var/no_destination_swap = 0
	var/can_move_if_ship_moving = TRUE //Can the shuttle move if the main ship is in transit

/obj/machinery/computer/shuttle/Initialize(mapload, obj/item/weapon/circuitboard/computer/shuttle/C)
	. = ..()
	if(istype(C))
		possible_destinations = C.possible_destinations
		shuttleId = C.shuttleId

/obj/machinery/computer/shuttle/attack_hand(mob/user)
	if(..(user))
		return
	src.add_fingerprint(usr)

	var/list/options = params2list(possible_destinations)
	var/obj/docking_port/mobile/M = SSshuttle.getShuttle(shuttleId)
	var/dat = "Status: [M ? M.getStatusText() : "*Missing*"]<br><br>"
	if(!M)
		WARNING("A shuttle computer is missing a mobile dock.")
	if(M.mode == SHUTTLE_TRANSIT || (!can_move_if_ship_moving && (SSstarmap.in_transit || SSstarmap.in_transit_planet)))
		dat += "<B>The [can_move_if_ship_moving ? "main ship" : "shuttle"] is currently in transit.</B><br>"
	else
		var/destination_found
		for(var/obj/docking_port/stationary/S in SSshuttle.stationary)
			if(!options.Find(S.id))
				continue
			if(!M.check_dock(S))
				continue
			if(M.id == "fob" && M.getDockedId() != "fob_dock" && S.id != "fob_dock") //If the FOB isn't at the main ship, the main ship is its only potential destination.
				continue
			if(M.id == "fob" && !(S.z == ZLEVEL_STATION || (S.z in SSstarmap.current_planet.z_levels))) //Check the z to prevent rare shenanigans
				continue
			destination_found = 1
			dat += "<A href='?src=\ref[src];move=[S.id]'>Send to [S.name]</A><br>"
		if(!destination_found)
			dat += "<B>Shuttle Locked</B><br>"
			if(!admin_controlled)
				dat += "No destination found<br>"
			if(admin_controlled)
				dat += "Authorized personnel only<br>"
				dat += "<A href='?src=\ref[src];request=1]'>Request Authorization</A><br>"
	dat += "<a href='?src=\ref[user];mach_close=computer'>Close</a>"

	var/datum/browser/popup = new(user, "computer", M ? M.name : "shuttle", 300, 200)
	popup.set_content("<center>[dat]</center>")
	popup.set_title_image(usr.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()

/obj/machinery/computer/shuttle/Topic(href, href_list)
	if(..())
		return
	if((!can_move_if_ship_moving && (SSstarmap.in_transit || SSstarmap.in_transit_planet)) || SSstarmap.ftl_is_spooling)
		to_chat(usr, "<span class='danger'>Unstable bluespace tether. Wait for FTL to end before moving.</span>")
		updateUsrDialog()
		return
	usr.set_machine(src)
	src.add_fingerprint(usr)
	if(!allowed(usr))
		to_chat(usr, "<span class='danger'>Access denied.</span>")
		return
	if(href_list["move"])
		var/obj/docking_port/mobile/M = SSshuttle.getShuttle(shuttleId)
		if(M.launch_status == ENDGAME_LAUNCHED)
			to_chat(usr, "<span class='warning'>You've already escaped. Never going back to that place again!</span>")
			return
		if(no_destination_swap)
			if(M.mode != SHUTTLE_IDLE)
				to_chat(usr, "<span class='warning'>Shuttle already in transit.</span>")
				updateUsrDialog()
				return
		switch(SSshuttle.moveShuttle(shuttleId, href_list["move"], 1))
			if(0)
				say("Shuttle departing. Please stand away from the doors.")
			if(1)
				to_chat(usr, "<span class='warning'>Invalid shuttle requested.</span>")
			else
				to_chat(usr, "<span class='notice'>Unable to comply.</span>")
	if(href_list["scan"])
		if(!SSstarmap.planet_loaded)
			say("Scanning. Please wait...")
			log_world("Planet surface loading was started by [key_name_admin(usr)]")
			SSstarmap.is_loading = FTL_LOADING_PLANET //Double setting, but allows the console to update to loading
			updateUsrDialog()
			SSmapping.load_planet(SSstarmap.current_planet,0,1) //Load current planet, don't unload and l o a d planet surface
	updateUsrDialog()

/obj/machinery/computer/shuttle/emag_act(mob/user)
	if(emagged)
		return
	req_access = null
	emagged = TRUE
	to_chat(user, "<span class='notice'>You fried the consoles ID checking system.</span>")
