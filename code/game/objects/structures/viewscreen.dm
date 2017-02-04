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

	var/view_mode = 0 //0 = starmap, 1 = scanner, 2 = tactical


/obj/structure/viewscreen/New()
	if(dir == 4 || dir == 8)
		bound_width = 32
		bound_height = 96
		bound_x = 32

/obj/structure/viewscreen/examine(mob/user)
	..()
	ui_interact(user)

/obj/structure/viewscreen/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, datum/tgui/master_ui = null, datum/ui_state/state = default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "ftl_viewscreen", name, 800, 660, master_ui, state)
		ui.open()

/obj/structure/viewscreen/ui_data(mob/user)
	var/list/data = list()
	var/list/ships_list = list()
	data["ships"] = ships_list
	for(var/datum/starship/S in SSstarmap.current_system.ships)
		var/list/ship_list = list()
		ship_list["name"] = S.name
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
			ship_list["target"] = S.attacking_target


		ships_list[++ships_list.len] = ship_list

	return data



