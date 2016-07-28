/obj/machinery/computer/ftl_scanner
	name = "Ship Sensors Console"

	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "rd_key"
	icon_screen = "scanner_comp"

	var/datum/starship/target

/obj/machinery/computer/ftl_scanner/New()
	..()
	SSship.consoles += src

/obj/machinery/computer/ftl_scanner/attack_hand(mob/user) //not doing that many safety checks since this is going to be converted to tgui anyways
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
	if(target) dat += "<B>Targeted Ship:</B> [target.name]"
	else dat += "<B>Targeted Ship:</B> None"



	var/datum/browser/popup = new(user, "scanner", name, 800, 660)

	popup.set_content(dat)
	popup.open(0)

/obj/machinery/computer/ftl_scanner/Topic(href,href_list)
	..()
	if(href_list["target"])
		var/datum/starship/S = href_list["target"]
		target = locate(S)

	attack_hand(usr)

/obj/machinery/computer/ftl_scanner/proc/status_update(var/message,var/sound)
	visible_message("\icon[src] [message]")
	if(sound)
		playsound(loc,sound,50,0)
