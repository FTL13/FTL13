/obj/docking_port/mobile/ftl
	name = "FTL Ship"
	id = "ftl"
	var/area_base_type = /area/shuttle/ftl
	dir = FTL_SHIP_DIR
	dwidth = FTL_SHIP_DWIDTH
	dheight = FTL_SHIP_DHEIGHT
	width = FTL_SHIP_WIDTH
	height = FTL_SHIP_HEIGHT

/obj/docking_port/mobile/ftl/is_valid_area_for_shuttle(area/tileArea, area/thisArea)
	return istype(tileArea, area_base_type)

/obj/docking_port/stationary/ftl_encounter
	name = "FTL Encounter"
	dir = FTL_SHIP_DIR
	dwidth = FTL_SHIP_DWIDTH
	dheight = FTL_SHIP_DHEIGHT
	width = FTL_SHIP_WIDTH
	height = FTL_SHIP_HEIGHT

/obj/machinery/computer/ftl_navigation
	name = "Navigation Computer"
	var/screen = 0 
	var/datum/star_system/selected_system
	var/datum/planet/selected_planet

/obj/machinery/computer/ftl_navigation/New()
	..()
	spawn(5)
		selected_system = SSstarmap.current_system
		screen = 1

/obj/machinery/computer/ftl_navigation/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, datum/tgui/master_ui = null, datum/ui_state/state = default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
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
			data["can_jump"] = SSstarmap.current_system.dist(selected_system) < 20
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
			planets_list[++planets_list.len] = planet_list
	else if(screen == 4)
		data["planet_id"] = "\ref[selected_planet]"
		data["planet_name"] = selected_planet.name
		data["planet_type"] = selected_planet.planet_type
		data["goto_action"] = selected_planet.goto_action
		
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
			selected_planet = target
			screen = 4
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
			. = 1
		if("jump_planet")
			SSstarmap.jump_planet(selected_planet)
			screen = 0
			. = 1