/obj/structure/wall_cabinet
	name = "wall cabinet"
	desc = "A small wall mounted cabinet designed to hold small items."
	icon = 'icons/obj/wallmounts.dmi'
	icon_state = "cabinet_closed"
	anchored = 1
	density = 0
	var/opened = 0
	var/capacity = 1


/obj/structure/wall_cabinet/New(loc, ndir, building)			// Empty and opened if built,
	..()
	if(building)
		setDir(ndir)
		pixel_x = (dir & 3)? 0 : (dir == 4 ? -27 : 27)
		pixel_y = (dir & 3)? (dir ==1 ? -30 : 30) : 0
		opened = 1
		icon_state = "cabinet_empty"


/obj/structure/wall_cabinet/ex_act(severity, target)			// Reaction to explosions; Drops contents if Severity 2
	switch(severity)
		if(1)
			qdel(src)
			return
		if(2)
			if(prob(50))
				if(contents.len > 0)
					contents.loc = src.loc
				qdel(src)
				return
		if(3)
			return


/obj/structure/wall_cabinet/attackby(obj/item/I, mob/user, params)			// Reaction to getting attacked
	if(istype(I, /obj/item/weapon/wrench) && !contents )			// If wrench and cabinet empty, disassemble
		to_chat(user, "<span class='notice'>You start unsecuring [name]...</span>")
		playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user, 60/I.toolspeed, target = src))
			playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
			to_chat(user, "<span class='notice'>You unsecure [name].</span>")
			new /obj/item/wallframe/wall_cabinet(loc)
			qdel(src)
		return

	if(isrobot(user) || isalien(user))			// No non-humans allowed!
		return

	if( (istype(I, /obj/item)) )			// If /obj/item, put in cabinet
		if(!contents && opened)
			if(!user.drop_item())
				return
			contents += I
			to_chat(user, "<span class='notice'>You place [I] in [src].</span>")
		else
			opened = !opened

	else			// If other items, open/close cabinet
		opened = !opened

	update_icon()


/obj/structure/wall_cabinet/attack_hand(mob/user)
	if(isrobot(user) || isalien(user))
		return

	if(contents.len >= capacity)			// If there is an item inside cabinet, take one.
		user.put_in_hands(contents)
		to_chat(user, "<span class='notice'>You take [contents] from [src].</span>")
		contents = null
		opened = 1
	else
		opened = !opened

	update_icon()


/* /obj/structure/wall_cabinet/attack_tk(mob/user)
	if(contents.len = 1)			// Same as before, just with telekinesis
		contents.loc = loc
		to_chat(user, "<span class='notice'>You telekinetically remove [contents] from [src].</span>")
		contents = null
		opened = 1
	else
		opened = !opened

	update_icon()
*/

/obj/structure/wall_cabinet/attack_paw(mob/user)			// Monkey paws count as hands
	attack_hand(user)
	return


/obj/structure/wall_cabinet/AltClick(mob/living/user)
	if(user.incapacitated() || !Adjacent(user) || !istype(user))
		return
	opened = !opened
	update_icon()


/obj/structure/wall_cabinet/update_icon()
	if(!opened)
		icon_state = "cabinet_closed"
	else
		if(contents.len >= capacity)
			icon_state = "cabinet_full"
		else
			icon_state = "cabinet_empty"


/obj/item/wallframe/wall_cabinet
	name = "wall cabinet frame"
	desc = "Used for building wall-mounted cabinets."
	icon = 'icons/obj/wallmounts.dmi'
	icon_state = "cabinet_frame"
	result_path = /obj/structure/wall_cabinet