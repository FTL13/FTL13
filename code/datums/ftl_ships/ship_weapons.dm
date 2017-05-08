/datum/ship_attack
	var/cname = "Ship Attack"

	var/hull_damage = 0
	var/shield_bust = 0
	var/evasion_mod = 1

	var/fire_attack = 0 //TODO: Code fire damage for enemy ships
	var/emp_attack = 0


/datum/ship_attack/proc/damage_effects(var/turf/epicenter)
	return


/datum/ship_attack/laser
	cname = "phase cannon"

	hull_damage = 1

/datum/ship_attack/laser/damage_effects(epicenter)
	explosion(epicenter,1,3,5,10)

/datum/ship_attack/ballistic
	cname = "mac cannon"

	hull_damage = 5

/datum/ship_attack/ballistic/damage_effects(epicenter)
	var/clusters = list()
	for(var/turf/T in range(epicenter,6))
		if(istype(T))
			clusters += T
	for(var/i in 1 to rand(3,5))
		explosion(pick(clusters),max(0,rand(-4,1)),1,rand(3,6))
		sleep(rand(5,10))



/datum/ship_attack/shield_buster
	cname = "mac-sp"

	hull_damage = 1
	shield_bust = 1

/datum/ship_attack/homing
	cname = "mac-sh"

	hull_damage = 3
	evasion_mod = 0.5

//enemy only attacks

/datum/ship_attack/chaingun
	cname = "chaingun"

	hull_damage = 5
	evasion_mod = 0.75

/datum/ship_attack/chaingun/damage_effects(turf/epicenter)
	var/turf/sample_T
	for(var/turf/T in range(5,epicenter))
		if(istype(T))
			sample_T = T
	var/dx = sample_T.x - epicenter.x //get da slope
	var/dy = sample_T.y - epicenter.y

	var/px = dy //find the reciprocal to get a perpendicular line
	var/py = dx * -1

	var/length = rand(5,10)
	var/partial = 1 / dx

	var/turf/new_T
	var/turf/old_T = epicenter
	for(var/i in 1 to length)
		new_T = locate(old_T.x + round(partial * dx), old_T.y + round(partial * dy), epicenter.z)
		var/offset = rand(-1,1)
		var/turf/p_T = locate(new_T.x + (round(offset * partial * px)), new_T.y + (round(offset * partial * py)), epicenter.z)

		explosion(p_T,1,2,rand(3,6))

		old_T = new_T
		sleep(rand(1,5))

/datum/ship_attack/flame_bomb
	cname = "fire bomb"

	hull_damage = 3 //TODO: add fire damage to NPC ships
	shield_bust = 1

/datum/ship_attack/flame_bomb/damage_effects(turf/open/epicenter)
	if(!istype(epicenter))
		for(var/turf/open/O in range(epicenter,1))
			epicenter = O
			break

		if(!istype(epicenter))
			return

	var/image/effect = image('icons/obj/tesla_engine/energy_ball.dmi', "energy_ball_fast", layer=FLY_LAYER)
	effect.color = "#FF0000"

	flick_overlay_static(effect,get_step(epicenter,SOUTHWEST),15)
	playsound(epicenter, 'sound/magic/lightningbolt.ogg', 100, 1)
	epicenter.atmos_spawn_air("o2=500;plasma=500;TEMP=1000") //BURN BABY BURN

/datum/ship_attack/stun_bomb
	cname = "stun bomb"

	hull_damage = 1
	shield_bust = 1

/datum/ship_attack/stun_bomb/damage_effects(turf/epicenter)
	var/image/effect = image('icons/obj/tesla_engine/energy_ball.dmi', "energy_ball_fast", layer=FLY_LAYER)
	effect.color = "#FFFF00"

	flick_overlay_static(effect,get_step(epicenter,SOUTHWEST),15)
	playsound(epicenter, 'sound/magic/lightningbolt.ogg', 100, 1)

	var/obj/item/weapon/grenade/flashbang/B = new(epicenter)
	B.prime()

/datum/ship_attack/ion
	cname = "ion cannon"

	hull_damage = 4 //TODO: and ion damage too
	shield_bust = 1

/datum/ship_attack/ion/damage_effects(turf/epicenter)
	var/image/effect = image('icons/obj/tesla_engine/energy_ball.dmi', "energy_ball_fast", layer=FLY_LAYER)
	effect.color = "#0000FF"

	flick_overlay_static(effect,get_step(epicenter,SOUTHWEST),15)
	playsound(epicenter, 'sound/magic/lightningbolt.ogg', 100, 1)
	empulse(epicenter,5,10,1)

//Below is the hell of adminbus weaponry, keep these at the bottom like they should be :^). Don't use these on serious ships.

/datum/ship_attack/honkerblaster
	cname = "Honkerblast cannon"

	hull_damage = 2
	shield_bust = 1

/datum/ship_attack/honkerblaster/damage_effects(turf/epicenter)

	playsound(epicenter, 'sound/items/AirHorn.ogg', 100, 1)
	playsound(epicenter, 'sound/effects/attackblob.ogg', 100, 1)
	for(var/mob/living/carbon/M in view(4, epicenter))
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			if(istype(H.ears, /obj/item/clothing/ears/earmuffs))
				continue
		to_chat(M, "<font color='red' size='9'>HONK</font>")
		M.SetSleeping(0)
		M.stuttering += 20
		M.adjustEarDamage(0, 75)
		M.Weaken(3)
		if(prob(70))
			M.Stun(10)
			M.Paralyse(4)
		else
			M.Jitter(500)

/datum/ship_attack/slipstorm
	cname = "Slipstorm cannon"

	hull_damage = 4
	shield_bust = 1

/datum/ship_attack/slipstorm/damage_effects(turf/epicenter)
	var/turf/sample_T
	for(var/turf/T in range(5,epicenter))
		if(istype(T))
			sample_T = T
	var/dx = sample_T.x - epicenter.x //get da slope
	var/dy = sample_T.y - epicenter.y

	var/px = dy //find the reciprocal to get a perpendicular line
	var/py = dx * -1

	var/length = rand(5,10)
	var/partial = 1 / dx

	var/turf/new_T
	var/turf/old_T = epicenter
	for(var/i in 1 to length)
		new_T = locate(old_T.x + round(partial * dx), old_T.y + round(partial * dy), epicenter.z)
		var/offset = rand(-1,1)
		var/turf/p_T = locate(new_T.x + (round(offset * partial * px)), new_T.y + (round(offset * partial * py)), epicenter.z)

		PoolOrNew(/obj/effect/particle_effect/foam, p_T)


/datum/ship_attack/bananabomb
	cname = "Banana Bomb"

	hull_damage = 3
	shield_bust = 1

/datum/ship_attack/bananabomb/damage_effects(turf/epicenter)
	playsound(epicenter, 'sound/items/bikehorn.ogg', 100, 1)
	for(var/turf/T in range(2,epicenter))
		if(istype(T,/turf/open))
			new /obj/item/weapon/grown/bananapeel(T)
