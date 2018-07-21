obj/item/weapon/circuitboard/computer/shuttle/advanced
	name = "Advanced Shuttle - FOB (Computer Board)"
	build_path = /obj/machinery/computer/shuttle/advanced
	shuttleId = "fob"

obj/item/weapon/circuitboard/computer/shuttle/advanced/cargo
	name = "Advanced Shuttle - Cargo (Computer Board)"
	build_path = /obj/machinery/computer/shuttle/advanced/cargo
	shuttleId = "cargo"

obj/item/weapon/circuitboard/computer/shuttle/advanced/attackby(obj/item/I, mob/user, params)
	var/obj/item/weapon/circuitboard/computer/shuttle/advanced/fob_shuttle = /obj/item/weapon/circuitboard/computer/shuttle/advanced
	var/obj/item/weapon/circuitboard/computer/shuttle/advanced/cargo_shuttle = /obj/item/weapon/circuitboard/computer/shuttle/advanced/cargo
	var/obj/item/weapon/circuitboard/computer/shuttle/advanced/newtype

	if(istype(I, /obj/item/weapon/screwdriver))
		var/new_setting = "FOB"
		playsound(src.loc, I.usesound, 50, 1)
		if(build_path == initial(fob_shuttle.build_path))
			newtype = cargo_shuttle
			new_setting = "Cargo"
		else
			newtype = fob_shuttle
		name = initial(newtype.name)
		build_path = initial(newtype.build_path)
		to_chat(user, "<span class='notice'>You change the circuitboard setting to \"[new_setting]\".</span>")
	else
		return ..()

/obj/machinery/computer/shuttle/advanced //rename
	name = "Advanced shuttle console (FOB)"
	desc = "Used to control the FOB shuttle."
	circuit = /obj/item/weapon/circuitboard/computer/shuttle/advanced
	shuttleId = "fob"
	no_destination_swap = 1
	can_move_if_ship_moving = FALSE

/obj/machinery/computer/shuttle/advanced/cargo
	name = "Advanced shuttle console (Cargo)"
	desc = "Used to control the Cargo shuttle."
	circuit = /obj/item/weapon/circuitboard/computer/shuttle/advanced/cargo
	shuttleId = "cargo"


/obj/machinery/computer/shuttle/advanced/attack_hand(mob/user)
	if(..(user))
		return
	src.add_fingerprint(usr)

	var/obj/docking_port/mobile/fob/M = SSshuttle.getShuttle(shuttleId)
	var/obj/docking_port/stationary/fob/D = M.get_docked()
	var/dat = "Status: [M ? M.getStatusText() : "*Missing*"]<br><br>"
	if(!M)
		WARNING("A shuttle computer is missing a mobile dock.")
	if(M.mode == SHUTTLE_TRANSIT || (!can_move_if_ship_moving && (SSstarmap.in_transit || SSstarmap.in_transit_planet)))
		dat += "<B>The [can_move_if_ship_moving ? "main ship" : "shuttle"] is currently in transit.</B><br>"
	else //Main content
		if(admin_controlled)
			dat += "Authorized personnel only<br>"
			dat += "<A href='?src=\ref[src];request=1]'>Request Authorization</A><hr>"
		else if(SSstarmap.ftl_is_spooling) //Don't let them do anything if we are starting FTL
			dat += "<b>Unstable bluespace tether detected!</b><br>Flight controls disabled during FTL spoolup.<hr><hr>"
		else
			if(D.current_planet == SSstarmap.current_planet || istype(D,/obj/docking_port/stationary/fob/fob_dock)) //The shuttle is in the same planet as the ship or ar they docked at the main ship
				if(M.id == "fob") //Only the FOB can scan
					switch(SSstarmap.planet_loaded)
						if(FALSE)
							dat += "<A href='?src=\ref[src];scan=[1]'>Scan [SSstarmap.current_planet] for viable landing sites</A><hr><hr>"
						if(PLANET_LOADING)
							dat += "<b>Currently searching for viable landing site</b><hr><hr>"
						if(PLANET_IS_A_GAS_GIANT)
							dat += "<i>Error:</i> Planet surface unsuitable for landing.<br><i>Reason:</i> Non-solid landing surface detected<hr><hr>"
						if(PLANET_LOADED)
							dat += "Viable landing site found. Autopilot ready to engage.<hr><hr>"



				for(var/obj/docking_port/stationary/fob/S in SSshuttle.stationary) //Begin loading docks
					if(S.dock_do_not_show || (S.current_planet != SSstarmap.current_planet && !istype(S,/obj/docking_port/stationary/fob/fob_dock))) //Ignore hidden ones, and ones at different planets UNLESS it is the main dock
						continue
					else
						if(S.allowed_shuttles & M.allowed_docks)//Can we even dock with this port?
							if(S.dock_distance < M.max_distance) //Are we the cargo shuttle, and unable to land at the planet?
								switch(M.canDock(S))
									if(SHUTTLE_CAN_DOCK)
										dat += "<A href='?src=\ref[src];move=[S.id]'>Send to [S.name]</A><hr>"
									if(SHUTTLE_NOT_A_DOCKING_PORT)
										dat += "MAJOR ERROR - Please report to Centcomm.<hr>"
									if(SHUTTLE_ALREADY_DOCKED)
										dat += "You are currently docked at [S.name].<hr>"
									if(SHUTTLE_SOMEONE_ELSE_DOCKED)
										dat += "[S.name] is currently in use by [S.getDockedId()]<hr>"
									else
										if(SSstarmap.planet_loaded == PLANET_LOADING) //Docks on planets are not ready for the crew to dock, so throw this safe error message
											dat += "The flight path to [S.name] is still being plotted. Please wait.<hr>"
										else
											dat += "The shuttle is too large to dock at [S.name].<hr>"
							else
								dat += "Unable to land at [S.name] due to no landing thrusters.<hr>"
						// else
						// 	dat += "[S.name] is not compatible with this shuttle<hr>" //Turning this off since half of the docks are now invalid

			else //the ship is at a different planet.
				dat += "Orbited body outside of range of main ship's sensors. Planet scanning unavailable.<hr><hr>"
				for(var/obj/docking_port/stationary/fob/S in SSshuttle.stationary) //Begin loading docks
					if(S.dock_do_not_show)
						continue
					else
						if(S.allowed_shuttles & M.allowed_docks && (D.current_planet == S.current_planet || istype(S,/obj/docking_port/stationary/fob/fob_dock)))//Can we even dock with this port? And is it in the same system/FOB dock?
							if(S.dock_distance < M.max_distance) //Are we the cargo shuttle, and unable to land at the planet?
								switch(M.canDock(S))
									if(SHUTTLE_CAN_DOCK)
										dat += "<A href='?src=\ref[src];move=[S.id]'>Send to [S.name]</A><hr>"
									if(SHUTTLE_NOT_A_DOCKING_PORT)
										dat += "MAJOR ERROR - Please report to Centcomm.<hr>"
									if(SHUTTLE_ALREADY_DOCKED)
										dat += "You are currently docked at [S.name].<hr>"
									if(SHUTTLE_SOMEONE_ELSE_DOCKED)
										dat += "[S.name] is currently in use by [S.getDockedId()]<hr>"
									else
										if(SSstarmap.planet_loaded == PLANET_LOADING) //Docks on planets are not ready for the crew to dock, so throw this safe error message
											dat += "The flight path to [S.name] is still being plotted. Please wait.<hr>"
										else
											dat += "The shuttle is too large to dock at [S.name].<hr>"
							else
								dat += "Unable to land at [S.name] due to no landing thrusters.<hr>"
						// else
						// 	dat += "[S.name] is not compatible with this shuttle<hr>" //Turning this off since half of the docks are now invalid


	dat += "<a href='?src=\ref[user];mach_close=computer'>Close</a>"

	var/datum/browser/popup = new(user, "computer", M ? M.name : "shuttle", 500, 500)
	popup.set_content("<center>[dat]</center>")
	popup.set_title_image(usr.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()
