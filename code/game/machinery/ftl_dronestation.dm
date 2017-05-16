/obj/machinery/drone_station
  name = "drone maintenance station"
  var/list/current_drones = list()
  icon = 'icons/obj/drones.dmi'
  icon_state = "station_def"
  anchored = 1
  density = 0
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
  for(var/obj/machinery/drone/D in current_drones)
    qdel(D)  //Lost connection to all related drones, so they fly away into darkness

/obj/machinery/drone_station/proc/handle_deployment(var/obj/machinery/drone/D)
  if(!D)
    return
  popDown()
  sleep(30)

  if(!D.deployed)
    D.loc = null
    current_drones += D
  else
    D.loc = src.loc
    current_drones -= D
  popUp()
  D.deployed = !D.deployed

/obj/machinery/drone_station/proc/occupied()
  for(var/obj/machinery/drone/here_drone in loc)
    if(!here_drone)    return 0
    else if(!here_drone.deployed) return 1
  return 0

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