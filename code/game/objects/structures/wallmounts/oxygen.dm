/obj/structure/wall_cabinet/oxygen
	name = "oxygen cabinet"
	desc = "A small wall mounted cabinet designed to hold a breath mask and an emergency oxygen tank."
	icon = 'icons/obj/wallmounts.dmi'
	icon_state = "oxygen"
	capacity = 2
	exclusivity = 1
	allowedContent = list(/obj/item/weapon/tank/internals/emergency_oxygen, /obj/item/clothing/mask/breath)
	spawnContent = newlist(/obj/item/weapon/tank/internals/emergency_oxygen, /obj/item/clothing/mask/breath)


																	// This is a child of wall cabinet
																	// Please look at /obj/structure/wall_cabinet to understand this code


/obj/structure/wall_cabinet/oxygen/update_icon()					// Overrides update_icon() because of special naming system requiring more different states
	cut_overlays()													// Files are named "oxygen_tank" and "oxygen_mask" for overlays
	if(..())
		if(findContent(new/obj/item/weapon/tank/internals/emergency_oxygen))
			add_overlay("[initial(icon_state)]_tank")
		if(findContent(new/obj/item/clothing/mask/breath))
			add_overlay("[initial(icon_state)]_mask")


/obj/item/wallframe/wall_cabinet/oxygen
	name = "oxygen cabinet frame"
	desc = "Used for building wall-mounted oxygen cabinets."
	icon = 'icons/obj/wallmounts.dmi'
	icon_state = "oxygen_frame"
	result_path = /obj/structure/wall_cabinet/oxygen