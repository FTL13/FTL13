/*
Ideas for the subtle effects of hallucination:

Light up oxygen/plasma indicators (done)
Cause health to look critical/dead, even when standing (done)
Characters silently watching you
Brief flashes of fire/space/bombs/c4/dangerous shit (done)
Items that are rare/traitorous/don't exist appearing in your inventory slots (done)
Strange audio (should be rare) (done)
Gunshots/explosions/opening doors/less rare audio (done)

*/

#define HAL_LINES_FILE "hallucination.json"

/mob/living/carbon
	var/image/halimage
	var/image/halbody
	var/obj/halitem
	var/hal_screwyhud = SCREWYHUD_NONE
	var/next_hallucination = 0

GLOBAL_LIST_INIT(hallucinations_minor, list(
	/datum/hallucination/sounds,
	/datum/hallucination/bolts,
	/datum/hallucination/whispers,
	/datum/hallucination/message,
	/datum/hallucination/hudscrew))

GLOBAL_LIST_INIT(hallucinations_medium, list(
	/datum/hallucination/fake_alert,
	/datum/hallucination/items,
	/datum/hallucination/items_other,
	/datum/hallucination/dangerflash,
	/datum/hallucination/bolts,
	/datum/hallucination/fake_flood,
	/datum/hallucination/husks,
	/datum/hallucination/battle,
	/datum/hallucination/fire,
	/datum/hallucination/self_delusion))

GLOBAL_LIST_INIT(hallucinations_major, list(
	/datum/hallucination/fakeattacker,
	/datum/hallucination/death,
	/datum/hallucination/xeno_attack,
	/datum/hallucination/singularity_scare,
	/datum/hallucination/delusion,
	/datum/hallucination/oh_yeah))

/mob/living/carbon/proc/handle_hallucinations()
	if(world.time < next_hallucination)
		return

	if(hallucination)
		var/list/current = GLOB.hallucinations_minor
		if(prob(25) && hallucination > 100)
			current = GLOB.hallucinations_medium
		else if(prob(10) && hallucination > 200)
			current = GLOB.hallucinations_major
		var/halpick = pick(current)
		new halpick(src, FALSE)

/mob/living/carbon/proc/set_screwyhud(hud_type)
	hal_screwyhud = hud_type
	update_health_hud()

/datum/hallucination
	var/mob/living/carbon/target
	var/cost = 5 //affects the amount of hallucination reduced, and cooldown until the next hallucination
	var/feedback_details //extra info for investigate

/datum/hallucination/New(mob/living/carbon/T, forced = TRUE)
	set waitfor = 0
	target = T
	if(!forced)
		target.hallucination = max(0, target.hallucination - cost)
		target.next_hallucination = world.time + (rand(cost * 0.5, cost * 3) * 10)

/datum/hallucination/proc/wake_and_restore()
	target.set_screwyhud(SCREWYHUD_NONE)
	target.SetSleeping(0)

/datum/hallucination/Destroy()
	target.investigate_log("was afflicted with a hallucination of type [type]. [feedback_details]", INVESTIGATE_HALLUCINATIONS)
	return ..()

/obj/effect/hallucination
	invisibility = INVISIBILITY_OBSERVER
	var/mob/living/carbon/target = null

/obj/effect/hallucination/simple
	var/image_icon = 'icons/mob/alien.dmi'
	var/image_state = "alienh_pounce"
	var/px = 0
	var/py = 0
	var/col_mod = null
	var/image/current_image = null
	var/image_layer = MOB_LAYER
	var/active = TRUE //qdelery

/obj/effect/hallucination/simple/Initialize(mapload, var/mob/living/carbon/T)
	..()
	target = T
	current_image = GetImage()
	if(target.client)
		target.client.images |= current_image

/obj/effect/hallucination/simple/proc/GetImage()
	var/image/I = image(image_icon,src,image_state,image_layer,dir=src.dir)
	I.pixel_x = px
	I.pixel_y = py
	if(col_mod)
		I.color = col_mod
	return I

/obj/effect/hallucination/simple/proc/Show(update=1)
	if(active)
		if(target.client)
			target.client.images.Remove(current_image)
		if(update)
			current_image = GetImage()
		if(target.client)
			target.client.images |= current_image

/obj/effect/hallucination/simple/update_icon(new_state,new_icon,new_px=0,new_py=0)
	image_state = new_state
	if(new_icon)
		image_icon = new_icon
	else
		image_icon = initial(image_icon)
	px = new_px
	py = new_py
	Show()

/obj/effect/hallucination/simple/Moved(atom/OldLoc, Dir)
	Show()

/obj/effect/hallucination/simple/Destroy()
	if(target.client)
		target.client.images.Remove(current_image)
	active = FALSE
	return ..()

#define FAKE_FLOOD_EXPAND_TIME 20
#define FAKE_FLOOD_MAX_RADIUS 10

/datum/hallucination/fake_flood
	//Plasma starts flooding from the nearby vent
	var/turf/center
	var/list/flood_images = list()
	var/list/turf/flood_turfs = list()
	var/image_icon = 'icons/effects/tile_effects.dmi'
	var/image_state = "plasma"
	var/radius = 0
	var/next_expand = 0
	cost = 25

/datum/hallucination/fake_flood/New(mob/living/carbon/T, forced = TRUE)
	..()
	for(var/obj/machinery/atmospherics/components/unary/vent_pump/U in orange(7,target))
		if(!U.welded)
			center = get_turf(U)
			break
	feedback_details += "Vent Coords: [center.x],[center.y],[center.z]"
	flood_images += image(image_icon,center,image_state,MOB_LAYER)
	flood_turfs += center
	if(target.client) target.client.images |= flood_images
	next_expand = world.time + FAKE_FLOOD_EXPAND_TIME
	START_PROCESSING(SSobj, src)

/datum/hallucination/fake_flood/process()
	if(next_expand <= world.time)
		radius++
		if(radius > FAKE_FLOOD_MAX_RADIUS)
			qdel(src)
			return
		Expand()
		if((get_turf(target) in flood_turfs) && !target.internal)
			new /datum/hallucination/fake_alert(target, TRUE, "tox_in_air")
		next_expand = world.time + FAKE_FLOOD_EXPAND_TIME

/datum/hallucination/fake_flood/proc/Expand()
	for(var/turf/FT in flood_turfs)
		for(var/dir in GLOB.cardinals)
			var/turf/T = get_step(FT, dir)
			if((T in flood_turfs) || !FT.CanAtmosPass(T))
				continue
			flood_images += image(image_icon,T,image_state,MOB_LAYER)
			flood_turfs += T
	if(target.client)
		target.client.images |= flood_images

/datum/hallucination/fake_flood/Destroy()
	STOP_PROCESSING(SSobj, src)
	qdel(flood_turfs)
	flood_turfs = list()
	if(target.client)
		target.client.images.Remove(flood_images)
	target = null
	qdel(flood_images)
	flood_images = list()
	return ..()

/obj/effect/hallucination/simple/xeno
	image_icon = 'icons/mob/alien.dmi'
	image_state = "alienh_pounce"

/obj/effect/hallucination/simple/xeno/Initialize(mapload, mob/living/carbon/T)
	..()
	name = "alien hunter ([rand(1, 1000)])"

/obj/effect/hallucination/simple/xeno/throw_impact(A)
	update_icon("alienh_pounce")
	if(A == target && target.stat!=DEAD)
		target.Knockdown(100)
		target.visible_message("<span class='danger'>[target] flails around wildly.</span>","<span class ='userdanger'>[name] pounces on you!</span>")

/datum/hallucination/xeno_attack
	//Xeno crawls from nearby vent,jumps at you, and goes back in
	var/obj/machinery/atmospherics/components/unary/vent_pump/pump = null
	var/obj/effect/hallucination/simple/xeno/xeno = null
	cost = 25

/datum/hallucination/xeno_attack/New(mob/living/carbon/T, forced = TRUE)
	..()
	for(var/obj/machinery/atmospherics/components/unary/vent_pump/U in orange(7,target))
		if(!U.welded)
			pump = U
			break
	feedback_details += "Vent Coords: [pump.x],[pump.y],[pump.z]"
	if(pump)
		xeno = new(pump.loc,target)
		sleep(10)
		xeno.update_icon("alienh_leap",'icons/mob/alienleap.dmi',-32,-32)
		xeno.throw_at(target,7,1, spin = 0, diagonals_first = 1)
		sleep(10)
		xeno.update_icon("alienh_leap",'icons/mob/alienleap.dmi',-32,-32)
		xeno.throw_at(pump,7,1, spin = 0, diagonals_first = 1)
		sleep(10)
		var/xeno_name = xeno.name
		to_chat(target, "<span class='notice'>[xeno_name] begins climbing into the ventilation system...</span>")
		sleep(30)
		qdel(xeno)
		to_chat(target, "<span class='notice'>[xeno_name] scrambles into the ventilation ducts!</span>")
	qdel(src)

/obj/effect/hallucination/simple/clown
	image_icon = 'icons/mob/animal.dmi'
	image_state = "clown"

/obj/effect/hallucination/simple/clown/Initialize(mapload, mob/living/carbon/T, duration)
	..(loc, T)
	name = pick(GLOB.clown_names)
	QDEL_IN(src,duration)

/obj/effect/hallucination/simple/clown/scary
	image_state = "scary_clown"

/obj/effect/hallucination/simple/bubblegum
	name = "Bubblegum"
	image_icon = 'icons/mob/lavaland/96x96megafauna.dmi'
	image_state = "bubblegum"
	px = -32

/datum/hallucination/oh_yeah
	var/obj/effect/hallucination/simple/bubblegum/bubblegum
	var/image/fakebroken
	var/image/fakerune
	cost = 75

/datum/hallucination/oh_yeah/New(mob/living/carbon/T, forced = TRUE)
	. = ..()
	var/turf/closed/wall/wall
	for(var/turf/closed/wall/W in range(7,target))
		wall = W
		break
	if(!wall)
		return INITIALIZE_HINT_QDEL
	feedback_details += "Source: [wall.x],[wall.y],[wall.z]"

	fakebroken = image('icons/turf/floors.dmi', wall, "plating", layer = TURF_LAYER)
	var/turf/landing = get_turf(target)
	var/turf/landing_image_turf = get_step(landing, SOUTHWEST) //the icon is 3x3
	fakerune = image('icons/effects/96x96.dmi', landing_image_turf, "landing", layer = ABOVE_OPEN_TURF_LAYER)
	fakebroken.override = TRUE
	if(target.client)
		target.client.images |= fakebroken
		target.client.images |= fakerune
	target.playsound_local(wall,'sound/effects/meteorimpact.ogg', 150, 1)
	bubblegum = new(wall, target)
	addtimer(CALLBACK(src, .proc/bubble_attack, landing), 10)

/datum/hallucination/oh_yeah/proc/bubble_attack(turf/landing)
	var/charged = FALSE //only get hit once
	while(get_turf(bubblegum) != landing && target && target.stat != DEAD)
		bubblegum.forceMove(get_step_towards(bubblegum, landing))
		bubblegum.setDir(get_dir(bubblegum, landing))
		target.playsound_local(get_turf(bubblegum), 'sound/effects/meteorimpact.ogg', 150, 1)
		shake_camera(target, 2, 1)
		if(bubblegum.Adjacent(target) && !charged)
			charged = TRUE
			target.Knockdown(80)
			target.adjustStaminaLoss(40)
			step_away(target, bubblegum)
			shake_camera(target, 4, 3)
			target.visible_message("<span class='warning'>[target] jumps backwards, falling on the ground!</span>","<span class='userdanger'>[bubblegum] slams into you!</span>")
		sleep(2)
	sleep(30)
	qdel(src)

/datum/hallucination/oh_yeah/Destroy()
	if(target.client)
		target.client.images.Remove(fakebroken)
		target.client.images.Remove(fakerune)
	QDEL_NULL(fakebroken)
	QDEL_NULL(fakerune)
	QDEL_NULL(bubblegum)
	return ..()

/datum/hallucination/singularity_scare
	//Singularity moving towards you.
	//todo Hide where it moved with fake space images
	var/obj/effect/hallucination/simple/singularity/s = null
	cost = 75

/datum/hallucination/singularity_scare/New(mob/living/carbon/T, forced = TRUE)
	..()
	var/turf/start = get_turf(T)
	var/screen_border = pick(SOUTH,EAST,WEST,NORTH)
	for(var/i in 1 to 13)
		start = get_step(start,screen_border)
	feedback_details += "Source: [start.x],[start.y],[start.z]"
	s = new(start,target)
	s.parent = src
	for(var/i in 1 to 13)
		sleep(10)
		s.forceMove(get_step(get_turf(s),get_dir(s,target)))
		s.Show()
		s.Eat()
	qdel(s)

/obj/effect/hallucination/simple/singularity
	image_icon = 'icons/effects/224x224.dmi'
	image_state = "singularity_s7"
	image_layer = MASSIVE_OBJ_LAYER
	px = -96
	py = -96
	var/datum/hallucination/singularity_scare/parent

/obj/effect/hallucination/simple/singularity/proc/Eat(atom/OldLoc, Dir)
	var/target_dist = get_dist(src,target)
	if(target_dist<=3) //"Eaten"
		target.set_screwyhud(SCREWYHUD_DEAD)
		target.SetUnconscious(160)
		addtimer(CALLBACK(parent, /datum/hallucination/.proc/wake_and_restore), rand(30, 50))

/datum/hallucination/battle
	cost = 15

/datum/hallucination/battle/New(mob/living/carbon/T, forced = TRUE, battle_type)
	..()
	var/hits = rand(3,6)
	if(!battle_type)
		battle_type = pick("laser","esword","gun","stunprod","bomb")
	feedback_details += "Type: [battle_type]"
	switch(battle_type)
		if("laser") //Laser fight
			for(var/i in 1 to hits)
				target.playsound_local(null, 'sound/weapons/laser.ogg', 25, 1)
				if(prob(50))
					addtimer(CALLBACK(target, /mob/.proc/playsound_local, null, 'sound/weapons/sear.ogg', 25, 1), rand(10,20))
				else
					addtimer(CALLBACK(target, /mob/.proc/playsound_local, null, 'sound/weapons/effects/searwall.ogg', 25, 1), rand(10,20))
				sleep(rand(CLICK_CD_RANGE, CLICK_CD_RANGE + 8))
			target.playsound_local(null, get_sfx("bodyfall"), 25, 1)
		if("esword") //Esword fight
			target.playsound_local(null, 'sound/weapons/saberon.ogg',15, 1)
			for(var/i=0,i<hits,i++)
				target.playsound_local(null, 'sound/weapons/blade1.ogg', 25, 1)
				sleep(rand(CLICK_CD_MELEE, CLICK_CD_MELEE + 8))
			target.playsound_local(null, get_sfx("bodyfall"), 25, 1)
			target.playsound_local(null, 'sound/weapons/saberoff.ogg', 15, 1)
		if("gun") //Gun fight
			for(var/i in 1 to hits)
				target.playsound_local(null, get_sfx("gunshot"), 25)
				if(prob(60))
					addtimer(CALLBACK(target, /mob/.proc/playsound_local, null, 'sound/weapons/pierce.ogg', 25, 1), rand(10,20))
				else
					addtimer(CALLBACK(target, /mob/.proc/playsound_local, null, "ricochet", 25, 1), rand(10,20))
				sleep(rand(CLICK_CD_RANGE, CLICK_CD_RANGE + 8))
			target.playsound_local(null, get_sfx("bodyfall"), 25, 1)
		if("stunprod") //Stunprod + cablecuff
			target.playsound_local(null, 'sound/weapons/egloves.ogg', 40, 1)
			target.playsound_local(null, get_sfx("bodyfall"), 25, 1)
			sleep(20)
			target.playsound_local(null, 'sound/weapons/cablecuff.ogg', 15, 1)
		if("bomb") // Tick Tock
			for(var/i in 1 to hits)
				target.playsound_local(null, 'sound/items/timer.ogg', 25, 0)
				sleep(15)
	qdel(src)

/datum/hallucination/items_other
	cost = 10

/datum/hallucination/items_other/New(mob/living/carbon/T, forced = TRUE, item_type)
	..()
	var/item
	if(!item_type)
		item = pick(list("esword","dual_esword","stunpaper","clockspear","ttv","flash","armblade"))
	else
		item = item_type
	feedback_details += "Item: [item]"
	var/image_file
	var/image/A = null
	for(var/mob/living/carbon/human/H in view(7,target))
		if(H != target)
			var/free_hand = H.get_empty_held_index_for_side(side = "left")
			if(free_hand)
				image_file = 'icons/mob/inhands/items_lefthand.dmi'
			else
				free_hand = H.get_empty_held_index_for_side(side = "right")
				if(free_hand)
					image_file = 'icons/mob/inhands/items_righthand.dmi'
			if(image_file)
				switch(item)
					if("esword")
						target.playsound_local(H, 'sound/weapons/saberon.ogg',35,1)
						A = image(image_file,H,"swordred", layer=ABOVE_MOB_LAYER)
					if("dual_esword")
						target.playsound_local(H, 'sound/weapons/saberon.ogg',35,1)
						A = image(image_file,H,"dualsaberred1", layer=ABOVE_MOB_LAYER)
					if("stunpaper")
						A = image(image_file,H,"paper", layer=ABOVE_MOB_LAYER)
						A.color = rgb(255,0,0)
					if("clockspear")
						A = image(image_file,H,"ratvarian_spear", layer=ABOVE_MOB_LAYER)
					if("ttv")
						A = image(image_file,H,"ttv", layer=ABOVE_MOB_LAYER)
					if("flash")
						A = image(image_file,H,"flashtool", layer=ABOVE_MOB_LAYER)
					if("armblade")
						A = image(image_file,H,"arm_blade", layer=ABOVE_MOB_LAYER)
				if(target.client)
					target.client.images |= A
					sleep(rand(150,250))
					if(item == "esword" || item == "dual_esword")
						target.playsound_local(H, 'sound/weapons/saberoff.ogg',35,1)
					target.client.images.Remove(A)
				break
	qdel(src)

/datum/hallucination/delusion
	var/list/image/delusions = list()
	cost = 50

/datum/hallucination/delusion/New(mob/living/carbon/T, forced, force_kind = null , duration = 300,skip_nearby = 1, custom_icon = null, custom_icon_file = null)
	. = ..()
	var/image/A = null
	var/kind = force_kind ? force_kind : pick("monkey","corgi","carp","skeleton","demon","zombie")
	feedback_details += "Type: [kind]"
	for(var/mob/living/carbon/human/H in GLOB.living_mob_list)
		if(H == target)
			continue
		if(skip_nearby && (H in view(target)))
			continue
		switch(kind)
			if("monkey")//Monkey
				A = image('icons/mob/monkey.dmi',H,"monkey1")
			if("carp")//Carp
				A = image('icons/mob/animal.dmi',H,"carp")
			if("corgi")//Corgi
				A = image('icons/mob/pets.dmi',H,"corgi")
			if("skeleton")//Skeletons
				A = image('icons/mob/human.dmi',H,"skeleton")
			if("zombie")//Zombies
				A = image('icons/mob/human.dmi',H,"zombie")
			if("demon")//Demon
				A = image('icons/mob/mob.dmi',H,"daemon")
			if("custom")
				A = image(custom_icon_file, H, custom_icon)
		A.override = 1
		if(target.client)
			delusions |= A
			target.client.images |= A
	QDEL_IN(src, duration)

/datum/hallucination/delusion/Destroy()
	for(var/image/I in delusions)
		if(target.client)
			target.client.images.Remove(I)
	return ..()

/datum/hallucination/self_delusion
	var/image/delusion
	cost = 40

/datum/hallucination/self_delusion/New(mob/living/carbon/T, forced, force_kind = null , duration = 300, custom_icon = null, custom_icon_file = null, wabbajack = TRUE) //set wabbajack to false if you want to use another fake source
	..()
	var/image/A = null
	var/kind = force_kind ? force_kind : pick("monkey","corgi","carp","skeleton","demon","zombie","robot")
	feedback_details += "Type: [kind]"
	switch(kind)
		if("monkey")//Monkey
			A = image('icons/mob/monkey.dmi',target,"monkey1")
		if("carp")//Carp
			A = image('icons/mob/animal.dmi',target,"carp")
		if("corgi")//Corgi
			A = image('icons/mob/pets.dmi',target,"corgi")
		if("skeleton")//Skeletons
			A = image('icons/mob/human.dmi',target,"skeleton")
		if("zombie")//Zombies
			A = image('icons/mob/human.dmi',target,"zombie")
		if("demon")//Demon
			A = image('icons/mob/mob.dmi',target,"daemon")
		if("robot")//Cyborg
			A = image('icons/mob/robots.dmi',target,"robot")
			target.playsound_local(target,'sound/voice/liveagain.ogg', 75, 1)
		if("custom")
			A = image(custom_icon_file, target, custom_icon)
	A.override = 1
	if(target.client)
		if(wabbajack)
			to_chat(target, "<span class='italics'>...wabbajack...wabbajack...</span>")
			target.playsound_local(target,'sound/magic/staff_change.ogg', 50, 1)
		delusion = A
		target.client.images |= A
	QDEL_IN(src, duration)

/datum/hallucination/self_delusion/Destroy()
	if(target.client)
		target.client.images.Remove(delusion)
	return ..()

/datum/hallucination/fakeattacker/New(mob/living/carbon/T, forced = TRUE)
	..()
	var/mob/living/carbon/human/clone = null
	var/clone_weapon = null

	for(var/mob/living/carbon/human/H in GLOB.living_mob_list)
		if(H.stat || H.lying)
			continue
		clone = H
		feedback_details += "Clone of: [H.real_name]"
		break

	if(!clone)
		return

	var/static/list/non_fakeattack_weapons = list(/obj/item/weapon/gun/ballistic, /obj/item/ammo_box/a357,\
	/obj/item/weapon/gun/energy/kinetic_accelerator/crossbow, /obj/item/weapon/melee/transforming/energy/sword/saber,\
	/obj/item/weapon/storage/box/syndicate, /obj/item/weapon/storage/box/emps,\
	/obj/item/weapon/cartridge/virus/syndicate, /obj/item/clothing/under/chameleon,\
	/obj/item/clothing/shoes/chameleon, /obj/item/weapon/card/id/syndicate,\
	/obj/item/clothing/mask/chameleon, /obj/item/clothing/glasses/thermal,\
	/obj/item/device/chameleon, /obj/item/weapon/card/emag,	/obj/item/weapon/grenade/plastic/x4,\
	/obj/item/weapon/storage/toolbox/syndicate, /obj/item/weapon/aiModule,\
	/obj/item/device/radio/headset/syndicate,	/obj/item/weapon/grenade/plastic/c4,\
	/obj/item/device/powersink, /obj/item/weapon/storage/box/syndie_kit,\
	/obj/item/toy/syndicateballoon, /obj/item/weapon/gun/energy/laser/captain,\
	/obj/item/weapon/hand_tele, /obj/item/weapon/construction/rcd, /obj/item/weapon/tank/jetpack,\
	/obj/item/clothing/under/rank/captain, /obj/item/device/aicard,\
	/obj/item/clothing/shoes/magboots, /obj/item/areaeditor/blueprints, /obj/item/weapon/disk/nuclear,\
	/obj/item/clothing/suit/space/nasavoid, /obj/item/weapon/tank)

	var/obj/effect/fake_attacker/F = new/obj/effect/fake_attacker(get_turf(target),target)

	for(var/obj/item/I in clone.held_items)
		if(!(locate(I) in non_fakeattack_weapons))
			clone_weapon = I.name
			F.weap = I

	F.name = clone.name
	F.my_target = target
	F.weapon_name = clone_weapon

	F.left = image(clone,dir = WEST)
	F.right = image(clone,dir = EAST)
	F.up = image(clone,dir = NORTH)
	F.down = image(clone,dir = SOUTH)

	F.updateimage()
	qdel(src)

/obj/effect/fake_attacker
	icon = null
	icon_state = null
	name = ""
	desc = ""
	density = FALSE
	anchored = TRUE
	opacity = 0
	var/mob/living/carbon/human/my_target = null
	var/weapon_name = null
	var/obj/item/weap = null
	var/image/stand_icon = null
	var/image/currentimage = null
	var/icon/base = null
	var/skin_tone
	var/mob/living/clone = null
	var/image/left
	var/image/right
	var/image/up
	var/collapse
	var/image/down

	max_integrity = 100

/obj/effect/fake_attacker/attackby(obj/item/weapon/P, mob/living/user, params)
	step_away(src,my_target,2)
	user.changeNext_move(CLICK_CD_MELEE)
	user.do_attack_animation(src)
	my_target.playsound_local(src, P.hitsound, 1)
	my_target.visible_message("<span class='danger'>[my_target] flails around wildly.</span>", \
							"<span class='danger'>[my_target] has attacked [src]!</span>")

	obj_integrity -= P.force

/obj/effect/fake_attacker/Crossed(mob/M, somenumber)
	if(M == my_target)
		step_away(src,my_target,2)
		if(prob(30))
			for(var/mob/O in oviewers(world.view , my_target))
				to_chat(O, "<span class='danger'>[my_target] stumbles around.</span>")

/obj/effect/fake_attacker/Initialize(mapload, mob/living/carbon/T)
	..()
	my_target = T
	QDEL_IN(src, 300)
	step_away(src,my_target,2)
	INVOKE_ASYNC(src, .proc/attack_loop)


/obj/effect/fake_attacker/proc/updateimage()
//	del src.currentimage
	if(src.dir == NORTH)
		del src.currentimage
		src.currentimage = new /image(up,src)
	else if(src.dir == SOUTH)
		del src.currentimage
		src.currentimage = new /image(down,src)
	else if(src.dir == EAST)
		del src.currentimage
		src.currentimage = new /image(right,src)
	else if(src.dir == WEST)
		del src.currentimage
		src.currentimage = new /image(left,src)
	to_chat(my_target, currentimage)


/obj/effect/fake_attacker/proc/attack_loop()
	while(1)
		sleep(rand(5,10))
		if(obj_integrity < 0 || my_target.stat)
			collapse()
			continue
		if(get_dist(src,my_target) > 1)
			src.setDir(get_dir(src,my_target))
			step_towards(src,my_target)
			updateimage()
		else
			if(prob(15))
				if(weapon_name)
					my_target.playsound_local(my_target, weap.hitsound, weap.get_clamped_volume(), 1)
					my_target.show_message("<span class='danger'>[src.name] has attacked [my_target] with [weapon_name]!</span>", 1)
					my_target.staminaloss += 30
					if(prob(20))
						my_target.blur_eyes(3)
					if(prob(33))
						if(!locate(/obj/effect/overlay) in my_target.loc)
							fake_blood(my_target)
				else
					my_target.playsound_local(my_target, pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg'), 25, 1)
					my_target.show_message("<span class='userdanger'>[src.name] has punched [my_target]!</span>", 1)
					my_target.staminaloss += 30
					if(prob(33))
						if(!locate(/obj/effect/overlay) in my_target.loc)
							fake_blood(my_target)

		if(prob(15))
			step_away(src,my_target,2)

/obj/effect/fake_attacker/proc/collapse()
	collapse = 1
	updateimage()
	qdel(src)

/obj/effect/fake_attacker/proc/fake_blood(mob/target)
	var/obj/effect/overlay/O = new/obj/effect/overlay(target.loc)
	O.name = "blood"
	var/image/I = image('icons/effects/blood.dmi',O,"floor[rand(1,7)]",O.dir,1)
	to_chat(target, I)
	QDEL_IN(O, 300)


/datum/hallucination/bolts
	var/list/doors = list()
	cost = 25

/datum/hallucination/bolts/New(mob/living/carbon/T, forced, door_number=-1) //-1 for severe, 1-2 for subtle
	..()
	var/image/I = null
	var/count = 0
	feedback_details += "Door amount: [door_number]"
	for(var/obj/machinery/door/airlock/A in range(7, target))
		if(count>door_number && door_number>0)
			break
		count++
		I = image(A.overlays_file, get_turf(A), "lights_bolts",layer=A.layer+0.1)
		doors += I
		if(target.client)
			target.client.images |= I
			target.playsound_local(get_turf(A), 'sound/machines/boltsdown.ogg',30,0,3)
		sleep(rand(6,12))
	sleep(100)
	for(var/image/B in doors)
		if(target.client)
			target.client.images.Remove(B)
			target.playsound_local(get_turf(B), 'sound/machines/boltsup.ogg',30,0,3)
		sleep(rand(6,12))
	qdel(src)

/datum/hallucination/whispers
	cost = 15

/datum/hallucination/whispers/New(mob/living/carbon/T, forced = TRUE)
	..()
	var/speak_messages = list("[pick("I'm watching you...","I know what you're doing","What are you hiding?","I saw that")]",\
	"[pick("","Hey, ","Hi ","Hello ","Wait, ","It's ")][target.first_name()]!",\
	"[pick("Get out","Go away","Fuck off","OUT!")]",\
	"[pick("Kchck-Chkck? Kchchck!","EEEeeeeEEEE","#@�*&�","H-hhhhh...")]",\
	"[pick("Did you hear that?","Did you see that?","What was that?")]",\
	"[pick("Hail Ratvar","Hail Nar'Sie","Viva!","[generate_code_phrase()]","Are you mr. [pick(GLOB.possible_changeling_IDs)]?")]",\
	"[pick("Why?","What?","Wait, what?","Wait","Hold on","Uh...")]",\
	"Give me that!",\
	"HELP[pick(""," ME"," HIM"," HER"," THEM")]!!",\
	"RUN!!",\
	"I'm infected, [pick("stay away","don't get close","be careful","help me","kill me")]")

	var/radio_messages = list("Set [target.first_name()] to arrest!",\
	"[pick("Captain","Hos","Cmo","Rd","Ce","Hop","Janitor","AI","Viro","Qm","[target.first_name()]")] is [pick("rogue","cult","clockcult","a revhead","a gang leader","a traitor","a ling","dead")]!",\
	"Help!",\
	"[pick("Cult", "Wizard", "Blob", "Ling", "Ops", "Swarmers", "Revenant", "Traitor", "Harm", "I hear flashing", "Help")] in [pick(GLOB.teleportlocs)][prob(50)?"!":"!!"]",\
	"Where's [target.first_name()]?"\
	,"[pick("C","Ai, c","Someone c","Rec")]all the shuttle!"\
	,"AI [pick("rogue", "is dead")]!!")

	var/list/mob/living/carbon/people = list()
	var/list/mob/living/carbon/person = null
	var/datum/language/understood_language = target.get_random_understood_language()
	for(var/mob/living/carbon/H in view(target))
		if(H == target)
			continue
		if(!person)
			person = H
		else
			if(get_dist(target,H)<get_dist(target,person))
				person = H
		people += H
	if(person) //Basic talk
		var/image/speech_overlay = image('icons/mob/talk.dmi', person, "default0", layer = ABOVE_MOB_LAYER)
		var/message = target.compose_message(person,understood_language,pick(speak_messages),null,person.get_spans())
		feedback_details += "Type: Talk, Source: [person.real_name], Message: [message]"
		to_chat(target, message)
		if(target.client)
			target.client.images |= speech_overlay
			sleep(30)
			target.client.images.Remove(speech_overlay)
	else // Radio talk
		var/list/humans = list()
		for(var/mob/living/carbon/human/H in GLOB.living_mob_list)
			humans += H
		person = pick(humans)
		to_chat(target, target.compose_message(person,understood_language,pick(radio_messages),"1459",person.get_spans()))
	qdel(src)

/obj/effect/hallucination/message

/obj/effect/hallucination/message/Initialize(mapload, var/mob/living/carbon/T)
	..()
	target = T
	var/chosen = pick("<span class='userdanger'>The light burns you!</span>", \
		"<span class='danger'>You don't feel like yourself.</span>", \
		"<span class='userdanger'>Unknown has punched [target]!</span>", \
		"<span class='notice'>You hear something squeezing through the ducts...</span>", \
		"<span class='notice'>You hear a distant scream.</span>", \
		"<span class='notice'>You feel invincible, nothing can hurt you!</span>", \
		"<span class='warning'>You feel a tiny prick!</span>", \
		"<B>[target]</B> sneezes.", \
		"<span class='warning'>You feel faint.</span>", \
		"<span class='noticealien'>You hear a strange, alien voice in your head...</span>[pick("Hiss","Ssss")]", \
		"<span class='notice'>You can see...everything!</span>")
	to_chat(target, chosen)
	qdel(src)

/mob/living/carbon/proc/hallucinate(hal_type, specific) // specific is used to specify a particular hallucination
	set waitfor = 0
	switch(hal_type)
		if("xeno")
			new /obj/effect/hallucination/xeno_attack(src.loc,src)
		if("singulo")
			new /obj/effect/hallucination/singularity_scare(src.loc,src)
		if("koolaid")
			new /obj/effect/hallucination/oh_yeah(src.loc,src)
		if("battle")
			new /obj/effect/hallucination/battle(src.loc,src)
		if("flood")
			new /obj/effect/hallucination/fake_flood(src.loc,src)
		if("delusion")
			new /obj/effect/hallucination/delusion(src.loc,src)
		if("self_delusion")
			new /obj/effect/hallucination/self_delusion(src.loc,src)
		if("fake")
			new /obj/effect/hallucination/fakeattacker(src.loc,src)
		if("bolts")
			new /obj/effect/hallucination/bolts(src.loc,src)
		if("bolts_minor")
			new /obj/effect/hallucination/bolts(src.loc,src,rand(1,2))
		if("whispers")
			new /obj/effect/hallucination/whispers(src.loc,src)
		if("message")
			new /obj/effect/hallucination/message(src.loc,src)
		if("items_other")
			new /obj/effect/hallucination/items_other(src.loc,src)
		if("sounds")
			//Strange audio
			//to_chat(src, "Strange Audio")
			switch(rand(1,20))
				if(1) playsound_local(null,'sound/machines/airlock.ogg', 15, 1)
				if(2)
					if(prob(50)) playsound_local(null,'sound/effects/explosion1.ogg', 50, 1)
					else playsound_local(null, 'sound/effects/explosion2.ogg', 50, 1)
				if(3) playsound_local(null, 'sound/effects/explosionfar.ogg', 50, 1)
				if(4) playsound_local(null, pick('sound/effects/glassbr1.ogg','sound/effects/glassbr2.ogg','sound/effects/glassbr3.ogg'), 50, 1)
				if(5)
					playsound_local(null, 'sound/weapons/ring.ogg', 35)
					sleep(15)
					playsound_local(null, 'sound/weapons/ring.ogg', 35)
					sleep(15)
					playsound_local(null, 'sound/weapons/ring.ogg', 35)
				if(6) playsound_local(null, 'sound/magic/summon_guns.ogg', 50, 1)
				if(7) playsound_local(null, 'sound/machines/alarm.ogg', 100, 0)
				if(8) playsound_local(null, 'sound/voice/bfreeze.ogg', 35, 0)
				if(9)
					//To make it more realistic, I added two gunshots (enough to kill)
					playsound_local(null, 'sound/weapons/gunshot.ogg', 25, 1)
					spawn(rand(10,30))
						playsound_local(null, 'sound/weapons/gunshot.ogg', 25, 1)
						sleep(rand(5,10))
						playsound_local(null, sound(get_sfx("bodyfall"), 25), 25, 1)
				if(10) playsound_local(null, 'sound/effects/pray_chaplain.ogg', 50)
				if(11)
					//Same as above, but with tasers.
					playsound_local(null, 'sound/weapons/taser.ogg', 25, 1)
					spawn(rand(10,30))
						playsound_local(null, 'sound/weapons/taser.ogg', 25, 1)
						sleep(rand(5,10))
						playsound_local(null, sound(get_sfx("bodyfall"), 25), 25, 1)
			//Rare audio
				if(12)
			//These sounds are (mostly) taken from Hidden: Source
					var/list/creepyasssounds = list('sound/effects/ghost.ogg', 'sound/effects/ghost2.ogg', 'sound/effects/heart_beat.ogg', 'sound/effects/screech.ogg',\
						'sound/hallucinations/behind_you1.ogg', 'sound/hallucinations/behind_you2.ogg', 'sound/hallucinations/far_noise.ogg', 'sound/hallucinations/growl1.ogg', 'sound/hallucinations/growl2.ogg',\
						'sound/hallucinations/growl3.ogg', 'sound/hallucinations/im_here1.ogg', 'sound/hallucinations/im_here2.ogg', 'sound/hallucinations/i_see_you1.ogg', 'sound/hallucinations/i_see_you2.ogg',\
						'sound/hallucinations/look_up1.ogg', 'sound/hallucinations/look_up2.ogg', 'sound/hallucinations/over_here1.ogg', 'sound/hallucinations/over_here2.ogg', 'sound/hallucinations/over_here3.ogg',\
						'sound/hallucinations/turn_around1.ogg', 'sound/hallucinations/turn_around2.ogg', 'sound/hallucinations/veryfar_noise.ogg', 'sound/hallucinations/wail.ogg')
					playsound_local(null, pick(creepyasssounds), 50, 1)
				if(13)
					playsound_local(null, 'sound/effects/ratvar_rises.ogg', 100)
					sleep(150)
					playsound_local(null, 'sound/effects/ratvar_reveal.ogg', 100)
				if(14)
					to_chat(src, "<h1 class='alert'>Priority Announcement</h1>")
					to_chat(src, "<br><br><span class='alert'>The Emergency Shuttle has docked with the ship. You have 3 minutes to board the Emergency Shuttle.</span><br><br>")
					playsound_local(null, 'sound/ai/shuttledock.ogg', 100)
				//Deconstructing a wall
				if(15)
					playsound_local(null, 'sound/items/welder.ogg', 15, 1)
					sleep(105)
					playsound_local(null, 'sound/items/welder2.ogg', 15, 1)
					sleep(15)
					playsound_local(null, 'sound/items/ratchet.ogg', 15, 1)
				//Hacking a door
				if(16)
					playsound_local(null, 'sound/items/screwdriver.ogg', 15, 1)
					sleep(rand(10,30))
					for(var/i = rand(1,3), i>0, i--)
						playsound_local(null, 'sound/weapons/empty.ogg', 15, 1)
						sleep(rand(10,30))
					playsound_local(null, 'sound/machines/airlockforced.ogg', 15, 1)
				if(17)
					playsound_local(null, 'sound/weapons/saberon.ogg',35,1)
				if(18)
					to_chat(src, "<h1 class='alert'>Biohazard Alert</h1>")
					to_chat(src, "<br><br><span class='alert'>Confirmed outbreak of level 5 biohazard aboard [station_name()]. All personnel must contain the outbreak.</span><br><br>")
					playsound_local(null, 'sound/ai/outbreak5.ogg')
				if(19) //Tesla loose!
					playsound_local(null, 'sound/magic/lightningbolt.ogg', 35, 1)
					sleep(20)
					playsound_local(null, 'sound/magic/lightningbolt.ogg', 65, 1)
					sleep(20)
					playsound_local(null, 'sound/magic/lightningbolt.ogg', 100, 1)
				if(20) //AI is doomsdaying!
					to_chat(src, "<h1 class='alert'>Anomaly Alert</h1>")
					to_chat(src, "<br><br><span class='alert'>Hostile runtimes detected in all ship systems, please deactivate your AI to prevent possible damage to its morality core.</span><br><br>")
					playsound_local(null, 'sound/ai/aimalf.ogg', 100)
		if("hudscrew")
			//Screwy HUD
			//to_chat(src, "Screwy HUD")
			hal_screwyhud = pick(SCREWYHUD_NONE,SCREWYHUD_CRIT,SCREWYHUD_DEAD,SCREWYHUD_HEALTHY)
			sleep(rand(100,250))
			hal_screwyhud = 0

		if("fake_alert")
			var/alert_type = pick("not_enough_oxy","not_enough_tox","not_enough_co2","too_much_oxy","too_much_co2","too_much_tox","newlaw","nutrition","charge","weightless","fire","locked","hacked","temp","pressure")
			if(specific)
				alert_type = specific
			switch(alert_type)
				if("not_enough_oxy")
					throw_alert("not_enough_oxy", /obj/screen/alert/not_enough_oxy, override = TRUE)
				if("not_enough_tox")
					throw_alert("not_enough_tox", /obj/screen/alert/not_enough_tox, override = TRUE)
				if("not_enough_co2")
					throw_alert("not_enough_co2", /obj/screen/alert/not_enough_co2, override = TRUE)
				if("too_much_oxy")
					throw_alert("too_much_oxy", /obj/screen/alert/too_much_oxy, override = TRUE)
				if("too_much_co2")
					throw_alert("too_much_co2", /obj/screen/alert/too_much_co2, override = TRUE)
				if("too_much_tox")
					throw_alert("too_much_tox", /obj/screen/alert/too_much_tox, override = TRUE)
				if("nutrition")
					if(prob(50))
						throw_alert("nutrition", /obj/screen/alert/fat, override = TRUE)
					else
						throw_alert("nutrition", /obj/screen/alert/starving, override = TRUE)
				if("weightless")
					throw_alert("weightless", /obj/screen/alert/weightless, override = TRUE)
				if("fire")
					throw_alert("fire", /obj/screen/alert/fire, override = TRUE)
				if("temp")
					if(prob(50))
						throw_alert("temp", /obj/screen/alert/hot, 3, override = TRUE)
					else
						throw_alert("temp", /obj/screen/alert/cold, 3, override = TRUE)
				if("pressure")
					if(prob(50))
						throw_alert("pressure", /obj/screen/alert/highpressure, 2, override = TRUE)
					else
						throw_alert("pressure", /obj/screen/alert/lowpressure, 2, override = TRUE)
				//BEEP BOOP I AM A ROBOT
				if("newlaw")
					throw_alert("newlaw", /obj/screen/alert/newlaw, override = TRUE)
				if("locked")
					throw_alert("locked", /obj/screen/alert/locked, override = TRUE)
				if("hacked")
					throw_alert("hacked", /obj/screen/alert/hacked, override = TRUE)
				if("charge")
					throw_alert("charge", /obj/screen/alert/emptycell, override = TRUE)
			sleep(rand(100,200))
			clear_alert(alert_type, clear_override = TRUE)

		if("items")
			//Strange items
			//to_chat(src, "Traitor Items")
			if(!halitem)
				halitem = new
				var/obj/item/l_hand = get_item_for_held_index(1)
				var/obj/item/r_hand = get_item_for_held_index(2)
				var/l = ui_hand_position(get_held_index_of_item(l_hand))
				var/r = ui_hand_position(get_held_index_of_item(r_hand))
				var/list/slots_free = list(l,r)
				if(l_hand) slots_free -= l
				if(r_hand) slots_free -= r
				if(ishuman(src))
					var/mob/living/carbon/human/H = src
					if(!H.belt) slots_free += ui_belt
					if(!H.l_store) slots_free += ui_storage1
					if(!H.r_store) slots_free += ui_storage2
				if(slots_free.len)
					halitem.screen_loc = pick(slots_free)
					halitem.layer = ABOVE_HUD_LAYER
					halitem.plane = ABOVE_HUD_PLANE
					switch(rand(1,6))
						if(1) //revolver
							halitem.icon = 'icons/obj/guns/projectile.dmi'
							halitem.icon_state = "revolver"
							halitem.name = "Revolver"
						if(2) //c4
							halitem.icon = 'icons/obj/grenade.dmi'
							halitem.icon_state = "plastic-explosive0"
							halitem.name = "Mysterious Package"
							if(prob(25))
								halitem.icon_state = "c4small_1"
						if(3) //sword
							halitem.icon = 'icons/obj/weapons.dmi'
							halitem.icon_state = "sword1"
							halitem.name = "Sword"
						if(4) //stun baton
							halitem.icon = 'icons/obj/weapons.dmi'
							halitem.icon_state = "stunbaton"
							halitem.name = "Stun Baton"
						if(5) //emag
							halitem.icon = 'icons/obj/card.dmi'
							halitem.icon_state = "emag"
							halitem.name = "Cryptographic Sequencer"
						if(6) //flashbang
							halitem.icon = 'icons/obj/grenade.dmi'
							halitem.icon_state = "flashbang1"
							halitem.name = "Flashbang"
					if(client) client.screen += halitem
					QDEL_IN(halitem, rand(100, 250))
		if("dangerflash")
			//Flashes of danger
			//to_chat(src, "Danger Flash")
			if(!halimage)
				var/list/possible_points = list()
				for(var/turf/open/floor/F in view(src,world.view))
					possible_points += F
				if(possible_points.len)
					var/turf/open/floor/target = pick(possible_points)

					switch(rand(1,4))
						if(1)
							//to_chat(src, "Space")
							halimage = image('icons/turf/space.dmi',target,"[rand(1,25)]",TURF_LAYER)
						if(2)
							//to_chat(src, "Lava")
							halimage = image('icons/turf/floors/lava.dmi',target,"smooth",TURF_LAYER)
						if(3)
							//to_chat(src, "Chasm")
							halimage = image('icons/turf/floors/Chasms.dmi',target,"smooth",TURF_LAYER)
						if(4)
							//to_chat(src, "C4")
							halimage = image('icons/obj/grenade.dmi',target,"plastic-explosive2",OBJ_LAYER+0.01)


					if(client) client.images += halimage
					sleep(rand(40,60)) //Only seen for a brief moment.
					if(client) client.images -= halimage
					halimage = null
		if("death")
			//Fake death
			hal_screwyhud = SCREWYHUD_DEAD
			SetUnconscious(400)
			var/area/area = get_area(src)
			to_chat(src, "<span class='deadsay'><b>[mind.name]</b> has died at <b>[area.name]</b>.</span>")
			if(prob(50))
				var/list/dead_people = list()
				for(var/mob/dead/observer/G in GLOB.player_list)
					dead_people += G
				var/mob/dead/observer/fakemob = pick(dead_people)
				if(fakemob)
					sleep(rand(30, 60))
					to_chat(src, "<span class='deadsay'><b>DEAD: [fakemob.name]</b> says, \"[pick("rip","welcome [first_name()]","you too?","is the AI malf?",\
					 "i[prob(50)?" fucking":""] hate [pick("blood cult", "clock cult", "revenants", "abductors","double agents","viruses","badmins","you")]")]\"</span>")
			sleep(rand(50,70))
			hal_screwyhud = SCREWYHUD_NONE
			SetSleeping(0)
		if("husks")
			if(!halbody)
				var/list/possible_points = list()
				for(var/turf/open/floor/F in view(src,world.view))
					possible_points += F
				if(possible_points.len)
					var/turf/open/floor/target = pick(possible_points)
					switch(rand(1,4))
						if(1)
							var/image/body = image('icons/mob/human.dmi',target,"husk",TURF_LAYER)
							var/matrix/M = matrix()
							M.Turn(90)
							body.transform = M
							halbody = body
						if(2,3)
							halbody = image('icons/mob/human.dmi',target,"husk",TURF_LAYER)
						if(4)
							halbody = image('icons/mob/alien.dmi',target,"alienother",TURF_LAYER)

					if(client) client.images += halbody
					spawn(rand(30,50)) //Only seen for a brief moment.
						if(client) client.images -= halbody
						halbody = null
