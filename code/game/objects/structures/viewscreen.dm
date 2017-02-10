/obj/structure/viewscreen
	name = "bridge viewscreen"
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


/obj/structure/viewscreen/New()
	if(dir == 4 || dir == 8)
		bound_width = 32
		bound_height = 96
		bound_x = 32
		bound_y = 0

/obj/structure/viewscreen/examine(mob/user)
	..()
	ui_interact(user)

/obj/structure/viewscreen/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, datum/tgui/master_ui = null)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "ftl_viewscreen", name, 800, 660, master_ui, conscious_state)
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
					ship_list["target"] = station_name
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
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_control_standby"

	density = 0
	anchored = 1

	var/obj/structure/viewscreen/linked = null


/obj/structure/viewscreen_controller/New()
	for(var/obj/structure/viewscreen/V in world)
		linked = V

	..()

/obj/structure/viewscreen_controller/attack_hand(mob/user)
	var/dat = "<B>Viewscreen Control Panel</B><HR>"
	dat += "Viewing Mode: [linked.view_mode ? "Navigation" : "Tactical"]"
	dat += "<BR><BR><A href=?src=\ref[src];switch=1>Switch View Modes</A>"

	var/datum/browser/popup = new(user, "view_control", name, 400, 300)

	popup.set_content(dat)
	popup.open(0)

/obj/structure/viewscreen_controller/Topic(href,href_list)
	..()
	if(href_list["switch"])
		linked.view_mode = !linked.view_mode

	attack_hand(usr)



