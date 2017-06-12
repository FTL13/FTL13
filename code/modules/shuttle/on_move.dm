/*
All ShuttleMove procs go here
*/

/************************************Base procs************************************/

// Called before shuttle starts moving atoms.
/atom/movable/proc/beforeShuttleMove(turf/T1, rotation)
	return

// Called when shuttle attempts to move an atom.
/atom/movable/proc/onShuttleMove(turf/T1, rotation, knockdown = TRUE)
	if(rotation)
		shuttleRotate(rotation)
	loc = T1
	if (length(client_mobs_in_contents))
		update_parallax_contents()
	return 1

// Called after all of the atoms on shuttle are moved.
/atom/movable/proc/afterShuttleMove()
	return

/************************************Shuttle Rotation************************************/

/atom/proc/shuttleRotate(rotation)
	//rotate our direction
	setDir(angle2dir(rotation+dir2angle(dir)))

	//resmooth if need be.
	if(smooth)
		queue_smooth(src)

	//rotate the pixel offsets too.
	if (pixel_x || pixel_y)
		if (rotation < 0)
			rotation += 360
		for (var/turntimes=rotation/90;turntimes>0;turntimes--)
			var/oldPX = pixel_x
			var/oldPY = pixel_y
			pixel_x = oldPY
			pixel_y = (oldPX*(-1))

/************************************Machinery move procs************************************/

/obj/machinery/door/airlock/onShuttleMove()
	shuttledocked = 0
	for(var/obj/machinery/door/airlock/A in range(1, src))
		A.shuttledocked = 0
		A.air_tight = TRUE
		INVOKE_ASYNC(A, /obj/machinery/door/.proc/close)
	. = ..()
	shuttledocked =  1
	for(var/obj/machinery/door/airlock/A in range(1, src))
		A.shuttledocked = 1

/obj/machinery/camera/onShuttleMove(turf/T1, rotation)
	if(can_use())
		GLOB.cameranet.removeCamera(src)
	. = ..()
	if(can_use())
		spawn(1)
			GLOB.cameranet.addCamera(src)

/obj/machinery/ftl_shieldgen/beforeShuttleMove()
	. = ..()
	if(is_active())
		drop_physical()

/obj/machinery/ftl_shieldgen/afterShuttleMove()
	. = ..()
	if(is_active())
		spawn(1)
			raise_physical()

/obj/machinery/telecomms/onShuttleMove(turf/T1, rotation)
	. = ..()
	if(. && T1) // Update listening Z, just in case you have telecomm relay on a shuttle
		listening_level = T1.z

/obj/machinery/mech_bay_recharge_port/onShuttleMove(turf/T1, rotation)
	. = ..()
	spawn(1)
		recharging_turf = get_step(loc, dir)

/obj/machinery/atmospherics/onShuttleMove()
	. = ..()
	if(pipe_vision_img)
		pipe_vision_img.loc = loc

/obj/machinery/computer/auxillary_base/onShuttleMove(turf/T1, rotation)
	..()
	if(z == ZLEVEL_MINING) //Avoids double logging and landing on other Z-levels due to badminnery
		SSblackbox.add_details("colonies_dropped", "[x]|[y]|[z]") //Number of times a base has been dropped!

/************************************Item move procs************************************/

/obj/item/weapon/storage/pod/onShuttleMove()
	unlocked = TRUE
	// If the pod was launched, the storage will always open.
	return ..()

/************************************Mob move procs************************************/

/mob/onShuttleMove()
	if(!move_on_shuttle)
		return 0
	. = ..()
	if(!.)
		return
	if(client)
		if(buckled)
			shake_camera(src, 2, 1) // turn it down a bit come on
		else
			shake_camera(src, 7, 1)

/mob/living/carbon/onShuttleMove(turf/T1, rotation, knockdown = TRUE)
	. = ..()
	if(!.)
		return
	if(!buckled && knockdown)
		Weaken(1)

/mob/living/simple_animal/hostile/megafauna/onShuttleMove()
	var/turf/oldloc = loc
	. = ..()
	if(!.)
		return
	var/turf/newloc = loc
	message_admins("Megafauna [src] [ADMIN_FLW(src)] moved via shuttle from [ADMIN_COORDJMP(oldloc)] to [ADMIN_COORDJMP(newloc)]")

/************************************Structure move procs************************************/

/obj/structure/cable/beforeShuttleMove(turf/T1, rotation)
	var/on_edge = FALSE
	var/A = get_area(src)

	for(var/D in GLOB.alldirs)
		if(A != get_area(get_step(src, D)))
			on_edge = TRUE
			break

	if(on_edge && powernet)
		var/tmp_loc = loc
		cut_cable_from_powernet()
		loc = tmp_loc

/obj/structure/cable/afterShuttleMove()
	var/on_edge = FALSE
	var/A = get_area(src)

	for(var/D in GLOB.alldirs)
		if(A != get_area(get_step(src, D)))
			on_edge = TRUE
			break

	if(on_edge)
		var/datum/powernet/PN = new()
		PN.add_cable(src)

		mergeConnectedNetworks(d1) //merge the powernet with adjacents powernets
		mergeConnectedNetworks(d2)
		mergeConnectedNetworksOnTurf() //merge the powernet with on turf powernets

		if(d1 & (d1 - 1))// if the cable is layed diagonally, check the others 2 possible directions
			mergeDiagonalsNetworks(d1)
		if(d2 & (d2 - 1))
			mergeDiagonalsNetworks(d2)


/************************************Misc move procs************************************/

/atom/movable/lighting_object/onShuttleMove(turf/T1, rotation)
	return FALSE

/atom/movable/light/onShuttleMove()
	return 0

/obj/onShuttleMove()
	if(invisibility >= INVISIBILITY_ABSTRACT && !shuttle_abstract_movable)
		return 0
	. = ..()

obj/docking_port/stationary/public_mining_dock/onShuttleMove()
	id = "mining_public" //It will not move with the base, but will become enabled as a docking point.
	return 0

/obj/effect/abstract/proximity_checker/onShuttleMove()
	//timer so it only happens once
	addtimer(CALLBACK(monitor, /datum/proximity_monitor/proc/SetRange, monitor.current_range, TRUE), 0, TIMER_UNIQUE)
