/obj/machinery/computer/ftl_drones
	name = "Drone Control Computer"
	var/list/drone_stations = list()
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "atmos_key"
	icon_screen = "drones"

/obj/machinery/computer/ftl_drones/New()
	..()
	spawn(5)
		refresh_drones()

/obj/machinery/computer/ftl_drones/proc/refresh_drones()
	drone_stations = list()
	for(var/obj/machinery/drone_station/D in world)
		if(!istype(get_area(D), /area/shuttle/ftl))
			continue
		drone_stations += D

/obj/machinery/computer/ftl_drones/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, datum/tgui/master_ui = null, datum/ui_state/state = default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "ftl_drones", name, 800, 660, master_ui, state)
		ui.open()

/obj/machinery/computer/ftl_drones/ui_data(mob/user)
	var/list/data = list()
	var/list/drone_stations_list = list()
	data["drone_stations"] = drone_stations_list
	for(var/obj/machinery/drone_station/D in drone_stations)
		var/list/drone_station_list = list()
		drone_station_list["station_name"] = "[D]"
		drone_station_list["station_id"] = "\ref[D]"

		var/list/drones_list = list()
		data["drones"] = drones_list
		for(var/obj/machinery/drone/AD in D.loc)
			if(D.occupied())
				drone_station_list["dock_name"] = "[AD.name]"
				drone_station_list["dock_id"] = "\ref[AD]"
				drone_station_list["dock_deployed"] = AD.deployed
				drone_station_list["dock_max_health"] = AD.health_max
				drone_station_list["dock_health_current"] = AD.health_current
				drone_station_list["dock_max_ammo"] = AD.ammo_max
				drone_station_list["dock_ammo"] = AD.ammo_remaining
		for(var/obj/machinery/drone/DD in D.current_drones)
			if(D.current_drones.len)
				var/list/drone_list = list()
				drone_list["drone_name"] = "[DD.name]"
				drone_list["id"] = "\ref[DD]"
				drone_list["max_health"] = DD.health_max
				drone_list["health_current"] = DD.health_current
				drone_list["max_ammo"] = DD.ammo_max
				drone_list["ammo"] = DD.ammo_remaining
				drones_list[++drones_list.len] = drone_list

		drone_stations_list[++drone_stations_list.len] = drone_station_list
	return data
/obj/machinery/computer/ftl_drones/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("refresh")
			refresh_drones()
			. = 1
		if("deploy")
			if(processing)
				return
			processing = 1
			var/obj/machinery/drone_station/D = locate(params["station_id"])
			var/obj/machinery/drone/DD = locate(params["dock_id"])
			if(!istype(D) || !istype(DD))
				return
			if(!(D in drone_stations))
				return
			if(D.current_drones.len == 3)
				status_update("[D.name] can't maintain more than 3 drones!")
				return
			if(D.occupied())
				status_update("Deploying [DD.name]...")
				D.handle_deployment(DD)
				status_update("[DD.name] deployed!")
				refresh_drones()
			processing = 0
			. = 1
		if("return")
			if(processing)
				return
			processing = 1
			var/obj/machinery/drone_station/D = locate(params["station_id"])
			var/obj/machinery/drone/DD = locate(params["id"])
			if(!istype(D) || !istype(DD))
				return
			if(!(D in drone_stations))
				return
			if(!D.occupied())
				status_update("Retrieving [DD.name]...")
				D.handle_deployment(DD)
				status_update("[DD.name] returned to dock!")
				refresh_drones()
			else
				status_update("[D.name] was already occupied!")
			processing = 0
			. = 1