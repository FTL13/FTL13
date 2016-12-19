/mob/living/carbon/human/attack_paw(mob/living/carbon/monkey/M)
	var/dam_zone = pick("chest", "l_hand", "r_hand", "l_leg", "r_leg")
	var/obj/item/bodypart/affecting = get_bodypart(ran_zone(dam_zone))

	if(M.a_intent == "help")
		..() //shaking
		return 0

	if(M.a_intent == INTENT_DISARM) //Always drop item in hand, if no item, get stunned instead.
		if(get_active_hand() && drop_item())
			playsound(loc, 'sound/weapons/slash.ogg', 25, 1, -1)
			visible_message("<span class='danger'>[M] disarmed [src]!</span>", \
					"<span class='userdanger'>[M] disarmed [src]!</span>")
		else
			playsound(loc, 'sound/weapons/pierce.ogg', 25, 1, -1)
			Weaken(5)
			add_logs(M, src, "tackled")
			visible_message("<span class='danger'>[M] has tackled down [src]!</span>", \
				"<span class='userdanger'>[M] has tackled down [src]!</span>")

	if(can_inject(M, 1, affecting))//Thick suits can stop monkey bites.
		if(..()) //successful monkey bite, this handles disease contraction.
			var/damage = rand(1, 3)
			if(stat != DEAD)
				apply_damage(damage, BRUTE, affecting, run_armor_check(affecting, "melee"))
				updatehealth()
		return 1