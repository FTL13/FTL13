/obj/machinery/computer/ftl_weapons
	name = "Ship Tactical Console"
	var/list/kinetic_weapons = list()
	var/list/laser_weapons = list()
	var/obj/machinery/computer/ftl_scanner/linked_scanner
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "security_key"
	icon_screen = "tactical"

/obj/machinery/computer/ftl_weapons/New()
	..()
	spawn(5)
		refresh_weapons()
		for(var/obj/machinery/computer/C in area_contents(loc.loc))
			if(istype(C,/obj/machinery/computer/ftl_scanner))
				linked_scanner = C
				break

/obj/machinery/computer/ftl_weapons/proc/refresh_weapons()
	kinetic_weapons = list()
	for(var/obj/machinery/mac_barrel/K in world)
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
	for(var/obj/machinery/mac_barrel/K in kinetic_weapons)
		var/list/kinetic_list = list()

		kinetic_list["name"] = "[K]"
		kinetic_list["id"] = "\ref[K]"
		kinetic_list["loaded"] = K.breech.loaded_shell
		kinetic_list["can_fire"] = K.can_fire()

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

	if(SSstarmap.ftl_shieldgen)
		data["has_shield"] = 1
		if(SSstarmap.ftl_shieldgen.is_active())
			data["shield_status"] = "Fully charged, shields up"
			data["shield_class"] = "good"
		else if(SSstarmap.ftl_shieldgen.charging_power || SSstarmap.ftl_shieldgen.charging_plasma)
			data["shield_status"] = "Charging, shields down"
			data["shield_class"] = "average"
		else if(SSstarmap.ftl_shieldgen.stat & BROKEN)
			data["shield_status"] = "Broken"
			data["shield_class"] = "bad"
		else
			data["shield_status"] = "Not charging, shields down"
			data["shield_class"] = "bad"

		data["shield_plasma_charge"] = SSstarmap.ftl_shieldgen.plasma_charge
		data["shield_plasma_charge_max"] = SSstarmap.ftl_shieldgen.plasma_charge_max
		data["shield_charging_plasma"] = SSstarmap.ftl_shieldgen.charging_plasma
		data["shield_power_charge"] = SSstarmap.ftl_shieldgen.power_charge
		data["shield_power_charge_max"] = SSstarmap.ftl_shieldgen.power_charge_max
		data["shield_charging_power"] = SSstarmap.ftl_shieldgen.charging_power
		data["shield_on"] = SSstarmap.ftl_shieldgen.on
	else
		data["has_shield"] = 0
		data["shield_status"] = "Not found"
		data["shield_class"] = "bad"

	return data

/obj/machinery/computer/ftl_weapons/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("refresh")
			refresh_weapons()
			. = 1
		if("fire_kinetic")
			var/obj/machinery/mac_barrel/K = locate(params["id"])
			if(!istype(K))
				return
			if(!(K in kinetic_weapons))
				return
			if(copytext(K.id, 1, 7) != "weapon")
				kinetic_weapons -= K
			if(K.can_fire())
				K.attempt_fire(linked_scanner.target_component)
				if(!linked_scanner.target)
					SSship.broadcast_message("No ship targetted! Shot missed!",SSship.error_sound)

			. = 1
		if("fire_laser")
			var/obj/machinery/power/shipweapon/L = locate(params["id"])
			if(!istype(L))
				return
			if(!(L in laser_weapons))
				return
			if(L.attempt_fire(linked_scanner.target_component))
				if(!linked_scanner.target)
					SSship.broadcast_message("No ship targetted! Shot missed!",SSship.error_sound)

			. = 1
		if("toggle_shields")
			SSstarmap.ftl_shieldgen.on = !SSstarmap.ftl_shieldgen.on
			. = 1
