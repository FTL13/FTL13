/obj/machinery/computer/ftl_scanner
	name = "Ship Sensors Console"

	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "rd_key"
	icon_screen = "scanner_comp"

	var/datum/starship/target
	var/datum/component/target_component

/obj/machinery/computer/ftl_scanner/New()
	..()
	SSship.consoles += src

/obj/machinery/computer/ftl_scanner/attack_hand(mob/user) //not doing that many safety checks since this is going to be converted to tgui anyways
	
	var/datum/asset/assets = get_asset_datum(/datum/asset/simple/tactical)
	assets.send(user)
	
	var/dat = "<B>Ship Sensors Console</B><HR>"
	dat += "<BR>"
	if(SSstarmap.in_transit)
		dat += "<B>Location:</B> In Transit"
	else
		dat += "<B>Location:</B> [SSstarmap.current_system] - [SSstarmap.current_planet]"


		dat += "<HR>"
		dat += "<B>Ships Detected in System:</B>"

		for(var/datum/starship/S in SSstarmap.current_system.ships)
			dat += "<BR>[S.name] ([S.faction]) - [S.planet] (<A href=?src=\ref[src];target=\ref[S]>Target Ship</A>)"

		dat += "<HR>"
		if(target)
			dat += "<B>Targeted Ship:</B> [target.name]<br><br>"
			dat += "<table>"
			for(var/cy in 1 to target.y_num)
				dat += "<tr>"
				for(var/cx in 1 to target.x_num)
					var/datum/component/C
					for(var/datum/component/check in target.components)
						if(check.x_loc == cx && check.y_loc == cy)
							C = check
							break
					if(C == null)
						dat += "<td></td>"
						continue
					dat += "<td>"
					var/health = C.health / initial(C.health)
					var/bgcolor
					if(health == 0)
						bgcolor = "red"
					else if(health > 0 && health < 1)
						bgcolor = "orange"
					else
						bgcolor = "black"
					dat += "<a href='?src=\ref[src];target_component=\ref[C]' style='display:block; border: 1px solid [C == target_component ? "white" : "black"]; padding: 4px; background-color: [bgcolor]'>"
					dat += "<img src='tactical_[C.cname].png' title='[C.name] ([C.health]/[initial(C.health)])'>"
					dat += "</a>"
					dat += "</td>"
				dat += "</tr>"
			dat += "</table>"
		else
			dat += "<B>Targeted Ship:</B> None"



	var/datum/browser/popup = new(user, "scanner", name, 800, 660)

	popup.set_content(dat)
	popup.open(0)

/obj/machinery/computer/ftl_scanner/Topic(href,href_list)
	..()
	if(href_list["target"])
		var/datum/starship/S = locate(href_list["target"])
		if(istype(S))
			target = S
			target_component = S.components[1]
	if(href_list["target_component"])
		var/datum/component/C = locate(href_list["target_component"])
		if(istype(C) && (C in target.components))
			target_component = C
			
	attack_hand(usr)

/obj/machinery/computer/ftl_scanner/proc/status_update(var/message,var/sound)
	visible_message("\icon[src] [message]")
	if(sound)
		playsound(loc,sound,50,0)
