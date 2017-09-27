/obj/structure/viewscreen
	name = "bridge viewscreen"
	desc = "This is a viewscreen display"
	icon = 'icons/obj/96x96.dmi'
	icon_state = "viewscreen"
	density = 0
	anchored = 1
	layer = SIGN_LAYER
	bound_width = 96
	bound_y = 32
	bound_x = -32
	pixel_x = -32

	var/view_mode = 0 //0 = tactical 1 = nav


/obj/structure/viewscreen/Initialize()
	. = ..()
	if(dir == 4 || dir == 8)
		bound_width = 32
		bound_height = 96
		bound_x = 32
		bound_y = 0

/obj/structure/viewscreen/Destroy()
	// Remove all references to this viewscreen from any viewscreen_controllers in the world
	for (var/obj/structure/viewscreen_controller/V in world)
		if (V.linked_viewscreens)
			V.linked_viewscreens -= src
	. = ..()

/obj/structure/viewscreen/examine(mob/user)
	..()
	ui_interact(user)

/obj/structure/viewscreen/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, datum/tgui/master_ui = null)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "ftl_viewscreen", name, 800, 660, master_ui, GLOB.conscious_state)
		ui.open()

/obj/structure/viewscreen/ui_data(mob/user)
	var/list/data = list()
	data["screen"] = view_mode
	if(!view_mode)
		var/list/ships_list = list()
		data["ships"] = ships_list
		for(var/datum/star_faction/faction in SSship.star_factions)
			for(var/datum/starship/S in SSstarmap.current_system.ships)
				if(S.faction != faction.cname) //quick an easy way of sorting
					continue
				var/list/ship_list = list()
				ship_list["ship_name"] = S.name
				ship_list["faction"] = S.faction
				ship_list["hull"] = S.hull_integrity
				switch(round(S.hull_integrity / initial(S.hull_integrity),0.1))
					if(0 to 0.5)
						ship_list["hull_class"] = "average"
					if(0.6 to 1)
						ship_list["hull_class"] = "good"
				ship_list["max_hull"] = initial(S.hull_integrity)
				ship_list["shield"] = S.shield_strength
				ship_list["max_shield"] = initial(S.shield_strength)
				if(S.attacking_player)
					ship_list["target"] = GLOB.station_name
				else if(S.attacking_target)
					ship_list["target"] = S.attacking_target.name

				if(S.flagship)
					ship_list["flagship"] = "[S.flagship.name]"
				else
					ship_list["flagship"] = "No Flagship"

				if(S.cargo)
					ship_list["cargo"] = "[S.cargo_limit] [S.cargo]"
				else
					ship_list["cargo"] = "No Cargo"
				if(S.is_jumping)
					if(S.target)
						ship_list["jumping"] = "Jumping. Target: [S.target.name]"
					else
						ship_list["jumping"] = "Jumping. Target: [S.ftl_vector]"

				else
					ship_list["jumping"] = "Not Jumping"


				ships_list[++ships_list.len] = ship_list

	else
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
				if(P.z_levels.len && P.z_levels[1] > 2 && !P.do_unload())
					label = "RELAY"
					break
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

	return data


/obj/structure/viewscreen_controller
	name = "viewscreen control panel"
	desc = "This is a control panel for the viewscreens"
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_control_standby"

	density = 0
	anchored = 1
	var/list/linked_viewscreens = null

/obj/structure/viewscreen_controller/proc/get_area_viewscreens()
	var/list/screens = list()
	var/turf/T = get_turf(src)
	var/area/A = get_area(T)
	for(var/obj/structure/viewscreen/V in area_contents(A))
		screens += V
	return screens

/obj/structure/viewscreen_controller/attack_hand(mob/user)

	// If this is being called for the first time, populate the list of screens
	if (!linked_viewscreens)
		linked_viewscreens = get_area_viewscreens()

	var/dat = "<B>Viewscreen Control Panel</B><HR>"
	dat += "<A href='?src=\ref[src];refreshscreens=1'>Refresh list of screens</A><BR><BR>"

	for(var/obj/structure/viewscreen/V in linked_viewscreens)
		dat += "<B>[V]</B><BR>"
		dat += "Currently displaying: [V.view_mode ? "Navigation" : "Tactical"]<BR>"
		dat += "<A href='?src=\ref[src];switchmode=\ref[V]'>Switch display mode</A><BR><BR>"

	var/datum/browser/popup = new(user, "view_control", name, 400, 300)

	popup.set_content(dat)
	popup.open(0)

/obj/structure/viewscreen_controller/Topic(href,href_list)
	..()
	if(!usr.canUseTopic(src))
		return

	if(href_list["refreshscreens"])
		linked_viewscreens = get_area_viewscreens()

	if(href_list["switchmode"])
		var/obj/structure/viewscreen/V = locate(href_list["switchmode"])
		if (V)
			V.view_mode = !V.view_mode

	attack_hand(usr)



