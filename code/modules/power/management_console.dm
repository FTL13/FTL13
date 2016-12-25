/obj/machinery/computer/pmanagement
  name = "power management console"
  desc = "From this console, you can transfer power from and to areas."
  icon_screen = "power"
  icon_keyboard = "power_key"
  use_power = 2
  idle_power_usage = 20
  active_power_usage = 100
  circuit = /obj/item/weapon/circuitboard/computer/pmanagement
  var/uiscreen = 1
  var/used = 0

  var/obj/machinery/power/apc/detailed
  var/obj/machinery/power/apc/selected
  var/list/transferredto = list()
  var/list/transferredfrom = list() //bad, bad, bad, but it works
  var/obj/structure/cable/attached

/obj/machinery/computer/pmanagement/New()
	..()
	search()

/obj/machinery/computer/pmanagement/process()
  if(!attached)
    use_power = 1
  else
    use_power = 2
  updateUsrDialog()
  attack_hand(usr)

/obj/machinery/computer/pmanagement/proc/search()
	var/turf/T = get_turf(src)
	attached = locate() in T

/obj/machinery/computer/pmanagement/attack_hand(mob/user)
  search()
  var/dat = ""

  if(uiscreen == 1) //main screen (area listing)
    dat = "<B>Power Management Console</B>"
    dat += "<BR><BR>"
    dat += "<B>Select area to display details:</B>"
    dat += "<HR>"

    if(attached) //don't runtime on me
      for(var/obj/machinery/power/terminal/term in attached.powernet.nodes)
        var/obj/machinery/power/apc/A = term.master
        if(istype(A))
          dat += "<A href=?src=\ref[src];details=\ref[A]>[A.area.name]</A>"
          if(A.transferringto)
            dat += " This area's power is being transferred to [A.transferringto.area.name]."
          if(A in transferredto)
            var/obj/machinery/power/apc/from = transferredfrom[transferredto.Find(A)]
            dat += " Power is being transferred to this area from [from.area.name]"
          dat += "<BR>"

    else
      dat += "<center><font color=red><B>Could not scan powernet!</B><BR>Error: No powernet access node detected.</font></center>"
      dat += "<center><A href=?src=\ref[src];scan=1>Rescan</A><BR></center>"
  else if(uiscreen == 2) //details screen
    if(detailed)

      dat = "<B>Details on [detailed.area.name]</B><BR><HR>"
      if(detailed.transferringto)
        dat += "<center><B><font color=red>This area's power is currently being transferred to [detailed.transferringto.area.name]!</font></B></center>"
        dat += "<BR><center><A href=?src=\ref[src];cancelt=\ref[detailed]>Cancel Transfer</A></center>"
      if(detailed in transferredto)
        var/obj/machinery/power/apc/from = transferredfrom[transferredto.Find(detailed)]
        dat += "<center><B><font color=red>Power is being transferred to this area from [from.area.name].</font></B></center>"
        dat += "<BR><center><A href=?src=\ref[src];cancelt=\ref[from]>Cancel Transfer</A></center>"
      dat += "<BR><B>Name: </B>[detailed.area.name]"
      dat += "<BR><B>Load: </B>[round(detailed.lastused_total)]W"

      if(!selected)
        dat += "<BR><A href=?src=\ref[src];tfrom=\ref[detailed]>Transfer Power From This Area</A>"
      if(selected && selected != detailed)
        dat += "<BR><A href=?src=\ref[src];tto=\ref[detailed]>Transfer Power To This Area (from [selected.area.name])</A><BR><A href=?src=\ref[src];cancela=1>Cancel</A>"
      if(selected && selected == detailed)
        dat += "<BR>Go choose another area to transfer power to!<BR><A href=?src=\ref[src];cancela=1>Cancel</A>"

      dat += "<BR><BR><HR><center><A href=?src=\ref[src];main=1>Go Back To Main Screen</A></center>"
    else
      dat = "<center><B>Error! Contact a coder!</B></center><BR><HR>"
      dat += "<BR><center><A href=?src=\ref[src];main=1>Go back to main screen</A></center>"

  var/datum/browser/popup = new(user, "management", name, 800, 660)

  popup.set_content(dat)
  popup.open(0)

/obj/machinery/computer/pmanagement/Topic(href,href_list)
  ..()

  usr.set_machine()
  if(href_list["details"])
    detailed = locate(href_list["details"])
    uiscreen = 2
    updateUsrDialog()

  if(href_list["details"])
    search()
    updateUsrDialog()

  if(href_list["main"])
    if(detailed) //sanity
      detailed = null
    uiscreen = 1
    updateUsrDialog()

  if(href_list["cancela"])
    if(selected) //we still need sanity, bruh
      if(selected in transferredfrom)
        transferredfrom -= selected
      selected = null
    updateUsrDialog()

  if(href_list["tfrom"])
    selected = locate(href_list["tfrom"]) //I could just use detailed, but why not do this while we're here
    updateUsrDialog()

  if(href_list["cancelt"])
    var/obj/machinery/power/apc/A = locate(href_list["cancelt"])
    if(istype(A))
      if(A in transferredfrom)
        transferredfrom -= A
      if(A.transferringto in transferredto)
        transferredto -= A.transferringto
      A.transferringto = null
      updateUsrDialog()

  if(href_list["tto"])
    if(!selected) //wut
      return
    selected.transferringto = locate(href_list["tto"])//let the apc do its thang
    transferredfrom += selected
    transferredto += selected.transferringto
    selected = null
    updateUsrDialog()

  attack_hand(usr)

/obj/machinery/computer/pmanagement/on_unset_machine()
  ui_screen = 1 //reset the screen
