/obj/docking_port/mobile/ftl
	name = "FTL Ship"
	id = "ftl"
	var/area_base_type = /area/shuttle/ftl

/obj/docking_port/mobile/ftl/is_valid_area_for_shuttle(area/tileArea, area/thisArea)
	return istype(tileArea, area_base_type)

/obj/machinery/computer/ftl_navigation
	name = "Navigation Computer"

/obj/machinery/computer/ftl_navigation/New()
	..()

/obj/machinery/computer/ftl_navigation/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, datum/tgui/master_ui = null, datum/ui_state/state = default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "ftl_navigation", name, 800, 600, master_ui, state)
		ui.open()

/obj/machinery/computer/ftl_navigation/ui_data(mob/user)
	var/list/data = list()
	var/list/systems_list = list()
	data["star_systems"] = systems_list
	for(var/datum/star_system/system in SSstarmap.star_systems)
		var/list/system_list = list()
		system_list["name"] = system.name
		system_list["in_range"] = 1
		system_list["x"] = system.x
		system_list["y"] = system.y
		system_list["star_id"] = "\ref[system]"
		system_list["is_current"] = (system == SSstarmap.current_system)
		systems_list[++systems_list.len] = system_list
	return data

/obj/machinery/computer/ftl_navigation/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("jump")
			var/datum/star_system/target = locate(params["jump"])
			if(!istype(target))
				return
			SSstarmap.jump(target)