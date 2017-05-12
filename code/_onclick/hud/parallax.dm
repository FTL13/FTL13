/client
	var/list/parallax_layers
	var/list/parallax_layers_cached


	var/atom/movable/movingmob
	var/turf/previous_turf
	var/dont_animate_parallax //world.time of when we can state animate()ing parallax again
	var/last_parallax_shift //world.time of last update
	var/parallax_throttle = 0 //ds between updates
	var/parallax_movedir = 0
	var/parallax_layers_max = 3
	var/parallax_animate_timer

/datum/hud/proc/create_parallax(mob/viewmob)
	var/mob/screenmob = viewmob || mymob
	var/client/C = screenmob.client
	if (!apply_parallax_pref(viewmob)) //don't want shit computers to crash when specing someone with insane parallax, so use the viewer's pref
		return








	if(!length(C.parallax_layers_cached))
		C.parallax_layers_cached = list()
		C.parallax_layers_cached += new /obj/screen/parallax_layer/layer_1(null, C.view)
		C.parallax_layers_cached += new /obj/screen/parallax_layer/layer_2(null, C.view)

	C.parallax_layers = C.parallax_layers_cached.Copy()

	if (length(C.parallax_layers) > C.parallax_layers_max)
		C.parallax_layers.len = C.parallax_layers_max

	C.screen |= (C.parallax_layers)
	var/obj/screen/plane_master/PM = screenmob.hud_used.plane_masters["[PLANE_SPACE]"]
	if(screenmob != mymob)
		C.screen -= locate(/obj/screen/plane_master/parallax_white) in C.screen
		C.screen += PM
	PM.color = list(
		0, 0, 0, 0,
		0, 0, 0, 0,
		0, 0, 0, 0,
		1, 1, 1, 1,
		0, 0, 0, 0
		)


/datum/hud/proc/remove_parallax(mob/viewmob)
	var/mob/screenmob = viewmob || mymob
	var/client/C = screenmob.client
	C.screen -= (C.parallax_layers_cached)
	var/obj/screen/plane_master/PM = screenmob.hud_used.plane_masters["[PLANE_SPACE]"]
	if(screenmob != mymob)
		C.screen -= locate(/obj/screen/plane_master/parallax_white) in C.screen
		C.screen += PM
	PM.color = initial(PM.color)
	C.parallax_layers = null

/datum/hud/proc/apply_parallax_pref(mob/viewmob)
	var/mob/screenmob = viewmob || mymob
	var/client/C = screenmob.client
	if(C.prefs)
		var/pref = C.prefs.parallax
		if (isnull(pref))
			pref = PARALLAX_HIGH
			if (C.byond_version < 511)
				pref = PARALLAX_DISABLE
		switch(C.prefs.parallax)
			if (PARALLAX_INSANE)
				C.parallax_throttle = FALSE
				C.parallax_layers_max = 4
				return TRUE

			if (PARALLAX_MED)
				C.parallax_throttle = PARALLAX_DELAY_MED
				C.parallax_layers_max = 2
				return TRUE

			if (PARALLAX_LOW)
				C.parallax_throttle = PARALLAX_DELAY_LOW
				C.parallax_layers_max = 1
				return TRUE

			if (PARALLAX_DISABLE)
				return FALSE

	C.parallax_throttle = PARALLAX_DELAY_DEFAULT
	C.parallax_layers_max = 3
	return TRUE

/datum/hud/proc/update_parallax_pref(mob/viewmob)
	remove_parallax(viewmob)
	create_parallax(viewmob)

// This sets which way the current shuttle is moving (returns true if the shuttle has stopped moving so the caller can append their animation)
/datum/hud/proc/set_parallax_movedir(new_parallax_movedir, skip_windups)
	. = FALSE
	var/client/C = mymob.client
	if(new_parallax_movedir == C.parallax_movedir)
		return
	var/animatedir = new_parallax_movedir
	if(new_parallax_movedir == FALSE)
		var/animate_time = 0
		for(var/thing in C.parallax_layers)
			var/obj/screen/parallax_layer/L = thing

			L.icon_state = initial(L.icon_state)
			L.update_o(C.view)
			var/T = PARALLAX_LOOP_TIME / L.speed
			if (T > animate_time)
				animate_time = T
		C.dont_animate_parallax = world.time + min(animate_time, PARALLAX_LOOP_TIME)
		animatedir = C.parallax_movedir
		update_parallax_planet()

	else
		set_parallax_planet()








	var/matrix/newtransform
	switch(animatedir)
		if(NORTH)
			newtransform = matrix(1, 0, 0, 0, 1, 480)
		if(SOUTH)
			newtransform = matrix(1, 0, 0, 0, 1,-480)
		if(EAST)
			newtransform = matrix(1, 0, 480, 0, 1, 0)
		if(WEST)
			newtransform = matrix(1, 0,-480, 0, 1, 0)

	var/shortesttimer
	if(!skip_windups)
		for(var/thing in C.parallax_layers)
			var/obj/screen/parallax_layer/L = thing

			var/T = PARALLAX_LOOP_TIME / L.speed
			if (isnull(shortesttimer))
				shortesttimer = T
			if (T < shortesttimer)
				shortesttimer = T
			L.transform = newtransform
			animate(L, transform = matrix(), time = T, easing = QUAD_EASING | (new_parallax_movedir ? EASE_IN : EASE_OUT), flags = ANIMATION_END_NOW)
			if (new_parallax_movedir)
				L.transform = newtransform
				animate(transform = matrix(), time = T) //queue up another animate so lag doesn't create a shutter

	C.parallax_movedir = new_parallax_movedir
	if (C.parallax_animate_timer)
		deltimer(C.parallax_animate_timer)
	var/datum/callback/CB = CALLBACK(src, .proc/update_parallax_motionblur, C, animatedir, new_parallax_movedir, newtransform)
	if(skip_windups)
		CB.Invoke()
	else
		C.parallax_animate_timer = addtimer(CB, min(shortesttimer, PARALLAX_LOOP_TIME), TIMER_CLIENT_TIME|TIMER_STOPPABLE)


/datum/hud/proc/update_parallax_motionblur(client/C, animatedir, new_parallax_movedir, matrix/newtransform)
	C.parallax_animate_timer = FALSE
	for(var/thing in C.parallax_layers)
		var/obj/screen/parallax_layer/L = thing
		if (!new_parallax_movedir)
			animate(L)
			continue

		var/newstate = initial(L.icon_state)
		if (animatedir)
			if(animatedir == NORTH || animatedir == SOUTH)
				newstate += "_vertical"
			else
				newstate += "_horizontal"

		var/T = PARALLAX_LOOP_TIME / L.speed

		if (newstate in icon_states(L.icon))
			L.icon_state = newstate
			L.update_o(C.view)

		L.transform = newtransform

		animate(L, transform = matrix(), time = T, loop = -1, flags = ANIMATION_END_NOW)

/datum/hud/proc/update_parallax()
	var/client/C = mymob.client

	var/turf/posobj = get_turf(C.eye)
	var/area/areaobj = posobj.loc


	// Update the movement direction of the parallax if necessary (for shuttles)
	set_parallax_movedir(areaobj.parallax_movedir, FALSE)

	var/force
	if(!C.previous_turf || (C.previous_turf.z != posobj.z))
		C.previous_turf = posobj
		force = TRUE

		update_parallax_planet()

	if (!force && world.time < C.last_parallax_shift+C.parallax_throttle)
		return

	//Doing it this way prevents parallax layers from "jumping" when you change Z-Levels.
	var/offset_x = posobj.x - C.previous_turf.x
	var/offset_y = posobj.y - C.previous_turf.y

	C.previous_turf = posobj

	var/last_delay = 2
	if(offset_x != 0 || offset_y != 0)
		var/world_time = world.time
		last_delay = world_time - C.last_parallax_shift
		last_delay = min(last_delay, 2)
		C.last_parallax_shift = world_time

	for(var/obj/screen/parallax_layer/L in C.parallax_layers)
		if(L.absolute)
			L.offset_x = -(posobj.x - 128) * L.speed
			L.offset_y = -(posobj.y - 128) * L.speed
		else
			L.offset_x -= offset_x * L.speed
			L.offset_y -= offset_y * L.speed

			if(C.looping_mode == 0)
				if(L.offset_x > 240)
					L.offset_x -= 480
				if(L.offset_x < -240)
					L.offset_x += 480
				if(L.offset_y > 240)
					L.offset_y -= 480
				if(L.offset_y < -240)
					L.offset_y += 480
			else if(C.looping_mode == 1)
				if(L.offset_x > 0)
					L.offset_x -= 480
				if(L.offset_x < -480)
					L.offset_x += 480
				if(L.offset_y > 0)
					L.offset_y -= 480
				if(L.offset_y < -480)
					L.offset_y += 480
			else if(C.looping_mode == 2)
				if(L.offset_x >= 480)
					L.offset_x -= 480
				if(L.offset_x < 0)
					L.offset_x += 480
				if(L.offset_y >= 480)
					L.offset_y -= 480
				if(L.offset_y < 0)
					L.offset_y += 480

		if(C.do_smoothing && (offset_x != 0 || offset_y != 0) && (offset_x == 1 || offset_x == -1 || offset_y == 1 || offset_y == -1))
			L.transform = matrix(1, 0, offset_x*L.speed, 0, 1, offset_y*L.speed)
			animate(L, transform=matrix(), time = last_delay, flags = ANIMATION_END_NOW)

		L.screen_loc = "CENTER-7:[L.offset_x],CENTER-7:[L.offset_y]"

// Plays the launch animation for parallax
/datum/hud/proc/parallax_launch_anim(dir = 4, slowing = 0)
	update_parallax_planet()
	var/client/C = mymob.client
	C.do_smoothing = 0
	if(dir == 4 || dir == 1)
		C.looping_mode = 1
	else
		C.looping_mode = 2
	for(var/obj/screen/parallax_layer/L in C.parallax_layers)
		var/M = L.speed * 240
		var/O = -480 + M
		if(L.absolute)
			var/matrix/new_transform
			var/D = slowing ? -1 : 1
			switch(dir)
				if(1)
					new_transform = matrix(1, 0,   0, 0, 1,-M*D)
				if(2)
					new_transform = matrix(1, 0,   0, 0, 1, M*D)
				if(4)
					new_transform = matrix(1, 0,-M*D, 0, 1, 0  )
				if(8)
					new_transform = matrix(1, 0, M*D, 0, 1, 0  )
			if(slowing)
				L.transform = new_transform
				animate(L, transform = matrix(), time = 50, easing = QUAD_EASING | (slowing ? EASE_OUT : EASE_IN), flags = ANIMATION_END_NOW)
			else
				L.transform = matrix()
				animate(L, transform = new_transform, time = 50, easing = QUAD_EASING | (slowing ? EASE_OUT : EASE_IN), flags = ANIMATION_END_NOW)
		else
			switch(dir)
				if(1)
					L.transform = matrix(1, 0, 0, 0, 1, M)
					L.offset_y += O
				if(2)
					L.transform = matrix(1, 0, 0, 0, 1,-M)
					L.offset_y -= O
				if(4)
					L.transform = matrix(1, 0, M, 0, 1, 0)
					L.offset_x += O
				if(8)
					L.transform = matrix(1, 0,-M, 0, 1, 0)
					L.offset_x -= O
			update_parallax() // Adjust the layers, they should all now be in the appropriate corner.
			animate(L, transform = matrix(), time = 50, easing = QUAD_EASING | (slowing ? EASE_OUT : EASE_IN), flags = ANIMATION_END_NOW)
	spawn(50)
		if(slowing)
			C.do_smoothing = 1


// Helper global procs for performing shuttle animations
/proc/parallax_launch_in_areas(areatype, dir = 4, slowing = 0)
	for(var/mob/M in GLOB.mob_list)
		if(M.client && M.hud_used && istype(get_area(M), areatype))
			M.hud_used.parallax_launch_anim(dir, slowing)

/proc/parallax_movedir_in_areas(areatype, dir = 4)
	for(var/area/shuttle/A in world)
		if(!istype(A, areatype))
			continue
		A.parallax_movedir = dir
	for(var/mob/M in GLOB.mob_list)
		if(M.client && M.hud_used && istype(get_area(M), areatype))
			M.hud_used.update_parallax()

/datum/hud/proc/update_parallax_movingmob()
	var/client/C = mymob.client
	var/atom/movable/A = C.eye
	if(!A)
		return
	while(istype(A.loc, /atom/movable))
		A = A.loc
	if(A != C.movingmob)
		if(C.movingmob != null)
			C.movingmob.mobs_in_contents -= C.mob
		A.mobs_in_contents += C.mob
		C.movingmob = A

/datum/hud/proc/set_parallax_planet(var/datum/planet/P)
	var/client/C = mymob.client
	if(C.parallax_planet_layer)
		if(C.parallax_planet_layer.planet == P)
			return
		C.parallax_layers -= C.parallax_planet_layer
		C.screen -= C.parallax_planet_layer
		C.parallax_planet_layer = null
	if(istype(P))
		C.parallax_planet_layer = new(P)
		C.screen += C.parallax_planet_layer
		C.parallax_layers += C.parallax_planet_layer

/datum/hud/proc/update_parallax_planet()
	var/client/C = mymob.client
	if(C.parallax_movedir)
		set_parallax_planet()
		return
	var/z = "[mymob.z]"
	var/datum/planet/P = SSmapping.z_level_alloc[z]
	set_parallax_planet(P)

/atom/movable/proc/update_parallax_contents()
	if(client_mobs_in_contents.len) // This is 5x faster if the list is empty, which it is 99% of the time
		for(var/mob/M in client_mobs_in_contents)
			if(M.client && M.hud_used)
				M.hud_used.update_parallax()

/obj/screen/parallax_layer
	icon = 'icons/mob/parallax.dmi'
	var/speed = 1
	var/offset_x = 0
	var/offset_y = 0
	var/absolute = 0
	blend_mode = BLEND_ADD
	plane = PLANE_SPACE_PARALLAX
	screen_loc = "CENTER-7,CENTER-7"
	mouse_opacity = 0

/obj/screen/parallax_layer/New()
	..()
	update_o()

/obj/screen/parallax_layer/proc/update_o()
	var/list/new_overlays = list()
	for(var/x in -1 to 1)
		for(var/y in -1 to 1)
			if(x == 0 && y == 0)
				continue
			var/image/I = image(icon, null, icon_state)
			I.transform = matrix(1, 0, x*480, 0, 1, y*480)
			new_overlays += I

	overlays = new_overlays

/obj/screen/parallax_layer/layer_1
	icon_state = "layer1"
	speed = 1
	layer = 10
	blend_mode = BLEND_OVERLAY

/obj/screen/parallax_layer/layer_2
	icon_state = "layer2"
	speed = 2
	layer = 20

/obj/screen/parallax_layer/planet
	speed = 3
	layer = 30
	absolute = 1
	blend_mode = BLEND_OVERLAY
	icon_state = ""
	var/datum/planet/planet

/obj/screen/parallax_layer/planet/update_o()
	return // This is an absolute-positioned

/obj/screen/parallax_layer/planet/New(datum/planet/P)
	planet = P
	var/list/new_overlays = list()
	for(var/L in planet.icon_layers)
		var/image/I = image(icon = 'icons/mob/parallax.dmi', icon_state = L)
		if(planet.icon_layers[L])
			I.color = planet.icon_layers[L]
		new_overlays += I
	overlays = new_overlays

/obj/screen/parallax_pmaster
	appearance_flags = PLANE_MASTER
	plane = PLANE_SPACE_PARALLAX
	blend_mode = BLEND_MULTIPLY
	mouse_opacity = 0
	screen_loc = "CENTER-7,CENTER-7"

/obj/screen/parallax_space_whitifier
	appearance_flags = PLANE_MASTER
	plane = PLANE_SPACE
	color = list(
		0, 0, 0, 0,
		0, 0, 0, 0,
		0, 0, 0, 0,
		1, 1, 1, 1,
		0, 0, 0, 0
		)
	screen_loc = "CENTER-7,CENTER-7"
