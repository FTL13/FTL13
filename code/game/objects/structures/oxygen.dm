/obj/structure/oxygen_cabinet
	name = "oxygen cabinet"
	desc = "A small wall mounted cabinet designed to hold a breath mask and an emergency oxygen tank."
	icon = 'icons/obj/wallmounts.dmi'
	icon_state = "oxygen_closed"
	anchored = 1
	density = 0
	var/obj/item/weapon/tank/internals/emergency_oxygen/has_oxygen
	var/obj/item/weapon/tank/internals/emergency_oxygen/has_mask
	var/opened = 0


/obj/structure/oxygen_cabinet/New(loc, ndir, building)			// Empty and opened if built, Full and closed otherwise
	..()
	if(building)
		setDir(ndir)
		pixel_x = (dir & 3)? 0 : (dir == 4 ? -27 : 27)
		pixel_y = (dir & 3)? (dir ==1 ? -30 : 30) : 0
		opened = 1
		icon_state = "oxygen_empty"
	else
		has_oxygen = new /obj/item/weapon/tank/internals/emergency_oxygen(src)
		has_mask = new /obj/item/clothing/mask/breath(src)


/obj/structure/oxygen_cabinet/ex_act(severity, target)			// Reaction to explosions; Drops contents if Severity 2
	switch(severity)
		if(1)
			qdel(src)
			return
		if(2)
			if(prob(50))
				if(has_oxygen)
					has_oxygen.loc = src.loc
				if(has_mask)
					has_mask.loc = src.loc
				qdel(src)
				return
		if(3)
			return


/obj/structure/oxygen_cabinet/attackby(obj/item/I, mob/user, params)			// Reaction to getting attacked
	if(istype(I, /obj/item/weapon/wrench) && !has_oxygen && !has_oxygen)			// If wrench and cabinet empty, disassemble
		to_chat(user, "<span class='notice'>You start unsecuring [name]...</span>")
		playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user, 60/I.toolspeed, target = src))
			playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
			to_chat(user, "<span class='notice'>You unsecure [name].</span>")
			new /obj/item/wallframe/oxygen_cabinet(loc)
			qdel(src)
		return

	if(isrobot(user) || isalien(user))			// No non-humans allowed!
		return

	if( (istype(I, /obj/item/weapon/tank/internals/emergency_oxygen)) || (istype(I, /obj/item/clothing/mask/breath)) )
		if(istype(I, /obj/item/weapon/tank/internals/emergency_oxygen))			// If standard oxygen tank in hand, put in cabinet
			if(!has_oxygen && opened)
				if(!user.drop_item())
					return
				contents += I
				has_oxygen = I
				to_chat(user, "<span class='notice'>You place [I] in [src].</span>")
			else
				opened = !opened

		else			// If breath mask in hand, put in cabinet
			if(!has_mask && opened)
				if(!user.drop_item())
					return
				contents += I
				has_mask = I
				to_chat(user, "<span class='notice'>You place [I] in [src].</span>")
			else
				opened = !opened

	else			// If other items, open/close cabinet
		opened = !opened

	update_icon()


/obj/structure/oxygen_cabinet/attack_hand(mob/user)
	if(isrobot(user) || isalien(user))			// No non-humans allowed!
		return

	if(has_oxygen || has_mask)			// If there is either an oxygen tank or breath mask inside cabinet, take one. Priority tank over mask
		if(has_oxygen)
			user.put_in_hands(has_oxygen)
			to_chat(user, "<span class='notice'>You take [has_oxygen] from [src].</span>")
			has_oxygen = null
			opened = 1
		else
			user.put_in_hands(has_mask)
			to_chat(user, "<span class='notice'>You take [has_mask] from [src].</span>")
			has_mask = null
			opened = 1
	else
		opened = !opened

	update_icon()


/obj/structure/oxygen_cabinet/attack_tk(mob/user)
	if(has_oxygen || has_mask)			// Same as before, just with telekinesis
		if(has_oxygen)
			has_oxygen.loc = loc
			to_chat(user, "<span class='notice'>You telekinetically remove [has_oxygen] from [src].</span>")
			has_oxygen = null
			opened = 1
		else
			has_mask.loc = loc
			to_chat(user, "<span class='notice'>You telekinetically remove [has_mask] from [src].</span>")
			has_mask = null
			opened = 1
	else
		opened = !opened

	update_icon()


/obj/structure/oxygen_cabinet/attack_paw(mob/user)			// Monkey paws count as hands
	attack_hand(user)
	return


/obj/structure/oxygen_cabinet/AltClick(mob/living/user)
	if(user.incapacitated() || !Adjacent(user) || !istype(user))
		return
	opened = !opened
	update_icon()


/obj/structure/oxygen_cabinet/update_icon()			// Updates sprite based on contents. Very basic coding. hOw dO I BitFlAG ?!
	if(!opened)
		icon_state = "oxygen_closed"
		return
	else
		if(has_oxygen && has_mask)
			icon_state = "oxygen_full"
		else
			if(has_oxygen && !has_mask)
				icon_state = "oxygen_tank"
			else
				if(!has_oxygen && has_mask)
					icon_state = "oxygen_mask"
				else
					icon_state = "oxygen_empty"


/obj/item/wallframe/oxygen_cabinet
	name = "oxygen cabinet frame"
	desc = "Used for building wall-mounted oxygen cabinets."
	icon = 'icons/obj/apc_repair.dmi'
	icon_state = "oxygen_frame"
	result_path = /obj/structure/oxygen_cabinet
