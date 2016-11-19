/obj/structure/spacepoddoor
	name = "Podlock"
	desc = "Why it no open!!!"
	icon = 'icons/effects/beam.dmi'
	icon_state = "n_beam"
	density = 0
	anchored = 1

/obj/structure/spacepoddoor/initialize()
	..()
	air_update_turf(1)

/obj/structure/spacepoddoor/CanAtmosPass(turf/T)
	return 0

/obj/structure/spacepoddoor/Destroy()
	air_update_turf(1)
	return ..()

/obj/structure/spacepoddoor/CanPass(atom/movable/A, turf/T)
	if(istype(A, /obj/spacepod))
		return ..()
	else return 0

/obj/machinery/door/poddoor/multi_tile
	name = "Large Pod Door"

/obj/machinery/door/poddoor/multi_tile/initialize()
	..()
	SetOpacity(opacity)

/obj/machinery/door/poddoor/multi_tile/SetOpacity(newopacity)
	..()
	for(var/turf/T in locs)
		var/obj/structure/spacepoddoor/D = locate(/obj/structure/spacepoddoor) in T
		if(!D)
			D = new /obj/structure/spacepoddoor(T)
			D.dir = (dir == 1) ? 2 : 8
		D.SetOpacity(newopacity)

/obj/machinery/door/poddoor/multi_tile/Destroy()
	for(var/turf/T in locs)
		var/obj/structure/spacepoddoor/D = locate(/obj/structure/spacepoddoor) in T
		if(D)
			qdel(D)
	. = ..()

/obj/machinery/door/poddoor/multi_tile/four_tile_ver/
	icon = 'icons/obj/doors/1x4blast_vert.dmi'
	bound_height = 128
	dir = NORTH

/obj/machinery/door/poddoor/multi_tile/three_tile_ver/
	icon = 'icons/obj/doors/1x3blast_vert.dmi'
	bound_height = 96
	dir = NORTH

/obj/machinery/door/poddoor/multi_tile/two_tile_ver/
	icon = 'icons/obj/doors/1x2blast_vert.dmi'
	bound_height = 64
	dir = NORTH

/obj/machinery/door/poddoor/multi_tile/four_tile_hor/
	icon = 'icons/obj/doors/1x4blast_hor.dmi'
	bound_width = 128
	dir = EAST

/obj/machinery/door/poddoor/multi_tile/three_tile_hor/
	icon = 'icons/obj/doors/1x3blast_hor.dmi'
	bound_width = 96
	dir = EAST

/obj/machinery/door/poddoor/multi_tile/two_tile_hor/
	icon = 'icons/obj/doors/1x2blast_hor.dmi'
	bound_width = 64
	dir = EAST