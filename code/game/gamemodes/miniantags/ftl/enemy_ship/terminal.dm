/datum/round_event/ghost_role/boarding/proc/spawnTerminal(var/new_loc)
  //var/list/spawn_locs = list()
  // for(var/obj/effect/landmark/L in landmarks_list)
  //   if(L.name == "terminal_spawn")
  //     spawn_locs += get_turf(L)
  //     qdel(L)
  // if(!spawn_locs.len)
  //   return 0
  // var/new_loc = pick(spawn_locs)
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
  desc = "ALL SYSTEMS DEACTIVATED"
  var/datum/round_event/ghost_role/boarding/mode = null
  var/isactive = 1 //is conting?

/obj/machinery/computer/def_terminal/process()
  if(isactive)
    for(var/obj/effect/defence/D in world)
      if(D.z != src.z)
        continue
      else
        if(D.timer > 0)
          D.timer--
          D.desc = "Shield going down in [D.timer] seconds"
        else
          D.callTime()
    if(mode.timer > 0)
      if(mode.time_set && mode.shield_down)
        mode.timer--
        var/minutes = round(mode.timer/60)
        var/seconds = mode.timer - (minutes*60)
        desc = "ALERT! SELF-DESTRUCTION ACTIVATED. TIME LEFT: [minutes]:[seconds]"
    else
      callExplosion()
      qdel(src)

/obj/machinery/computer/def_terminal/attack_hand(mob/user)
  if(ishuman(user) && isactive)
    if(user.mind.special_role != "Defender")
      if(do_after(user,300,target = src)) //30 seconds
        mode.victory()
        isactive = 0
        desc = initial(desc)

/obj/machinery/computer/def_terminal/ex_act()
  return

/obj/machinery/computer/def_terminal/proc/callExplosion()
  if(mode.defeat(loc.z) && isactive)
    explosion(src.loc,5,7,9,18) //kaboom
