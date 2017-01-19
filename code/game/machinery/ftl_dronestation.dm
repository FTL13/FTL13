/obj/machinery/drone_station
  name = "drone launch silos"
  var/list/defence_drones = list()
  icon = 'icons/obj/drones.dmi'
  icon_state = "station_def"
  anchored = 1
  density = 0
  var/id = 0
  var/obj/machinery/drone_station_cover/cover = null


/obj/machinery/drone_station_cover
  name = "cover"
  icon = 'icons/obj/drones.dmi'
  icon_state = "cover_open"
  layer = HIGH_OBJ_LAYER
  density = 0
  anchored = 1
  var/obj/machinery/drone_station/parent_station = null

/obj/machinery/drone_station/New()
	cover = new /obj/machinery/drone_station_cover(loc)
	cover.parent_station = src

/obj/machinery/drone_station/Destroy()
  if(occupied())
    for(var/obj/machinery/drone/DD in loc)
      if(DD.is_orbiting)
        qdel(DD)  //Lost connection to all related drones, so they fly away into darkness

/obj/machinery/drone_station/proc/occupied()
  var/obj/machinery/drone/here_drone = locate(/obj/machinery/drone) in loc
  if(!here_drone)    return 0
  else  return 1

/obj/machinery/drone_station/proc/deploy(var/obj/machinery/drone/deploying)
  if(!occupied())
    return
  if(deploying.is_orbiting)
    return
  popDown()
  deploying.invisibility = INVISIBILITY_ABSTRACT  //we don't want to see this ABSTRACT thing
  deploying.anchored = 1    //we dont want this ABSTRACT thing to be sucked by hull breech
  deploying.density = 0     //we dont want bump into this ABSTRACT thing
  deploying.is_orbiting = 1  //tells that it's ABSTRACT thing
  sleep(30)
  popUp()


/obj/machinery/drone_station/proc/return_pls(var/obj/machinery/drone/returning)
  if(!returning.is_orbiting)
    return
  returning.invisibility = 0
  returning.anchored = 0
  returning.density = 1
  returning.is_orbiting = 0

/obj/machinery/drone_station/proc/popUp()
	if(cover)
		flick("popup", cover)
		sleep(10)
		cover.icon_state = "cover_open"
		cover.layer = MOB_LAYER


/obj/machinery/drone_station/proc/popDown()
	if(cover)
		flick("popdown", cover)
		sleep(10)
		cover.icon_state = "cover"
