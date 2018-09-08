/datum/ship_attack //DATUM WITH INFO ON AN ATTACK
	var/cname = "Ship Attack"

	var/charge_to_fire = 0 //Only used on player ships

	var/hull_damage = 0 //How much integrity damage an attack does
	var/shield_damage = 1000 //How much shield damage an attack does. Wont do anything if it penetrates shields.
	var/shot_accuracy = 1

	var/fire_attack = 0 //TODO: Code fire damage for enemy ships
	var/emp_attack = 0 //Time the EMP lasts

	var/fire_delay = 5
	var/shots_fired = 1 //THATS THE WROONG NUMBER OOOOOO

	var/projectile_effect = "emitter"
	var/datum/ship_component/our_ship_component // the component we are owned by, used to add weapon specific changes via ship variables instead of subtypes
	var/unique_effect = NONE //Used to store unique effects like increasing ship boarding chance
	var/warning_time = 30 //Time between target visual and projectile spawn
	var/warning_volume = 100


/datum/ship_attack/proc/damage_effects(var/turf/epicenter)
	return

/datum/ship_attack/proc/attack_effect(var/turf/T)
	new /obj/effect/temp_visual/ship_target(T, src)

/datum/ship_attack/laser
	cname = "basic phase cannon"
	projectile_effect = "heavylaser"

	hull_damage = 1
	charge_to_fire = 2000

/datum/ship_attack/laser/damage_effects(epicenter)
	explosion(epicenter,1,2,3,5,SSship.ship_combat_log_spam)


/datum/ship_attack/laser/burst
	cname = "burst phase cannon"
	projectile_effect = "heavylaser"

	shots_fired = 3
	shot_accuracy = 0.95
	charge_to_fire = 5000

/datum/ship_attack/laser/focused
	cname = "focused phase cannon"
	projectile_effect = "heavylaser"

	shots_fired = 1
	shot_accuracy = 1.2
	charge_to_fire = 3000

/datum/ship_attack/laser/heavy
	cname = "heavy phase cannon"
	projectile_effect = "heavylaser"

	shot_accuracy = 0.95
	hull_damage = 2
	shield_damage = 2500
	charge_to_fire = 3000

/datum/ship_attack/laser/gatling
	cname = "gatling phase cannon"
	projectile_effect = "heavylaser"

	shots_fired = 10
	shot_accuracy = 0.5
	fire_delay = 2
	charge_to_fire = 10000

/datum/ship_attack/ballistic
	cname = "mac cannon"
	projectile_effect = "macround"

	hull_damage = 5
	shield_damage = 0

/datum/ship_attack/ballistic/damage_effects(epicenter)
	var/clusters = list()
	for(var/turf/T in range(epicenter,6))
		if(istype(T))
			clusters += T
	for(var/i in 1 to rand(3,5))
		explosion(pick(clusters),max(0,rand(-4,1)),1,rand(2,4),0,SSship.ship_combat_log_spam)
		sleep(rand(5,10))

/datum/ship_attack/shield_penetrator
	cname = "mac-sp"

	hull_damage = 1
	unique_effect = SHIELD_PENETRATE

/datum/ship_attack/cannon_ball
	cname = "mac-ball"

	hull_damage = 1
	shield_damage = 500

	shot_accuracy = 0.8

/datum/ship_attack/planet_killer
	cname = "mac-pk"

	hull_damage = 0
	shield_damage = 0

/datum/ship_attack/homing
	cname = "mac-sh"

	hull_damage = 3
	shield_damage = 500
	shot_accuracy = 1.4

//enemy only attacks

/datum/ship_attack/chaingun
	cname = "chaingun"
	projectile_effect = "plasma"

	hull_damage = 5
	shield_damage = 2000
	shot_accuracy = 0.85

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

		explosion(p_T,0,1,rand(2,4),0,SSship.ship_combat_log_spam)

		old_T = new_T
		sleep(rand(1,5))

/datum/ship_attack/flame_bomb
	cname = "fire bomb"
	projectile_effect = "lavastaff"

	hull_damage = 3 //TODO: add fire damage to NPC ships
	shield_damage = 0

/datum/ship_attack/flame_bomb/damage_effects(turf/open/epicenter)
	if(!istype(epicenter))
		for(var/turf/open/O in range(epicenter,1))
			epicenter = O
			break

		if(!istype(epicenter))
			return

	playsound(epicenter, 'sound/magic/lightningbolt.ogg', 100, 1)
	epicenter.atmos_spawn_air("o2=300;plasma=300;TEMP=1000") //BURN BABY BURN

/datum/ship_attack/stun_bomb
	cname = "stun bomb"
	projectile_effect = "pulse1_bl"

	hull_damage = 1
	unique_effect = SHIELD_PENETRATE

/datum/ship_attack/stun_bomb/damage_effects(turf/epicenter)
	playsound(epicenter, 'sound/magic/lightningbolt.ogg', 100, 1)

	var/obj/item/weapon/grenade/flashbang/B = new(epicenter)
	B.prime()

/datum/ship_attack/ion
	cname = "ion cannon"
	projectile_effect = "bluespace"

	hull_damage = 0
	shield_damage = 3000
	emp_attack = 100
	charge_to_fire = 5000

	unique_effect = ION_BOARDING_BOOST

/datum/ship_attack/ion/damage_effects(turf/epicenter)
	var/image/effect = image('icons/obj/tesla_engine/energy_ball.dmi', "energy_ball_fast", layer=FLY_LAYER)
	effect.color = "#0000FF"

	flick_overlay_static(effect,get_step(epicenter,SOUTHWEST),15)
	playsound(epicenter, 'sound/magic/lightningbolt.ogg', 100, 1)
	empulse(epicenter,3,7,1)

/datum/ship_attack/carrier_weapon
	cname = "Carrier Blaster"
	projectile_effect = "leaper"
	hull_damage = 0
	var/list/boarding_mobs = list(/mob/living/simple_animal/hostile/droid)
	var/amount = 5

/datum/ship_attack/carrier_weapon/damage_effects(turf/epicenter)

	playsound(epicenter, 'sound/ftl/shipweapons/carrier_hit.ogg', 100, 1)
	for(var/I = 1 to amount)
		var/path = pick(boarding_mobs)
		var/mob/to_spawn = new path(epicenter)
		if(our_ship_component.ship) //Means that attacks spawned from verbs deafult to Syndicate and don't runtime
			to_spawn.faction = list(our_ship_component.ship.faction)

/datum/ship_attack/carrier_weapon/oneTime
	var/fired = FALSE

/datum/ship_attack/carrier_weapon/oneTime/damage_effects(turf/epicenter)
	if(!fired)
		..()
		fired = TRUE
		emp_attack = 5
	else
		empulse(epicenter,2.5,5,1)  //So we don't print empty attack damage info; a weaker ion blast

/datum/ship_attack/prototype_laser_barrage
	cname = "unknown_ship_weapon"
	projectile_effect = "omnilaser"

	hull_damage = 22
	shield_damage = 4000

/datum/ship_attack/prototype_laser_barrage/damage_effects(turf/epicenter)
	explosion(epicenter,1,3,6,9,SSship.ship_combat_log_spam)

/datum/ship_attack/prototype_laser_barrage/proc/subimpact(var/turf/T)
	new /obj/effect/temp_visual/ship_target(T, src)

/datum/ship_attack/prototype_laser_barrage/attack_effect(var/turf/T) //10 shots, 7 spread
	var/turf/target_sub
	new /obj/effect/temp_visual/ship_target(T, src) //Initial hit
	for(var/I = 1 to 10) //Loop for each fragment
		target_sub = locate(T.x + rand(-7,7),T.y + rand(-7,7), T.z)
		addtimer(CALLBACK(src, .proc/subimpact, target_sub), warning_time+(2*I)) //Saves spamming many audio queues at once

//Below is the hell of adminbus weaponry, keep these at the bottom like they should be :^). Don't use these on serious ships.

/datum/ship_attack/honkerblaster
	cname = "Honkerblast cannon"
	projectile_effect = "kinetic_blast"

	hull_damage = 2
	unique_effect = SHIELD_PENETRATE

/datum/ship_attack/honkerblaster/damage_effects(turf/epicenter)

	playsound(epicenter, 'sound/items/airhorn.ogg', 100, 1)
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
		M.Knockdown(60)
		if(prob(70))
			M.Stun(200)
			M.Unconscious(80)
		else
			M.Jitter(500)

/datum/ship_attack/slipstorm
	cname = "Slipstorm cannon"
	projectile_effect = "xray"

	hull_damage = 4
	unique_effect = SHIELD_PENETRATE

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

		new /obj/effect/particle_effect/foam(p_T)


/datum/ship_attack/bananabomb
	cname = "Banana Bomb"
	projectile_effect = "neurotoxin"

	hull_damage = 3
	unique_effect = SHIELD_PENETRATE

/datum/ship_attack/bananabomb/damage_effects(turf/epicenter)
	playsound(epicenter, 'sound/items/bikehorn.ogg', 100, 1)
	for(var/turf/T in range(2,epicenter))
		if(istype(T,/turf/open))
			new /obj/item/weapon/grown/bananapeel(T)

/datum/ship_attack/vape_bomb
	cname = "Vape bomb"
	projectile_effect = "pulse1_bl"

	hull_damage = 3
	unique_effect = SHIELD_PENETRATE

/datum/ship_attack/vape_bomb/damage_effects(turf/open/epicenter)
	if(!istype(epicenter))
		for(var/turf/open/O in range(epicenter,1))
			epicenter = O
			break

		if(!istype(epicenter))
			return

	playsound(epicenter, 'sound/effects/smoke.ogg', 100, 1)
	epicenter.atmos_spawn_air("water_vapor=500;TEMP=300")

/datum/ship_attack/carrier_weapon/catgirl
	cname = "Cat-astrophy"
	amount = 2
	boarding_mobs = list(/mob/living/carbon/human/interactive/angry) //Floyd when he sees this PR

/datum/ship_attack/carrier_weapon/catgirl/damage_effects(turf/epicenter)

	playsound(epicenter, 'sound/effects/meow1.ogg', 100, 1)
	for(var/I = 1 to amount)
		var/path = pick(boarding_mobs)
		var/mob/living/carbon/human/interactive/to_spawn = new path(epicenter)
		to_spawn.Initialize() //So we can clear the knownStrings and replace with filth
		for(var/obj/item/bodypart/head/H in to_spawn.bodyparts)
			H.change_bodypart_status(BODYPART_ORGANIC,FALSE,TRUE) //Stops them spawning as semi robots?
		to_spawn.dna.features["tail_human"] = "Cat"
		to_spawn.dna.features["ears"] = "Cat"
		to_spawn.regenerate_icons()
		to_spawn.knownStrings = list("Nya~")
		to_spawn.startTailWag() //This is the line that will get me repo banned.
