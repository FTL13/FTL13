/datum/round_event/ghost_role/boarding/proc/spawnTerminal()
  var/list/spawn_locs = list()
  for(var/obj/effect/landmark/L in landmarks_list)
    if(L.name in list("defender_terminal"))
      spawn_locs += L.loc
  if(!spawn_locs.len)
    return 0
  var/obj/machinery/computer/def_terminal = new /obj/machinery/computer/def_terminal(pick(spawn_locs))
  return 1

//TODO:here comes the terminal code itself
