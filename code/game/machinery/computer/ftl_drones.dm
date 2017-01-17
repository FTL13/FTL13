/obj/machinery/computer/ftl_drones
	name = "Drone control computer"
	var/list/defence_drones = list()
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "security_key"
	icon_screen = "drones"

/obj/machinery/computer/ftl_drones/New()
	..()
	ftl_drones_consoles += src
	spawn(5)
		refresh_drones()

/obj/machinery/computer/ftl_drones/Destroy()
	ftl_drones_consoles -= src
	. = ..()

/obj/machinery/computer/ftl_drones/proc/refresh_drones()
	defence_drones = list()
	for(var/obj/machinery/drone_station/defence/D in world)
		if(!istype(get_area(D), /area/shuttle/ftl))
			continue
		if(copytext(D.id, 1, 7) == "weapon")
			defence_drones += K

/obj/machinery/computer/ftl_drones/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, datum/tgui/master_ui = null, datum/ui_state/state = default_state)

	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "ftl_drones", name, 800, 660, master_ui, state)
		ui.open()

/obj/machinery/computer/ftl_drones/ui_data(mob/user)
	var/list/data = list()

	var/list/defdrones_list = list()
	data["defence_drones"] = defdrones_list
	for(var/obj/machinery/drone_station/defence/D in defence_drones)
		var/list/defdrone_list = list()
    if(D.occupied())
      for(var/obj/structure/drone/defence/DD in loc)
		    defdrone_list["name"] = "[DD]"
		    defdrone_list["id"] = "\ref[DD]"
		    defdrone_list["ammo"] = DD.ammo_remaining
		    defdrone_list["on_orbit"] = DD.orbiting(FALSE)

		defdrones_list[++defdrones_list.len] = defdrone_list

/obj/machinery/computer/ftl_drones/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("refresh")
			refresh_drones()
			. = 1
		if("deploy")
			var/obj/machinery/drone_station/defence/D = locate(params["id"])
			if(!istype(D))
				return
			if(!(D in defence_drones))
				return
			if(copytext(D.id, 1, 7) != "drone")
				defence_drones -= D
			if(D.occupied())
				D.deploy()
			else
				spawn(10)
					SSship.broadcast_message("Drone not found!",SSship.error_sound)
			. = 1
