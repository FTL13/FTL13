
//
// compat for older tg code
//
// Should be removed if FTL13 gets updated

//the define for visible message range in combat
#define COMBAT_MESSAGE_RANGE 3

/mob/proc/held_items()
	return list(src.l_hand, src.r_hand)

//Checks if we're holding an item of type: typepath
/mob/proc/is_holding_item_of_type(typepath)
	for(var/obj/item/I in held_items())
		if(istype(I, typepath))
			return I
	return FALSE

/mob/living/carbon/monkey/proc/create_bodyparts()
	//initialize limbs, currently only used to handle cavity implant surgery, no dismemberment.
	bodyparts = newlist(/obj/item/bodypart/chest, /obj/item/bodypart/head, /obj/item/bodypart/l_arm, /obj/item/bodypart/r_arm, /obj/item/bodypart/r_leg, /obj/item/bodypart/l_leg)
	for(var/X in bodyparts)
		var/obj/item/bodypart/O = X
		O.owner = src

/mob/living/carbon/proc/create_internal_organs()
	for(var/obj/item/organ/I in internal_organs)
		I.Insert(src)

// damage ONE external organ, organ gets randomly selected from damaged ones.
/mob/living/proc/take_bodypart_damage(brute, burn, updating_health = 1)
	adjustBruteLoss(brute, 0) //zero as argument for no instant health update
	adjustFireLoss(burn, 0)
	if(updating_health)
		updatehealth()

//Damages ONE bodypart randomly selected from damagable ones.
//It automatically updates damage overlays if necessary
//It automatically updates health status
/mob/living/carbon/take_bodypart_damage(brute, burn)
	var/list/obj/item/bodypart/parts = get_damageable_bodyparts()
	if(!parts.len)
		return
	var/obj/item/bodypart/picked = pick(parts)
	if(picked.take_damage(brute,burn))
		update_damage_overlays()