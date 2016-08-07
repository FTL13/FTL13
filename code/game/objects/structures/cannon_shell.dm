/obj/structure/shell
	name = "cannon shell"
	desc = "A large shell designed to explode upon high-speed impact with solid objects."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "torpedo"
	density = 1

	var/projectile = /obj/item/projectile/ship_projectile/mac_round
	var/casing = /obj/item/weapon/twohanded/required/shell_casing

	var/armed = 0

	var/damage = 5


/obj/structure/shell/attackby(obj/item/C,mob/user)
	if(istype(C,/obj/item/device/multitool))
		playsound(loc,'sound/weapons/empty.ogg',50,0)
		user.visible_message("<span class=notice>[user] toggles the arming mechanism on [src].</span>","<span class=notice>You toggle the arming mechanism on [src]</span>")
		toggle_arm()
/obj/structure/shell/proc/toggle_arm()
	armed = !armed

	update_state()

/obj/structure/shell/proc/update_state()
	if(armed) icon_state = "torpedo_armed"
	else icon_state = "torpedo"

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
