/obj/machinery/computer/shuttle/advanced //rename
	name = "shuttle console"
	desc = "Used to control the White Ship."
	circuit = /obj/item/weapon/circuitboard/computer/shuttle
	shuttleId = "fob"

	/obj/machinery/computer/shuttle/advanced/attack_hand(mob/user)
		if(..(user))
			return
		src.add_fingerprint(usr)

		var/obj/docking_port/mobile/M = SSshuttle.getShuttle(shuttleId)
		var/dat = "Status: [M ? M.getStatusText() : "*Missing*"]<br><br>"
		if(!M)
			WARNING("A shuttle computer is missing a mobile dock.")
		if(M.mode == SHUTTLE_TRANSIT || (!can_move_if_ship_moving && (SSstarmap.in_transit || SSstarmap.in_transit_planet)))
			dat += "<B>The [can_move_if_ship_moving ? "main ship" : "shuttle"] is currently in transit.</B><br>"
		else //Main content
			switch(SSstarmap.planet_loaded)
				if(FALSE)
					dat += "<A href='?src=\ref[src];scan=[1]'>Scan [SSstarmap.current_planet] for viable landing sites</A><hr>"
				if(PLANET_LOADING)
					dat += "<b>Currently searching for viable landing site</b><hr>"
				if(PLANET_IS_A_GAS_GIANT)
					dat += "<i>Error:</i> Planet surface unsuitable for landing.<br><i>Reason:</i> Non-solid landing surface detected<hr>"

			for(var/obj/docking_port/stationary/S in SSshuttle.stationary) //Begin loading docks
				if(S.dock_do_not_show)
					continue
				if(admin_controlled)
					dat += "Authorized personnel only<br>"
					dat += "<A href='?src=\ref[src];request=1]'>Request Authorization</A><hr>"
				else
					if(S.allowed_shuttles & M.allowed_docks)//Can we even dock with this port?
						switch(M.canDock(S))
							if(SHUTTLE_CAN_DOCK)
								dat += "<A href='?src=\ref[src];move=[S.id]'>Send to [S.name]</A><hr>"
							if(SHUTTLE_NOT_A_DOCKING_PORT)
								dat += "MAJOR ERROR - Please report to Centcom.<hr>"
							if(SHUTTLE_ALREADY_DOCKED)
								dat += "You are currently docked at [S.name]t.<hr>"
							if(SHUTTLE_SOMEONE_ELSE_DOCKED)
								dat += "[S.name] is currently in use by [S.getDockedId()]<hr>"
							else
								dat += "The shuttle is too large for that docking port.<hr>"
					else
						dat += "[S.name] is not compatible with this shuttle<hr>"
				/*
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
					dat += "<A href='?src=\ref[src];request=1]'>Request Authorization</A><br>"*/
		dat += "<a href='?src=\ref[user];mach_close=computer'>Close</a>"

		var/datum/browser/popup = new(user, "computer", M ? M.name : "shuttle", 300, 200)
		popup.set_content("<center>[dat]</center>")
		popup.set_title_image(usr.browse_rsc_icon(src.icon, src.icon_state))
		popup.open()
