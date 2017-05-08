/obj/item/zombie_hand
	name = "zombie claw"
	desc = "A zombie's claw is its primary tool, capable of infecting \
		humans, butchering all other living things to \
		sustain the zombie, smashing open airlock doors and opening \
		child-safe caps on bottles."
	flags = NODROP|ABSTRACT|DROPDEL
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	icon = 'icons/effects/blood.dmi'
	icon_state = "bloodhand_left"
	var/icon_left = "bloodhand_left"
	var/icon_right = "bloodhand_right"
	hitsound = 'sound/hallucinations/growl1.ogg'
	force = 20
	damtype = "brute"

	var/removing_airlock = FALSE

/obj/item/zombie_hand/equipped(mob/user, slot)
	. = ..()
	//these are intentionally inverted
	var/i = user.get_held_index_of_item(src)
	if(!(i % 2))
		icon_state = icon_left
	else
		icon_state = icon_right

/obj/item/zombie_hand/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(!proximity_flag)
		return
	else if(isliving(target))
		if(ishuman(target))
			check_infection(target, user)
		else
			check_feast(target, user)

/obj/item/zombie_hand/proc/check_infection(mob/living/carbon/human/target, mob/user)
	CHECK_DNA_AND_SPECIES(target)

	if(NOZOMBIE in target.dna.species.species_traits)
		// cannot infect any NOZOMBIE subspecies (such as high functioning
		// zombies)
		return

	var/obj/item/organ/zombie_infection/infection
	infection = target.getorganslot("zombie_infection")
	if(!infection)
		infection = new()
		infection.Insert(target)

/obj/item/zombie_hand/proc/check_feast(mob/living/target, mob/living/user)
	if(target.stat == DEAD)
		var/hp_gained = target.maxHealth
		target.gib()
		// zero as argument for no instant health update
		user.adjustBruteLoss(-hp_gained, 0)
		user.adjustToxLoss(-hp_gained, 0)
		user.adjustFireLoss(-hp_gained, 0)
		user.adjustCloneLoss(-hp_gained, 0)
		user.updatehealth()
		user.adjustBrainLoss(-hp_gained) // Zom Bee gibbers "BRAAAAISNSs!1!"
<<<<<<< HEAD
		user.nutrition = min(user.nutrition + hp_gained, NUTRITION_LEVEL_FULL)
=======

/obj/item/zombie_hand/proc/tear_airlock(obj/machinery/door/airlock/A, mob/user)
	removing_airlock = TRUE
	to_chat(user, "<span class='notice'>You start tearing apart the airlock...</span>")

	playsound(src.loc, 'sound/machines/airlock_alien_prying.ogg', 100, 1)
	A.audible_message("<span class='italics'>You hear a loud metallic \
		grinding sound.</span>")

	addtimer(src, "growl", 20, unique=FALSE, user)

	if(do_after(user, delay=160, needhand=FALSE, target=A, progress=TRUE))
		playsound(src.loc, 'sound/hallucinations/far_noise.ogg', 50, 1)
		A.audible_message("<span class='danger'>With a screech, [A] is torn \
			apart!</span>")
		var/obj/structure/door_assembly/door = new A.assemblytype(get_turf(A))
		door.density = 0
		door.anchored = 1
		door.name = "ravaged [door]"
		door.desc = "An airlock that has been torn apart. Looks like it \
			won't be keeping much out now."
		qdel(A)
	removing_airlock = FALSE

/obj/item/zombie_hand/proc/growl(mob/user)
	if(removing_airlock)
		playsound(src.loc, 'sound/hallucinations/growl3.ogg', 50, 1)
		user.audible_message("<span class='warning'>[user] growls as \
			their claws dig into the metal frame...</span>")

/obj/item/zombie_hand/suicide_act(mob/living/carbon/user)
	// Suiciding as a zombie brings someone else in to play it
	user.visible_message("<span class='suicide'>[user] is lying down.</span>")
	if(!istype(user))
		return

	user.Weaken(30)
	var/success = offer_control(user)
	if(success)
		user.visible_message("<span class='suicide'>[user] appears to have \
			found new spirit.</span>")
		return SHAME
	else
		user.visible_message("<span class='suicide'>[user] stops moving.\
			</span>")
		return OXYLOSS
>>>>>>> master
