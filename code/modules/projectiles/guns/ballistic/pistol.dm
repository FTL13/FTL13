/obj/item/weapon/gun/ballistic/automatic/pistol
	name = "stechkin pistol"
	desc = "A small, easily concealable 10mm handgun. Has a threaded barrel for suppressors."
	icon_state = "pistol"
	w_class = WEIGHT_CLASS_SMALL
	origin_tech = "combat=3;materials=2;syndicate=4"
	mag_type = /obj/item/ammo_box/magazine/m10mm
	can_suppress = 1
	burst_size = 1
	fire_delay = 0
	actions_types = list()

/obj/item/weapon/gun/ballistic/automatic/pistol/update_icon()
	..()
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"][suppressed ? "-suppressed" : ""]"
	return

/obj/item/weapon/gun/ballistic/automatic/pistol/m1911
	name = "\improper M1911"
	desc = "A classic .45 handgun with a small magazine capacity."
	icon_state = "m1911"
	w_class = WEIGHT_CLASS_NORMAL
	mag_type = /obj/item/ammo_box/magazine/m45
	can_suppress = 0

/obj/item/weapon/gun/ballistic/automatic/pistol/deagle
	name = "desert eagle"
	desc = "A robust .50 AE handgun."
	icon_state = "deagle"
	force = 14
	mag_type = /obj/item/ammo_box/magazine/m50
	can_suppress = 0

/obj/item/weapon/gun/ballistic/automatic/pistol/deagle/update_icon()
	..()
	if(magazine)
		cut_overlays()
		add_overlay("deagle_magazine")
	else
		cut_overlays()
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"]"

/obj/item/weapon/gun/ballistic/automatic/pistol/deagle/gold
	desc = "A gold plated desert eagle folded over a million times by superior martian gunsmiths. Uses .50 AE ammo."
	icon_state = "deagleg"
	item_state = "deagleg"

/obj/item/weapon/gun/ballistic/automatic/pistol/deagle/camo
	desc = "A Deagle brand Deagle for operators operating operationally. Uses .50 AE ammo."
	icon_state = "deaglecamo"
	item_state = "deagleg"

/obj/item/weapon/gun/ballistic/automatic/pistol/APS
	name = "stechkin APS pistol"
	desc = "The original russian version of a widely used Syndicate sidearm. Uses 9mm ammo."
	icon_state = "aps"
	w_class = WEIGHT_CLASS_NORMAL
	origin_tech = "combat=3;materials=2;syndicate=3"
	mag_type = /obj/item/ammo_box/magazine/pistolm9mm
	can_suppress = 0
	burst_size = 3
	fire_delay = 2
	actions_types = list(/datum/action/item_action/toggle_firemode)

/obj/item/weapon/gun/ballistic/automatic/pistol/stickman
	name = "flat gun"
	desc = "A 2 dimensional gun.. what?"
	icon_state = "flatgun"
	origin_tech = "combat=3;materials=2;abductor=3"

/obj/item/weapon/gun/ballistic/automatic/pistol/stickman/pickup(mob/living/user)
	to_chat(user, "<span class='notice'>As you try to pick up [src], it slips out of your grip..</span>")
	if(prob(50))
		to_chat(user, "<span class='notice'>..and vanishes from your vision! Where the hell did it go?</span>")
		qdel(src)
		user.update_icons()
	else
		to_chat(user, "<span class='notice'>..and falls into view. Whew, that was a close one.</span>")
		user.dropItemToGround(src)

/obj/item/weapon/gun/ballistic/automatic/pistol/automag
	name = "Automag"
	desc = "A semi-automatic .44 AMP caliber handgun. A rare firearm generally only seen among the highest-ranking NanoTrasen officers. The caliber gives this weapon immense firepower in a fairly small size."
	icon_state = "automag"
	force = 10
	mag_type = /obj/item/ammo_box/magazine/m44
	can_suppress = 0
	w_class = 3
	fire_sound = 'sound/weapons/revolver_big.ogg'

/obj/item/weapon/gun/ballistic/automatic/pistol/automag/update_icon()
	..()
	icon_state = "automag[magazine ? "-[Ceiling(get_ammo(0)/7)*7]" : ""][chambered ? "" : "-e"]"
	return
/obj/item/weapon/gun/ballistic/automatic/pistol/c05r
	name = "C05-R"
	desc = "A replica of an old Russian handgun. This one however, is chambered to fire .45 ACP. Generally seen wielded by New-Russian soldiers."
	icon_state = "c05r"
	mag_type = /obj/item/ammo_box/magazine/c05r
	can_suppress = 0
	w_class = 3
	fire_sound = 'sound/weapons/pistol_glock17_1.ogg'

/obj/item/weapon/gun/ballistic/automatic/pistol/c05r/update_icon()
	..()
	icon_state = "[initial(icon_state)][magazine ? "" : "-e"]"

/obj/item/weapon/gun/ballistic/automatic/pistol/luger
	name = "P053M Luger"
	desc = "A modern take on an ancient weapon, this one is chambered in .357."
	icon_state = "p08"
	mag_type = /obj/item/ammo_box/magazine/luger
	can_suppress = 0
	w_class = 3
	fire_sound = 'sound/weapons/gunshot_beefy.ogg'

/obj/item/weapon/gun/ballistic/automatic/pistol/luger/update_icon()
	..()
	icon_state = "p08[magazine ? "-[Ceiling(get_ammo(0)/10)*10]" : ""][chambered ? "" : "-e"]"
	return