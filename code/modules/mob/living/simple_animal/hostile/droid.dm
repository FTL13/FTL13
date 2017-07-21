/mob/living/simple_animal/hostile/droid
	name = "Syndicate Droid Y-283"
	desc = "A syndicate produced droid, fires weak laser beams and looks quite fragile. A robust toolbox would be useful right now."
	icon = 'icons/mob/hivebot.dmi'
	icon_state = "SecBot"
	icon_living = "SecBot"
	icon_dead = "SecBot"
	maxHealth = 30
	health = 30
	speed = 3
	ranged = 1
	retreat_distance = 1
	minimum_distance = 3
	projectiletype = /obj/item/projectile/temp/droid
	projectilesound = 'sound/weapons/laser.ogg'
	gold_core_spawnable = 1
	aggro_vision_range = 9
	idle_vision_range = 2
	turns_per_move = 5
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	damage_coeff = list(BRUTE = 0.75, BURN = 1, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)
	a_intent = INTENT_HARM
	harm_intent_damage = 5
	speak_emote = list("beeps")
	faction = list("syndicate")
	check_friendly_fire = 1
	minbodytemp = 0
	maxbodytemp = 1500

/obj/item/projectile/temp/droid
	name = "droid ray"
	icon_state = "laser"
	damage = 6
	damage_type = BURN
	flag = "energy"
