/obj/machinery/computer/ftl_weapons
	name = "Ship Tactical Console"
	var/list/kinetic_weapons = list()
	var/list/laser_weapons = list()
	var/obj/item/device/assembly/control/massdriver/controller
	var/obj/machinery/computer/ftl_scanner/linked_scanner
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "security_key"
	icon_screen = "tactical"

/obj/machinery/computer/ftl_weapons/New()
	..()
	controller = new(src)
	spawn(5)
		refresh_weapons()
		for(var/obj/machinery/computer/C in area_contents(src.loc.loc))
			if(istype(C,/obj/machinery/computer/ftl_scanner))
				linked_scanner = C
				break

/obj/machinery/computer/ftl_weapons/proc/refresh_weapons()
	kinetic_weapons = list()
	for(var/obj/machinery/mass_driver/K in world)
		if(!istype(get_area(K), /area/shuttle/ftl))
			continue
		if(copytext(K.id, 1, 7) == "weapon")
			kinetic_weapons += K
	laser_weapons = list()
	for(var/obj/machinery/power/shipweapon/L in world)
		if(!istype(get_area(L), /area/shuttle/ftl))
			continue
		laser_weapons += L

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

		kinetics_list[++kinetics_list.len] = kinetic_list
	var/list/lasers_list = list()
	data["laser_weapons"] = lasers_list
	for(var/obj/machinery/power/shipweapon/L in laser_weapons)
		var/list/laser_list = list()

		laser_list["name"] = "[L]"
		laser_list["id"] = "\ref[L]"
		laser_list["can_fire"] = L.can_fire()
		if(L.cell)
			laser_list["charge"] = L.cell.charge
			laser_list["maxcharge"] = L.cell.maxcharge
		else
			laser_list["charge"] = 0
			laser_list["maxcharge"] = 1

		lasers_list[++lasers_list.len] = laser_list

	return data

/obj/machinery/computer/ftl_weapons/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("refresh")
			refresh_weapons()
			. = 1
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
				if(linked_scanner.target)
					spawn(60) SSship.damage_ship(linked_scanner.target,5) // abstracted at this point. Eventually will be calculated when the projectile leaves the Z-level
				else
					SSship.broadcast_message("No ship targetted! Shot missed!",SSship.error_sound)

			. = 1
		if("fire_laser")
			var/obj/machinery/power/shipweapon/L = locate(params["id"])
			if(!istype(L))
				return
			if(!(L in laser_weapons))
				return
			if(L.attempt_fire())
				if(linked_scanner.target)
					spawn(40) SSship.damage_ship(linked_scanner.target,1) // abstracted at this point. Eventually will be calculated when the projectile leaves the Z-level
				else
					SSship.broadcast_message("No ship targetted! Shot missed!",SSship.error_sound)

			. = 1

