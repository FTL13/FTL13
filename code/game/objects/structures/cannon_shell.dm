/obj/structure/shell
	name = "cannon shell (High Explosive)"
	desc = "A large shell designed to deliver a high-yield warhead upon high-speed impact with solid objects."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "torpedo"
	density = 1
	layer = 3.2

	var/projectile = /obj/item/projectile/ship_projectile/mac_round
	var/casing = /obj/item/weapon/twohanded/required/shell_casing

	var/datum/ship_attack/attack_data = /datum/ship_attack/ballistic

	var/armed = 0


/obj/structure/shell/attackby(obj/item/C,mob/user)
	if(istype(C,/obj/item/device/multitool))
		playsound(loc,'sound/weapons/empty.ogg',50,0)
		user.visible_message("<span class=notice>[user] toggles the arming mechanism on [src].</span>","<span class=notice>You toggle the arming mechanism on [src]</span>")
		toggle_arm()

/obj/structure/shell/proc/toggle_arm()
	armed = !armed

	update_state()

/obj/structure/shell/proc/update_state()
	if(armed) icon_state = "[icon_state]_armed"
	else icon_state = initial(icon_state)

/obj/structure/shell/Bump(obstacle)
	if(throwing && armed)
		explosion(get_turf(src), 1, 2, 6)
		throwing = 0
	..()

/obj/item/weapon/twohanded/required/shell_casing
	name = "cannon shell casing"
	desc = "The ejected casing from a cannon shell. Not very useful."
	icon = 'icons/obj/stationobjs.dmi' //for simplicity
	icon_state = "casing"
	item_state = "casing"

	w_class = 4

	force = 10
	throwforce = 80

	force_unwielded = 10
	force_wielded = 10


/obj/item/weapon/twohanded/required/shell_casing/New()
	..()
	pixel_x = rand(-5,15)
	pixel_y = rand(-15,15)

/obj/item/weapon/twohanded/required/shell_casing/Bump()
	..()
	throwforce = 10 //wow this is hacky, makes the shell only do 80 damage when ejected

/obj/structure/shell/shield_piercing
	name = "cannon shell (Shield Piercing)"
	desc = "A large shell containing bluespace disrupter technology that is designed to phase through shields. Delivers a low-yield warhead upon impact."
	icon_state = "torpedo_sp"

	casing = /obj/item/weapon/twohanded/required/shell_casing/shield_piercing

	attack_data = /datum/ship_attack/shield_buster

/obj/structure/shell/smart_homing
	name = "cannon shell (Smart Homing)"
	desc = "A large shell designed with maneuvering jets and a targeting computer integrated into the sabot to allow for course corrections during flight. Delivers a medium-yield warhead upon impact."
	icon_state = "torpedo_sh"

	casing = /obj/item/weapon/twohanded/required/shell_casing/smart_homing

	attack_data = /datum/ship_attack/homing

/obj/item/weapon/twohanded/required/shell_casing/shield_piercing
	icon_state = "sp_casing"

/obj/item/weapon/twohanded/required/shell_casing/smart_homing
	icon_state = "sh_casing"