/obj/structure/wall_cabinet
	name = "wall cabinet"
	desc = "A small wall mounted cabinet designed to hold small items."
	icon = 'icons/obj/wallmounts.dmi'
	icon_state = "cabinet_closed"
	anchored = 1
	density = 0
	var/opened = 0										// Is the cabinet opened? 1/0
	var/nick = "cabinet"								// Used in sprite-calling; Name this the same as the first part of the icon_states
	var/capacity = 1									// How many items fit inside? Use a fitting integer
	var/exclusivity	= 0									// Are multiple items of the same type allowed? 1/0
	var/allowedContent[] = list(/obj/item)				// What items are allowed inside? Put an item path here, i.e. /obj/item/*
	var/spawnContent[] = newlist()						// What items should a spawned cabinet start with? Put item paths here, i.e. /obj/item/*


/obj/structure/wall_cabinet/New(loc, ndir, building)	// Initializes a new wall cabinet
	..()
	if(building)
		setDir(ndir)
		pixel_x = (dir & 3)? 0 : (dir == 4 ? -27 : 27)
		pixel_y = (dir & 3)? (dir ==1 ? -30 : 30) : 0
		opened = 1
		contents = null
		update_icon()
	else
		for(var/i=1, i <= spawnContent.len, i++)		// If any spawn items are set, run this loop
			contents += spawnContent[i]


/obj/structure/wall_cabinet/proc/allowedItem(var/x)		// Checks whether the items are allowed for this cabinet type
	for(var/i=1, i <= allowedContent.len, i++)			// If only specific contents are allowed, run this loop
		if(istype(x, allowedContent[i]))				// Checks if the item fits in the set categories
			return 1
	return 0


/obj/structure/wall_cabinet/proc/findContent(var/x)		// Very specific proc, used when "x in list" cannot be used for some reason
	if(x in contents)									// Example: Oxygen cabinet naming system, Exclusivity test
		return 1										// It double-checks in two different ways, just to make sure
	else
		for(var/i=1, i <= contents.len, i++)
			if(istype(x, contents[i]))
				return 1
	return 0


/obj/structure/wall_cabinet/update_icon()				// Changes Sprite dependent on contents
	if(!opened)											// May have to get overridden in children if the naming system is different
		icon_state = "[nick]_closed"					// Example: Oxygen cabinet, uses "oxygen_1_1" instead of full since it has more different sprites
	else
		if(contents.len == 0)
			icon_state = "[nick]_empty"
		else
			icon_state = "[nick]_full"


/obj/structure/wall_cabinet/attackby(obj/item/I, mob/user, params)						// Reaction to getting attacked with an item
	if(istype(I, /obj/item/weapon/wrench) && (contents.len == 0) )						// If wrench and cabinet empty, disassemble
		to_chat(user, "<span class='notice'>You start unsecuring [name]...</span>")
		playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user, 60/I.toolspeed, target = src))
			playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
			to_chat(user, "<span class='notice'>You unsecure [name].</span>")
			new /obj/item/wallframe/wall_cabinet(loc)
			qdel(src)
		return

	if(isrobot(user) || isalien(user))					// No non-humans allowed!
		return

	if((contents.len < capacity) && opened && !(exclusivity && findContent(I)) )				// If cabinet is not full, is opened, the item is valid and not exclusive... place it inside
		if(allowedItem(I))
			if(!user.drop_item())
				return
			contents += I
			to_chat(user, "<span class='notice'>You place [I] in [src].</span>")
		else
			opened = !opened

	else												// If other items, open/close cabinet
		opened = !opened

	update_icon()


/obj/structure/wall_cabinet/attack_hand(mob/user)
	if(isrobot(user) || isalien(user))
		return

	if(contents.len > 0)											// If there is an item inside cabinet, take the last addition
		to_chat(user, "<span class='notice'>You take [contents[contents.len]] from [src].</span>")
		user.put_in_hands(contents[contents.len])
		opened = 1
	else
		opened = !opened

	update_icon()


/obj/structure/wall_cabinet/attack_tk(mob/user)
	if(contents.len > 0)											// Same as above, just with telekinesis, and it drops the item instead of taking it
		var/turf/t = get_turf(src)
		to_chat(user, "<span class='notice'>You telekinetically remove [contents[contents.len]] from [src].</span>")
		t.contents += contents[contents.len]
		opened = 1
	else
		opened = !opened

	update_icon()



/obj/structure/wall_cabinet/attack_paw(mob/user)							// Monkey paws count as hands
	attack_hand(user)
	return


/obj/structure/wall_cabinet/AltClick(mob/living/user)						// Alt-Clicking opens/closes cabinet
	if(user.incapacitated() || !Adjacent(user) || !istype(user))
		return
	opened = !opened
	update_icon()


/obj/structure/wall_cabinet/ex_act(severity, target)						// Reaction to explosions
	switch(severity)
		if(1)																// Sev 1; Destroy cabinet
			qdel(src)														// Sev 2; 50/50 chance to destroy cabinet and drop items
			return															// Sev 3; Nothing
		if(2)
			if(prob(50))
				var/turf/t = get_turf(src)
				t.contents += contents
				qdel(src)
				return
		if(3)
			return


/obj/item/wallframe/wall_cabinet											// Defines the object you can use to craft wall cabinets
	name = "wall cabinet frame"
	desc = "Used for building wall-mounted cabinets."
	icon = 'icons/obj/wallmounts.dmi'
	icon_state = "cabinet_frame"
	result_path = /obj/structure/wall_cabinet
