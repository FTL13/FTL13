/obj/machinery/computer/power_management
	name = "power distribution computer"
	desc = "Used for distributing power across the ship, setting priority areas, and disabling power to those which aren't as important"
	req_access = list(access_engine)
	var/active = 0
	circuit = /obj/item/weapon/circuitboard/computer/power_management
	icon_keyboard = "tech_key"
	icon_screen = "ai-fixer"

/obj/machinery/computer/power_management/attackby(obj/I, mob/user, params)
	if(istype(I, /obj/item/weapon/screwdriver))
		if(stat & (NOPOWER|BROKEN))
			user << "<span class='warning'>The screws on [name]'s screen won't budge.</span>"
		else
			user << "<span class='warning'>The screws on [name]'s screen won't budge and it emits a warning beep.</span>"
	else
		return ..()

/obj/machinery/computer/power_management/attack_hand(mob/user)
	if(..())
		return
	interact(user)

/obj/machinery/computer/power_management/proc/scan_breakers()
  var/i = 1
  var/data = ""

  for(var/obj/machinery/power/breakerbox/BB in world, i++)
    data += "Breaker Box No.[i], located at [BB.x], [BB.y], [BB.z]; assigned to [BB.department].<br>"

  return data

/obj/machinery/computer/power_management/interact(mob/user)
  var/dat = ""

  dat += scan_breakers()

  dat += "<a href='byond://?src=\ref[src];refresh=1'>Refresh</a><br>"

  //user << browse(dat, "window=computer;size=400x500")
  //onclose(user, "computer")
  var/datum/browser/popup = new(user, "computer", "Power Distribution Computer", 400, 500)
  popup.set_content(dat)
  popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
  popup.open()
  return

/obj/machinery/computer/power_management/process()
	if(..())
		updateDialog()
		return

/obj/machinery/computer/power_management/Topic(href, href_list)
  if(..())
    return

  if(href_list["refresh"])
    updateUsrDialog()
