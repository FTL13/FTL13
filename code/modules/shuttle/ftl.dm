/obj/docking_port/mobile/ftl
	name = "FTL Ship"
	id = "ftl"
	var/area_base_type = /area/shuttle/ftl

/obj/docking_port/mobile/ftl/New()
	. = ..()
	dir = SSmapping.config.ftl_ship_dir
	dwidth = SSmapping.config.ftl_ship_dwidth
	dheight = SSmapping.config.ftl_ship_dheight
	width = SSmapping.config.ftl_ship_width
	height = SSmapping.config.ftl_ship_height

/obj/docking_port/mobile/ftl/register()
	. = ..()
	SSshuttle.ftl = src

/obj/docking_port/mobile/ftl/proc/is_valid_area_for_shuttle(area/tileArea, area/thisArea)
	return istype(tileArea, area_base_type)

/obj/docking_port/stationary/ftl_encounter
	name = "FTL Encounter"
	var/encounter_type = ""
	
/obj/docking_port/stationary/ftl_encounter/New()
	. = ..()
	dir = SSmapping.config.ftl_ship_dir
	dwidth = SSmapping.config.ftl_ship_dwidth
	dheight = SSmapping.config.ftl_ship_dheight
	width = SSmapping.config.ftl_ship_width
	height = SSmapping.config.ftl_ship_height

/obj/machinery/computer/ftl_navigation
	name = "ship navigation console"
	desc = "Used to pilot the ship."
	var/screen = 0
	var/datum/star_system/selected_system
	var/datum/planet/selected_planet
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "teleport_key"
	icon_screen = "navigation"
	var/icon/planet_icon
	var/selecting_planet = 0
	var/do_send
	var/icon_view_counter = 0
	var/secondary = FALSE //For secondary Battle Bridge computers
	var/general_quarters = FALSE //Secondary computers only work during General Quarters


/obj/machinery/computer/ftl_navigation/New()
	..()
	if(secondary)
		name = "secondary navigation console"
		desc = "This is a backup navigation console. It will only work during General Quarters."
		icon = 'icons/obj/computerold.dmi' //old nasty sprite for a secondary computer
		icon_keyboard = "teleport_key" //so it fits the old sprite
		icon_screen = "navigation" //so it has a screen

	SSstarmap.ftl_consoles += src
	spawn(5)
		selected_system = SSstarmap.current_system
		screen = 1

/obj/machinery/computer/ftl_navigation/Destroy()
	SSstarmap.ftl_consoles -= src
	.=..()

/obj/machinery/computer/ftl_navigation/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	if(secondary && !general_quarters)
		user << "This console is locked. Backup consoles only work during General Quarters."
		return

	if(do_send && planet_icon)
		user << browse_rsc(planet_icon, "nav_planet_preview.png")
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		var/datum/asset/assets = get_asset_datum(/datum/asset/simple/nav)
		assets.send(user)

		if(!do_send && planet_icon)
			user << browse_rsc(planet_icon, "nav_planet_preview.png")

		ui = new(user, src, ui_key, "ftl_navigation", name, 800, 660, master_ui, state)
		ui.open()

/obj/machinery/computer/ftl_navigation/ui_data(mob/user)
	if((screen == 3 || screen == 4) && SSstarmap.in_transit)
		screen = 0
	var/list/data = list()
	data["screen"] = screen
	if(screen == 0)
		if(!SSstarmap.in_transit)
			data["in_transit"] = 0
			data["star_id"] = "\ref[SSstarmap.current_system]"
			data["star_name"] = SSstarmap.current_system.name
		else
			data["in_transit"] = 1
			data["from_star_id"] = "\ref[SSstarmap.from_system]"
			data["from_star_name"] = SSstarmap.from_system.name
			data["to_star_id"] = "\ref[SSstarmap.to_system]"
			data["to_star_name"] = SSstarmap.to_system.name

		if(SSstarmap.in_transit_planet)
			data["in_transit_planet"] = 1
			data["from_planet_id"] = "\ref[SSstarmap.from_planet]"
			data["from_planet_name"] = SSstarmap.from_planet.name
			data["to_planet_id"] = "\ref[SSstarmap.to_planet]"
			data["to_planet_name"] = SSstarmap.to_planet.name
		else if(!SSstarmap.in_transit)
			data["in_transit_planet"] = 0
			data["planet_id"] = "\ref[SSstarmap.current_planet]"
			data["planet_name"] = SSstarmap.current_planet.name

		if(SSstarmap.in_transit || SSstarmap.in_transit_planet)
			data["time_left"] = max(0, (SSstarmap.to_time - world.time) / 10)

		if(!SSstarmap.in_transit_planet && !SSstarmap.in_transit)
			var/obj/docking_port/mobile/ftl/ftl = SSshuttle.getShuttle("ftl")
			var/obj/docking_port/stationary/docked_port = ftl.get_docked()
			var/list/ports_list = list()
			data["ports"] = ports_list
			for(var/obj/docking_port/stationary/D in SSstarmap.current_planet.docks)
				ports_list[++ports_list.len] = list("name" = D.name, "docked" = (D == docked_port), "port_id" = "\ref[D]")

		if(SSstarmap.ftl_drive)
			data["has_drive"] = 1
			if(SSstarmap.ftl_drive.can_jump())
				data["drive_status"] = "Fully charged, ready for interstellar jump"
				data["drive_class"] = "good"
			else if(SSstarmap.ftl_drive.can_jump_planet() && (SSstarmap.ftl_drive.charging_power || SSstarmap.ftl_drive.charging_plasma))
				data["drive_status"] = "Charging, ready for interplanetary jump"
				data["drive_class"] = "average"
			else if(SSstarmap.ftl_drive.can_jump_planet())
				data["drive_status"] = "Not charging, ready for interplanetary jump"
				data["drive_class"] = "average"
			else if(SSstarmap.ftl_drive.charging_power || SSstarmap.ftl_drive.charging_plasma)
				data["drive_status"] = "Charging, not ready for jump"
				data["drive_class"] = "average"
			else if(SSstarmap.ftl_drive.stat & BROKEN)
				data["drive_status"] = "Broken"
				data["drive_class"] = "bad"
			else
				data["drive_status"] = "Not charging, not ready for jump"
				data["drive_class"] = "bad"

			data["drive_plasma_charge"] = SSstarmap.ftl_drive.plasma_charge
			data["drive_plasma_charge_max"] = SSstarmap.ftl_drive.plasma_charge_max
			data["drive_charging_plasma"] = SSstarmap.ftl_drive.charging_plasma
			data["drive_power_charge"] = SSstarmap.ftl_drive.power_charge
			data["drive_power_charge_max"] = SSstarmap.ftl_drive.power_charge_max
			data["drive_charging_power"] = SSstarmap.ftl_drive.charging_power
		else
			data["has_drive"] = 0
			data["drive_status"] = "Not found"
			data["drive_class"] = "bad"
	else if(screen == 1)
		var/list/systems_list = list()
		data["star_systems"] = systems_list
		if(SSstarmap.current_system)
			data["focus_x"] = SSstarmap.current_system.x
			data["focus_y"] = SSstarmap.current_system.y
		else
			data["focus_x"] = SSstarmap.get_ship_x()
			data["focus_y"] = SSstarmap.get_ship_y()
		for(var/datum/star_system/system in SSstarmap.star_systems)
			var/list/system_list = list()
			system_list["name"] = system.name
			if(SSstarmap.current_system)
				system_list["in_range"] = (SSstarmap.current_system.dist(system) < 20)
				system_list["distance"] = SSstarmap.current_system.dist(system)
			else
				system_list["in_range"] = 0
			system_list["x"] = system.x
			system_list["y"] = system.y
			system_list["star_id"] = "\ref[system]"
			system_list["is_current"] = (system == SSstarmap.current_system)
			system_list["alignment"] = system.alignment
			system_list["visited"] = system.visited
			var/label = ""
			for(var/datum/planet/P in system.planets)
				if(P.z_levels.len && P.z_levels[1] > 2)
					P.do_unload()
					if(!label && P.no_unload_reason)
						label = P.no_unload_reason
			if(system.capital_planet && !label)
				label = "CAPITAL"
			system_list["label"] = label
			systems_list[++systems_list.len] = system_list
		if(SSstarmap.in_transit)
			data["freepointer_x"] = SSstarmap.get_ship_x()
			data["freepointer_y"] = SSstarmap.get_ship_y()
			var/dist = SSstarmap.from_system.dist(SSstarmap.to_system)
			var/dx = SSstarmap.to_system.x - SSstarmap.from_system.x
			var/dy = SSstarmap.to_system.y - SSstarmap.from_system.y
			data["freepointer_cos"] = dx / dist
			data["freepointer_sin"] = dy / dist
	else if(screen == 2)
		data["star_id"] = "\ref[selected_system]"
		data["star_name"] = selected_system.name
		data["alignment"] = capitalize(selected_system.alignment)
		if(SSstarmap.current_system)
			data["star_dist"] = SSstarmap.current_system.dist(selected_system)
			data["can_jump"] = SSstarmap.current_system.dist(selected_system) < 20 && SSstarmap.ftl_drive && SSstarmap.ftl_drive.can_jump() && !SSstarmap.ftl_is_spooling
			data["can_cancel"] = SSstarmap.ftl_is_spooling && SSstarmap.ftl_can_cancel_spooling
	else if(screen == 3)
		var/list/planets_list = list()
		data["planets"] = planets_list
		for(var/datum/planet/planet in SSstarmap.current_system.planets)
			var/list/planet_list = list()
			planet_list["name"] = planet.name
			planet_list["planet_id"] = "\ref[planet]"
			planet_list["is_current"] = (planet == SSstarmap.current_planet)
			planet_list["x"] = planet.disp_x
			planet_list["y"] = planet.disp_y
			planet_list["dist"] = planet.disp_dist
			var/label = ""
			if(planet.z_levels.len && planet.z_levels[1] > 2)
				planet.do_unload()
				if(planet.no_unload_reason)
					label = planet.no_unload_reason
			planet_list["label"] = label
			planet_list["has_station"] = !!planet.station
			planet_list["ringed"] = planet.ringed
			planet_list["icon_name"] = planet.nav_icon_name
			planets_list[++planets_list.len] = planet_list
	else if(screen == 4)
		data["planet_id"] = "\ref[selected_planet]"
		data["planet_name"] = selected_planet.name
		data["planet_type"] = selected_planet.planet_type
		data["goto_action"] = selected_planet.goto_action
		data["can_cancel"] = SSstarmap.ftl_is_spooling && SSstarmap.ftl_can_cancel_spooling
		data["icon_view_counter"] = icon_view_counter

	return data

/obj/machinery/computer/ftl_navigation/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("select_system")
			var/datum/star_system/target = locate(params["star_id"])
			if(!istype(target))
				return
			selected_system = target
			screen = 2
			. = 1
		if("select_planet")
			var/datum/planet/target = locate(params["planet_id"])
			if(!istype(target))
				return
			if(selecting_planet)
				return
			selecting_planet = 1
			var/icon/new_planet_icon
			for(var/L in target.icon_layers)
				var/icon/I = icon('icons/mob/parallax.dmi', L)
				CHECK_TICK
				if(target.icon_layers[L])
					I.Blend(target.icon_layers[L], ICON_MULTIPLY)
				CHECK_TICK
				if(new_planet_icon == null)
					new_planet_icon = I
				else
					new_planet_icon.Blend(I, ICON_OVERLAY)
				CHECK_TICK
			do_send = 1
			spawn(5)
				do_send = 0
			planet_icon = new_planet_icon
			selecting_planet = 0
			selected_planet = target
			screen = 4
			icon_view_counter++
			. = 1
		if("shipinf")
			screen = 0
			. = 1
		if("map")
			screen = 1
			. = 1
		if("planet_map")
			screen = 3
			. = 1
		if("jump")
			SSstarmap.jump(selected_system)
			screen = 0
			post_status("ftl")
			. = 1
		if("jump_planet")
			SSstarmap.jump_planet(selected_planet)
			screen = 0
			post_status("ftl")
			. = 1
		if("jump_port")
			var/obj/docking_port/stationary/S = locate(params["port_id"])
			if(!istype(S))
				return
			SSstarmap.jump_port(S)
			. = 1
		if("cancel_jump")
			if(!SSstarmap.ftl_is_spooling || !SSstarmap.ftl_can_cancel_spooling)
				return
			SSstarmap.ftl_is_spooling = 0
			. = 1

/obj/machinery/computer/ftl_navigation/proc/post_status(command, data1, data2)

	var/datum/radio_frequency/frequency = SSradio.return_frequency(1435)

	if(!frequency) return

	var/datum/signal/status_signal = new
	status_signal.source = src
	status_signal.transmission_method = 1
	status_signal.data["command"] = command

	switch(command)
		if("message")
			status_signal.data["msg1"] = data1
			status_signal.data["msg2"] = data2
		if("alert")
			status_signal.data["picture_state"] = data1

	frequency.post_signal(src, status_signal)
