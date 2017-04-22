/mob/living/simple_animal/hostile/carp
	name = "space carp"
	desc = "A ferocious, fang-bearing creature that resembles a fish."
	icon_state = "carp"
	icon_living = "carp"
	icon_dead = "carp_dead"
	icon_gib = "carp_gib"
	speak_chance = 0
	turns_per_move = 5
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/carpmeat = 2)
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "hits"
	emote_taunt = list("gnashes")
	taunt_chance = 30
	speed = 0
	maxHealth = 25
	health = 25

	harm_intent_damage = 8
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "bites"
	attack_sound = 'sound/weapons/bite.ogg'
	speak_emote = list("gnashes")

	//Space carp aren't affected by cold.
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500

	faction = list("carp")
	flying = 1
	pressure_resistance = 200
	gold_core_spawnable = 1
	var/stamina = 100 //how much it takes to WRASSLE
	can_buckle = 0
	max_buckled_mobs = 0
	var/sleepstate = "carp_sleep"
	buckle_lying = 1 //makes you lay down on it when WRASSLING
	var/tired = 0 //TIRED FROM WRASSLIN!!!



/mob/living/simple_animal/hostile/carp/Process_Spacemove(movement_dir = 0)
	return 1	//No drifting in space for space carp!	//original comments do not steal

/mob/living/simple_animal/hostile/carp/AttackingTarget()
	..()
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.adjustStaminaLoss(8)



/mob/living/simple_animal/hostile/carp/proc/thrash()
	if(has_buckled_mobs())
		stamina -= 10 //when someone lays on him and he thrashes, he loses energy
		visible_message("<span class='warning'>[src] thrashes around, with someone on top of it, losing some energy!</span>")

	if(stamina < 0)
		stamina = 0

	if(!has_buckled_mobs())
		stamina += 10 //they thrash around to regain stamina when no one is ontop of them
		visible_message("<span class='warning'>[src] thrashes around, regaining some energy!</span>")





/mob/living/simple_animal/hostile/carp/attack_hand(var/mob/living/carbon/human/A) //Wrassle that carp
	var/mob/living/carbon/human/H = A
	if(ishuman(H))
		if(H.a_intent == "disarm" || tired == 0) // no disarms if carp in stamina crit
			visible_message("<span class='warning'>[H] wrestles with the [src]! weakening it a bit</span>")
			stamina -= 25 //you REALLY gotta wrassle HARD
		if(tired == 1)
			visible_message("<span class='warning'>[src] is already weakened pounce on it and pin it!</span>")




/mob/living/simple_animal/hostile/carp/proc/recover()
	icon_state = icon_living
	AIStatus = 1 	//COMMENCE FIGHTING AGAIN, he recovered
	tired = 0
	can_buckle = 0 //Unable to bellyflop on it
	max_buckled_mobs = 0


/mob/living/simple_animal/hostile/carp/proc/flop()
	if(tired == 0)
		if(stamina <= 50) //successful carp WRASSLEMANIA
			icon_state = sleepstate
			visible_message("<span class='warning'>[src] flops on the floor, exhausted! LEAP ON THAT GODDAMN [src]!</span>")
			can_buckle = 1
			max_buckled_mobs = 1
			tired = 1

/mob/living/simple_animal/hostile/carp/Life()
	if(tired == 1) //On the floor, thrash to attempt to get back up
		thrash()
	if( stamina > 50) //stamina above 50, not stamina crit
		recover()
	if(stamina <= 50)
		flop() //carp is tired and flops with exhaustion
	else
		return


/mob/living/simple_animal/hostile/carp/holocarp
	icon_state = "holocarp"
	icon_living = "holocarp"
	maxbodytemp = INFINITY
	gold_core_spawnable = 0
	del_on_death = 1

/mob/living/simple_animal/hostile/carp/megacarp
	icon = 'icons/mob/alienqueen.dmi'
	name = "Mega Space Carp"
	desc = "A ferocious, fang bearing creature that resembles a shark. This one seems especially ticked off."
	icon_state = "megacarp"
	icon_living = "megacarp"
	icon_dead = "megacarp_dead"
	icon_gib = "megacarp_gib"
	maxHealth = 65
	health = 65
	pixel_x = -16
	mob_size = MOB_SIZE_LARGE

	melee_damage_lower = 20
	melee_damage_upper = 20


/mob/living/simple_animal/hostile/carp/cayenne
	name = "Cayenne"
	desc = "A failed Syndicate experiment in weaponized space carp technology, it now serves as a lovable mascot."
	speak_emote = list("squeaks")
	gold_core_spawnable = 0
	faction = list("syndicate")
	AIStatus = AI_OFF


//fishing exclusive carp
/mob/living/simple_animal/hostile/carp/radcarp
	name = "Radioactive Carp"
	desc = "A carp oozing with radiation, it doesn't look all that friendly."
	speak_emote = list("gurgles")
	gold_core_spawnable = 1
	var/poison_type = "radium"
	var/poison_per_bite = 5
	icon_state = "radcarp"
	icon_living = "radcarp"
	icon_dead = "radcarp_dead"
	sleepstate = "radcarp_sleep"

/mob/living/simple_animal/hostile/carp/radcarp/nukacarp
	name = "Nuka Carp"
	desc = "A MASSIVE carp oozing with radiation, it smells like chernobyl."
	speak_emote = list("roars")
	gold_core_spawnable = 0
	poison_type = "polonium"
	poison_per_bite = 1
	icon_state = "nukacarp"
	icon_living = "nukacarp"
	icon = 'icons/mob/alienqueen.dmi'
	icon_dead = "nukacarp_dead"
	sleepstate = "nukacarp_sleep"

/mob/living/simple_animal/hostile/carp/radcarp/AttackingTarget()
	..()
	if(isliving(target))
		var/mob/living/L = target
		if(target.reagents)
			L.reagents.add_reagent(poison_type, poison_per_bite)
//rad carp irradiates you


/mob/living/simple_animal/hostile/carp/angler
	name = "Deep Space Carp"
	desc = "A menacing carp with a small dangley bit on its head it looks very bright."
	speak_emote = list("hisses")
	gold_core_spawnable = 1
	icon_state = "anglercarp"
	icon_living = "anglercarp"
	icon_dead = "anglercarp_dead"
	sleepstate = "anglercarp_sleep"
	var/stunraep = 1 //Basic, low powered stun

/mob/living/simple_animal/hostile/carp/angler/AttackingTarget()
	..()
	if(isliving(target))
		var/mob/living/L = target
		if(L.flash_eyes(affect_silicon = 1))
			if(prob(30))
				L.Stun(stunraep)
				visible_message("<span class='disarm'>The [src] stuns [L] with its light!</span>")
			else
				L.Weaken(stunraep)
				visible_message("<span class='disarm'>The [src] blinds [L] with its light!</span>")


/mob/living/simple_animal/hostile/carp/angler/deep
	name = "Pitch black Space Carp"
	desc = "Its whole body is black..you can't really tell where it ends and begins."
	speak_emote = list("hisses")
	gold_core_spawnable = 0
	icon_state = "deepcarp"
	icon_living = "deepcarp"
	icon_dead = "deepcarp_dead"
	stunraep = 10//OH GOD RUN, same as flashbang
	sleepstate = "deepcarp_sleep"