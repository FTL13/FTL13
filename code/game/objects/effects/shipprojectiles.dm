/obj/effect/overlay/temp/shipprojectile
	name = "Phase Cannon shot"
	desc = "HOLY FUCK GET TO COVER"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "emitter"
	luminosity = 5
	unacidable = 1
	duration = 5

/obj/effect/overlay/temp/ship_target
	icon = 'icons/mob/actions.dmi'
	icon_state = "sniper_zoom"
	layer = BELOW_MOB_LAYER
	duration = 5

/obj/effect/overlay/temp/ship_target/ex_act()
	return

/obj/effect/overlay/temp/shipprojectile/New(var/turf/T, var/datum/ship_attack/A)
	var/x = 0
	var/y = 0
	var/angle = 0
	var/rand_coord = rand(-1000,1000)
	var/list/rand_edge = list(1,-1)
	icon_state = A.projectile_effect

	if(prob(50))
		x = rand_coord
		y = pick(rand_edge) * 1000
	else
		x = pick(rand_edge) * 1000
		y = rand_coord

	angle = Atan2(0-x, 0-y)
	var/matrix/M = new
	M.Turn(angle)
	transform = M

	animate(src, pixel_x = 0, pixel_y = 0, time = 20)
	spawn(20)
	A.damage_effects(T) //boooom

/obj/effect/overlay/temp/ship_target/New(var/turf/T, var/datum/ship_attack/A)
	playsound(T, 'sound/effects/hit_warning.ogg',100,0)
	spawn(30)
	new /obj/effect/overlay/temp/shipprojectile(T, A)
	spawn(20)
