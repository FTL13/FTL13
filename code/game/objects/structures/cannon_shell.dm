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
	desc = "The ejected thrust segement of the shell, the high yield thrust segment welded to the bottom of the shell is used to propel the shell for very long distances utilizing the thrusters onboard DRAM.DRAM is a type of dyanamic random access memory that allows for extremely flexible use of the Mac cannon no matter what operating system is synced to it and the shells onboard guidance systems. Some can confuse DRAM because a mirrored software is also embedded into the thrust segement known as DRAM, which is the Digital Rights Ammunition Management which is a universal software often utilized by corporations and governments as a fail-safe to prevent brigands and criminals from using them to enact crimes against defenseless planet colonies. Suffice to say this extremely advanced software is useless if the weapons console that controls the systems is compromised."
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

/obj/structure/shell/planet_killer
	name = "ARMAGEDDON SHELL (Planet-Killer)"
	desc = "The ARMAGEDDON SHELL is considered a planet killer type shell, once inside the atmosphere of the planet its exterior casing degrades from the heat igniting the volatile chemicals inside the bluespace beakers fixed within the shell, these beakers release a massive volume of liquid plasma, phlogiston, pyrosium, lexorin, fluorosulhpuric acid, thermite and polonium; all of these chemicals in combination shower the planets atmosphere with nuclear fallout which carries the other volatile chemicals down onto the planet not only extinguishing life but also eroding away any signs of civilization and leaving entire cities and/or settlements as empty scorched craters. The chemical reaction is so powerful that the sound of the chemicals reacting as they explode into a deadly cloud can be heard from the planets orbit."
	icon_state = "torpedo_pk"

	casing = /obj/item/weapon/twohanded/required/shell_casing/planet_killer

	attack_data = /datum/ship_attack/planet_killer

/obj/structure/shell/cannon_ball
	name = "cannon-ball"
	desc = "the Donk.Co branded cannon-ball is a favored type of ammunition among brigands and criminals alike, adapted from a primitive design the Donk. Co Cannonball is a surprisingly advanced form of ammunition that is relatively easy to make"
	icon_state = "torpedo_ball"

	casing = /obj/item/weapon/twohanded/required/shell_casing/cannon_ball

	attack_data = /datum/ship_attack/cannon_ball

/obj/item/weapon/twohanded/required/shell_casing/shield_piercing
	icon_state = "sp_casing"

/obj/item/weapon/twohanded/required/shell_casing/smart_homing
	icon_state = "sh_casing"

/obj/item/weapon/twohanded/required/shell_casing/planet_killer
	icon_state = "pk_casing"

/obj/item/weapon/twohanded/required/shell_casing/cannon_ball
	icon_state = "ball_casing"
