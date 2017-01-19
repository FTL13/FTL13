/obj/machinery/computer/ftl_drones
	name = "Drone Control Computer"
	var/list/drones = list()
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "atmos_key"
	icon_screen = "drones"

/obj/machinery/computer/ftl_drones/New()
	..()
	spawn(5)
		refresh_drones()

/obj/machinery/computer/ftl_drones/proc/refresh_drones()
	drones = list()
	for(var/obj/machinery/drone_station/D in world)
		for(var/obj/machinery/drone/DD in D.loc)
			if(copytext(DD.id, 1, 5) == "drone")
				drones += DD

/obj/machinery/computer/ftl_drones/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, datum/tgui/master_ui = null, datum/ui_state/state = default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "ftl_drones", name, 800, 660, master_ui, state)
		ui.open()

/obj/machinery/computer/ftl_drones/ui_data(mob/user)
	var/list/data = list()
	var/list/drone_list = list()
	data["drones"] = drone_list
	for(var/obj/machinery/drone/DD in drones)
		var/list/drones_list = list()
		drones_list["drone_name"] = "[DD]"
		drones_list["id"] = "\ref[DD]"
		drones_list["max_ammo"] = DD.ammo_max
		drones_list["ammo"] = DD.ammo_remaining
		drones_list["on_orbit"] = DD.is_orbiting
		drones[++drones.len] = drone_list

		drone_list[++drone_list.len] = drones_list

/obj/machinery/computer/ftl_drones/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("refresh")
			refresh_drones()
			. = 1
		if("deploy")
			for(var/obj/machinery/drone_station/D in world)
				var/obj/machinery/drone/DD = locate(params["id"])
				if(!istype(D) || !istype(DD))
					return
				if(!(DD in drones))
					return
				if(copytext(DD.id, 1, 5) != "drone")
					drones -= DD
				if(D.occupied() || !DD.is_orbiting)
					status_update("Deploying [DD.name]...")
					D.deploy(DD)
					status_update("[DD.name] deployed!")
			. = 1
		if("return")
			for(var/obj/machinery/drone_station/D in world)
				var/obj/machinery/drone/DD = locate(params["id"])
				if(!istype(D) || !istype(DD))
					return
				if(!(DD in drones))
					return
				if(copytext(DD.id, 1, 5) != "drone")
					drones -= DD
				if(D.occupied())
					if(!DD.is_orbiting)
						status_update("Retrieving [DD.name] to ship failed! Drone station alread occupied!")
						return
					status_update("Returning [DD.name]...")
					D.return_pls(DD)
					status_update("[DD.name] returned!")
			. = 1
