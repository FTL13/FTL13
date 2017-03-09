/datum/round_event/ghost_role/boarding/proc/spawnTerminal()
  var/list/spawn_locs = list()
  for(var/obj/effect/landmark/L in landmarks_list)
    if(L.name == "terminal_spawn")
      spawn_locs += get_turf(L)
  if(!spawn_locs.len)
    return 0
  var/new_loc = pick(spawn_locs)
  var/obj/machinery/computer/def_terminal/Terminal = new /obj/machinery/computer/def_terminal(new_loc) //TODO: Terminal
  Terminal.mode = src
  /*Terminal.hidden_uplink = new(src)
  Terminal.hidden_uplink.active = TRUE
  Terminal.hidden_uplink.lockable = FALSE
  Terminal.hidden_uplink.boarding = TRUE*/
  return 1

//TODO:here comes the terminal code itself

/obj/machinery/computer/def_terminal
  name = "Ship Main Terminal"
  desc = "Vital computer for the ship system. Provides executive access to all ship functions."
  var/datum/round_event/ghost_role/boarding/mode = null

/obj/machinery/computer/def_terminal/New()
  ..()
  addtimer(src, "callExplosion", 12000) //20 minutes

/obj/machinery/computer/def_terminal/attack_hand(mob/user)
  if(ishuman(user))
    if(user.faction != "syndicate")
      if(do_after(user,300,target = src)) //30 seconds
        mode.victory()
        qdel(src)

/obj/machinery/computer/def_terminal/ex_act()
  return

/obj/machinery/computer/def_terminal/proc/callExplosion()
  if(mode.defeat(loc.z))
    explosion(src.loc,5,7,9,18) //kaboom
