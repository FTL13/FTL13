/obj/machinery/drone_station
  name = "drone maintance station"
  var/list/defence_drones = list()
  icon = 'icons/obj/drones.dmi'
  icon_state = "station_def"
  anchored = 1
  density = 0
  var/obj/machinery/drone_station_cover/cover = null


/obj/machinery/drone_station_cover
  name = "cover"
  icon = 'icons/obj/drones.dmi'
  icon_state = "cover"
  layer = HIGH_OBJ_LAYER
  density = 0
  anchored = 1
  var/obj/machinery/drone_station/parent_station = null

/obj/machinery/drone_station/New()
	cover = new /obj/machinery/drone_station_cover(loc)
	cover.parent_station = src

/obj/machinery/drone_station/Destroy()
  if(occupied())
    for(var/obj/structure/drone/DD in loc)
      if(DD.orbiting)
        qdel(DD)  //Lost connection to all related drones, so they fly away into darkness

/obj/machinery/drone_station/proc/occupied()
  var/obj/structure/drone/here_drone = locate(/obj/structure/drone) in loc
  if(!here_drone)    return 0
  else  return 1

/obj/machinery/drone_station/proc/deploy(var/obj/structure/drone/deploying)
  if(!occupied())
    return
  if(deploying.orbiting)
    return
  popDown()
  sleep(10)
  popUp()
  deploying.invisibility = INVISIBILITY_ABSTRACT
  deploying.orbiting = 1

/obj/machinery/drone_station/proc/deploy(var/obj/structure/drone/returning)
  if(!returning.orbiting)
    return
  deploying.invisibility = 0
  deploying.orbiting = 0

/obj/machinery/drone_station/proc/popUp()
	if(cover)
		flick("popup", cover)
	  sleep(10)
		cover.icon_state = "cover_open"
	layer = MOB_LAYER

/obj/machinery/drone_station/proc/popDown()
	layer = OBJ_LAYER
	if(cover)
		flick("popdown", cover)
	  sleep(10)
		cover.icon_state = "cover_[drone_type]"
	icon_state = "[base_icon_state]"
