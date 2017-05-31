/obj/structure/wall_cabinet/extinguisher
	name = "extinguisher cabinet"
	desc = "A small wall mounted cabinet designed to hold a fire extinguisher."
	icon = 'icons/obj/wallmounts.dmi'
	icon_state = "extinguisher_closed"
	nick = "extinguisher"
	allowedContent = list(/obj/item/weapon/extinguisher)
	spawnContent = newlist(/obj/item/weapon/extinguisher)

/obj/structure/wall_cabinet/extinguisher/New(loc, ndir, building)			// This is a child of wall cabinet
	..()																	// Please look at /obj/structure/wall_cabinet to understand this code


/obj/item/wallframe/wall_cabinet/extinguisher
	name = "extinguisher cabinet frame"
	desc = "Used for building wall-mounted extinguisher cabinets."
	icon = 'icons/obj/wallmounts.dmi'
	icon_state = "extinguisher_frame"
	result_path = /obj/structure/wall_cabinet/extinguisher