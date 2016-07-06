/obj/structure/torpedo
	name = "torpedo"
	desc = "A small shell designed to explode upon high-speed impact with solid objects."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "torpedo"
	density = 1

/obj/structure/torpedo/Bump(obstacle)
	if(throwing)
		explosion(get_turf(src), 1, 2, 6)
		throwing = 0
	..()