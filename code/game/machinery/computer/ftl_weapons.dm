/obj/machinery/computer/ftl_weapons
	name = "Ship Tactical Console"
	var/list/kinetic_weapons = list()
	var/list/laser_weapons = list()
	var/obj/item/device/assembly/control/massdriver/controller

/obj/machinery/computer/ftl_weapons/New()
	..()
	controller = new(src)
	spawn(5)
		refresh_weapons()

/obj/machinery/computer/ftl_weapons/proc/refresh_weapons()
	kinetic_weapons = list()
	for(var/obj/machinery/mass_driver/K in world)
		if(copytext(K.id, 1, 7) == "weapon")
			kinetic_weapons += K

/obj/machinery/computer/ftl_weapons/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, datum/tgui/master_ui = null, datum/ui_state/state = default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "ftl_weapons", name, 800, 660, master_ui, state)
		ui.open()

/obj/machinery/computer/ftl_weapons/ui_data(mob/user)
	var/list/data = list()
	
	var/list/kinetics_list = list()
	data["kinetic_weapons"] = kinetics_list
	for(var/obj/machinery/mass_driver/K in kinetic_weapons)
		var/list/kinetic_list = list()
		
		kinetic_list["name"] = "[K]"
		kinetic_list["id"] = "\ref[K]"
		var/is_loaded = 0
		var/loaded_name
		for(var/obj/O in K.loc)
			if(!O.anchored || istype(O, /obj/mecha))
				is_loaded = 1
				loaded_name = "[O]"
				break
		kinetic_list["loaded"] = loaded_name
		kinetic_list["can_fire"] = is_loaded
		
		kinetics_list[++kinetics_list.len] += kinetic_list
	
	return data

/obj/machinery/computer/ftl_weapons/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("refresh")
			refresh_weapons()
		if("fire_kinetic")
			var/obj/machinery/mass_driver/K = locate(params["id"])
			if(!istype(K))
				return
			if(!(K in kinetic_weapons))
				return
			if(copytext(K.id, 1, 7) != "weapon")
				kinetic_weapons -= K
				return
			controller.id = K.id
			if(!controller.cooldown)
				controller.activate()