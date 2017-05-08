
/////AUGMENTATION SURGERIES//////


//SURGERY STEPS

/datum/surgery_step/replace
	name = "sever muscles"
	implements = list(/obj/item/weapon/scalpel = 100, /obj/item/weapon/wirecutters = 55)
	time = 32


/datum/surgery_step/replace/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] begins to sever the muscles on [target]'s [parse_zone(user.zone_selected)].", "<span class ='notice'>You begin to sever the muscles on [target]'s [parse_zone(user.zone_selected)]...</span>")


/datum/surgery_step/add_limb
	name = "replace limb"
	implements = list(/obj/item/bodypart = 100)
	time = 32
	var/obj/item/bodypart/L = null // L because "limb"


/datum/surgery_step/add_limb/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/bodypart/aug = tool
	if(aug.status != BODYPART_ROBOTIC)
		to_chat(user, "<span class='warning'>that's not an augment silly!</span>")
		return -1
	if(aug.body_zone != target_zone)
		to_chat(user, "<span class='warning'>[tool] isn't the right type for [parse_zone(target_zone)].</span>")
		return -1
	L = surgery.operated_bodypart
	if(L)
		user.visible_message("[user] begins to augment [target]'s [parse_zone(user.zone_selected)].", "<span class ='notice'>You begin to augment [target]'s [parse_zone(user.zone_selected)]...</span>")
	else
		user.visible_message("[user] looks for [target]'s [parse_zone(user.zone_selected)].", "<span class ='notice'>You look for [target]'s [parse_zone(user.zone_selected)]...</span>")


//ACTUAL SURGERIES

/datum/surgery/augmentation
	name = "augmentation"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/clamp_bleeders, /datum/surgery_step/retract_skin, /datum/surgery_step/replace, /datum/surgery_step/saw, /datum/surgery_step/add_limb)
	species = list(/mob/living/carbon/human)
	possible_locs = list("r_arm","l_arm","r_leg","l_leg","chest","head")
	requires_real_bodypart = TRUE

//SURGERY STEP SUCCESSES

/datum/surgery_step/add_limb/success(mob/user, mob/living/carbon/target, target_zone, obj/item/bodypart/tool, datum/surgery/surgery)
	if(L)
<<<<<<< HEAD
		user.visible_message("[user] successfully augments [target]'s [parse_zone(target_zone)]!", "<span class='notice'>You successfully augment [target]'s [parse_zone(target_zone)].</span>")
		L.change_bodypart_status(BODYPART_ROBOTIC, TRUE)
		L.icon = tool.icon
		L.max_damage = tool.max_damage
		user.drop_item()
=======
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			user.visible_message("[user] successfully augments [target]'s [parse_zone(target_zone)]!", "<span class='notice'>You successfully augment [target]'s [parse_zone(target_zone)].</span>")
			L.change_bodypart_status(ORGAN_ROBOTIC, 1)
			user.drop_item()
			qdel(tool)
			H.update_damage_overlays(0)
			H.updatehealth()
			add_logs(user, target, "augmented", addition="by giving him new [parse_zone(target_zone)] INTENT: [uppertext(user.a_intent)]")
	else
		to_chat(user, "<span class='warning'>[target] has no organic [parse_zone(target_zone)] there!</span>")
	return 1









/datum/surgery/chainsaw
	name = "chainsaw augmentation"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/retract_skin, /datum/surgery_step/saw, /datum/surgery_step/clamp_bleeders,
	/datum/surgery_step/incise, /datum/surgery_step/chainsaw)
	species = list(/mob/living/carbon/human)
	possible_locs = list("r_arm", "l_arm")
	requires_organic_bodypart = 0


/datum/surgery_step/chainsaw
	time = 64
	name = "insert chainsaw"
	implements = list(/obj/item/weapon/twohanded/required/chainsaw = 100)

/datum/surgery_step/chainsaw/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] begins to install the chainsaw onto [target].", "<span class='notice'>You begin to install the chainsaw onto [target]...</span>")

/datum/surgery_step/chainsaw/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(target.l_hand && target.r_hand)
		to_chat(user, "<span class='warning'>You can't fit the chainsaw in while [target]'s hands are full!</span>")
		return 0
	else
		user.visible_message("[user] finishes installing the chainsaw!", "<span class='notice'>You install the chainsaw.</span>")
		user.unEquip(tool)
>>>>>>> master
		qdel(tool)
		target.update_body_parts()
		target.updatehealth()
		add_logs(user, target, "augmented", addition="by giving him new [parse_zone(target_zone)] INTENT: [uppertext(user.a_intent)]")
	else
		to_chat(user, "<span class='warning'>[target] has no organic [parse_zone(target_zone)] there!</span>")
	return 1
