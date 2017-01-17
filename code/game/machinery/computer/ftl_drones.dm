/obj/machinery/computer/ftl_drones
	name = "Drone Control Computer"
	var/list/drones = list()
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "security_key"
	icon_screen = "drones"

/obj/machinery/computer/ftl_drones/New()
	..()
	spawn(5)
		refresh_drones()

/obj/machinery/computer/ftl_drones/proc/refresh_drones()
	drones = list()
	for(var/obj/machinery/drone_station/D in world)
		if(!istype(get_area(D), /area/shuttle/ftl))
			continue
		if(copytext(D.id, 1, 5) == "drone")
			drones += D

/obj/machinery/computer/ftl_drones/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, datum/tgui/master_ui = null, datum/ui_state/state = default_state)

	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "ftl_drones", name, 800, 660, master_ui, state)
		ui.open()

/obj/machinery/computer/ftl_drones/ui_data(mob/user)
	var/list/data = list()

	var/list/drones_list = list()
	data["drones"] = drones_list
	for(var/obj/machinery/drone_station/D in drones)
		var/list/drone_list = list()
    drone_list["isdrone"] = D.occupied()
    drone_list["station_id"] = "\ref[D]"
    if(D.occupied())
      for(var/obj/structure/drone/DD in D.loc)
		    drone_list["drone_name"] = "[DD]"
		    drone_list["id"] = "\ref[DD]"
        drone_list["max_ammo"] = DD.ammo_max
		    drone_list["ammo"] = DD.ammo_remaining
		    drone_list["on_orbit"] = DD.orbiting(FALSE)

		drones_list[++drones_list.len] = drone_list

/obj/machinery/computer/ftl_drones/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("refresh")
			refresh_drones()
			. = 1
		if("deploy")
			var/obj/machinery/drone_station/D = locate(params["station_id"])
      var/obj/structure/drone/DD = locate(params["id"])
			if(!istype(D))
				return
			if(!(D in drones))
				return
			if(copytext(D.id, 1, 5) != "drone")
				drones -= D
			if(D.occupied())
        status_update('Deploying [DD.name]...')
				D.deploy(DD)
        status_update('[DD.name] deployed!')
			. = 1
    if("return")
      var/obj/machinery/drone_station/D = locate(params["station_id"])
      var/obj/structure/drone/DD = locate(params["id"])
      if(!istype(D))
        return
      if(!(D in drones))
        return
      if(copytext(D.id, 1, 5) != "drone")
        drones -= D
      if(D.occupied())
        for(var/obj/structure/drone/DDs in D.loc)
          if(!DDs.orbiting)
            status_update('Retrieving [DD.name] to ship failed! Drone station alread occupied!')
            return
        status_update('Returning [DD.name]...')
        D.returtn(DD)
        status_update('[DD.name] returned!')
      . = 1
