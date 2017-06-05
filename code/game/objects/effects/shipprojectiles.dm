/obj/effect/temp_visual/shipprojectile
	name = "Phase Cannon shot"
	desc = "HOLY FUCK GET TO COVER"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "emitter"
	luminosity = 5
	duration = 5

/obj/effect/temp_visual/ship_target
	icon = 'icons/effects/target.dmi'
	icon_state = "target"
	layer = BELOW_MOB_LAYER
	duration = 5

/obj/effect/temp_visual/ship_target/ex_act()
	return

/obj/effect/temp_visual/shipprojectile/New(var/turf/T, var/datum/ship_attack/A)
	var/angle = 0
	var/rand_coord = rand(-1000,1000)
	var/list/rand_edge = list(1,-1)
	icon_state = A.projectile_effect

	if(prob(50)) // gets random location at the edge of a box
		pixel_x = rand_coord
		pixel_y = pick(rand_edge) * 1000
	else
		pixel_x = pick(rand_edge) * 1000
		pixel_y = rand_coord

	angle = Atan2(0-pixel_y, 0-pixel_x)

	var/matrix/M = new
	M.Turn(angle + 180)
	transform = M //rotates projectile in direction

	animate(src, pixel_x = 0, pixel_y = 0, time = 20)
	spawn(20)
		A.damage_effects(T) //boooom
		layer = 0.1 //to prevent it from being seen while we wait for it to be deleted
		qdel(src)

/obj/effect/temp_visual/ship_target/New(var/turf/T, var/datum/ship_attack/A)
	playsound(T, 'sound/effects/hit_warning.ogg',100,0)
	spawn(30)
		new /obj/effect/temp_visual/shipprojectile(T, A) //spawns the projectile after 3 seconds
	spawn(50)
		layer = 0.1 //to prevent it from being seen while we wait for it to be deleted
		qdel(src)
