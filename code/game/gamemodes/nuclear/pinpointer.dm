//Pinpointers are used to track atoms from a distance as long as they're on the same z-level. The captain and nuke ops have ones that track the nuclear authentication disk.
/obj/item/weapon/pinpointer
	name = "pinpointer"
	desc = "A handheld tracking device that locks onto certain signals."
	icon = 'icons/obj/device.dmi'
	icon_state = "pinoff"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	item_state = "electronic"
	throw_speed = 3
	throw_range = 7
	materials = list(MAT_METAL = 500, MAT_GLASS = 250)
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	var/active = FALSE
	var/atom/movable/target = null //The thing we're searching for
	var/atom/movable/constant_target = null //The thing we're always focused on, if we're in the right mode
	var/target_x = 0 //The target coordinates if we're tracking those
	var/target_y = 0
	var/minimum_range = 0 //at what range the pinpointer declares you to be at your destination
	var/nuke_warning = FALSE // If we've set off a miniature alarm about an armed nuke
	var/mode = TRACK_NUKE_DISK //What are we looking for?

/obj/item/weapon/pinpointer/New()
	..()
	GLOB.pinpointer_list += src

/obj/item/weapon/pinpointer/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	GLOB.pinpointer_list -= src
	return ..()

<<<<<<< HEAD
/obj/item/weapon/pinpointer/attack_self(mob/living/user)
	active = !active
	user.visible_message("<span class='notice'>[user] [active ? "" : "de"]activates their pinpointer.</span>", "<span class='notice'>You [active ? "" : "de"]activate your pinpointer.</span>")
	playsound(user, 'sound/items/Screwdriver2.ogg', 50, 1)
	icon_state = "pin[active ? "onnull" : "off"]"
	if(active)
		START_PROCESSING(SSfastprocess, src)
=======
/obj/item/weapon/pinpointer/attack_self()
	if(!active)
		active = 1
		workdisk()
		to_chat(usr, "<span class='notice'>You activate the pinpointer.</span>")
	else
		active = 0
		icon_state = "pinoff"
		to_chat(usr, "<span class='notice'>You deactivate the pinpointer.</span>")

/obj/item/weapon/pinpointer/proc/scandisk()
	if(!the_disk)
		the_disk = locate()

/obj/item/weapon/pinpointer/proc/point_at(atom/target, spawnself = 1)
	if(!active)
		return
	if(!target)
		icon_state = "pinonnull"
		return

	var/turf/T = get_turf(target)
	var/turf/L = get_turf(src)

	if(T.z != L.z)
		icon_state = "pinonnull"
>>>>>>> master
	else
		target = null //Restarting the pinpointer forces a target reset
		STOP_PROCESSING(SSfastprocess, src)

/obj/item/weapon/pinpointer/attackby(obj/item/I, mob/living/user, params)
	if(mode != TRACK_ATOM)
		return ..()
	user.visible_message("<span class='notice'>[user] tunes [src] to [I].</span>", "<span class='notice'>You fine-tune [src]'s tracking to track [I].</span>")
	playsound(src, 'sound/machines/click.ogg', 50, 1)
	constant_target = I

/obj/item/weapon/pinpointer/examine(mob/user)
	..()
	var/msg = "Its tracking indicator reads "
	switch(mode)
		if(TRACK_NUKE_DISK)
			msg += "\"nuclear_disk\"."
		if(TRACK_MALF_AI)
			msg += "\"01000001 01001001\"."
		if(TRACK_INFILTRATOR)
			msg += "\"vasvygengbefuvc\"."
		if(TRACK_OPERATIVES)
			msg += "\"[target ? "Operative [target]" : "friends"]\"."
		if(TRACK_ATOM)
			msg += "\"[initial(constant_target.name)]\"."
		if(TRACK_COORDINATES)
			msg += "\"([target_x], [target_y])\"."
		else
			msg = "Its tracking indicator is blank."
	to_chat(user, msg)
	for(var/obj/machinery/nuclearbomb/bomb in GLOB.machines)
		if(bomb.timing)
<<<<<<< HEAD
			to_chat(user, "Extreme danger. Arming signal detected. Time remaining: [bomb.get_time_left()]")

/obj/item/weapon/pinpointer/process()
	if(!active)
		STOP_PROCESSING(SSfastprocess, src)
=======
			to_chat(user, "Extreme danger.  Arming signal detected.   Time remaining: [bomb.timeleft]")


/obj/item/weapon/pinpointer/advpinpointer
	name = "advanced pinpointer"
	icon = 'icons/obj/device.dmi'
	desc = "A larger version of the normal pinpointer, this unit features a helpful quantum entanglement detection system to locate various objects that do not broadcast a locator signal."
	var/mode = 0  // Mode 0 locates disk, mode 1 locates coordinates.
	var/turf/location = null
	var/obj/target = null

/obj/item/weapon/pinpointer/advpinpointer/attack_self()
	if(!active)
		active = 1
		if(mode == 0)
			workdisk()
		if(mode == 1)
			point_at(location)
		if(mode == 2)
			point_at(target)
		to_chat(usr, "<span class='notice'>You activate the pinpointer.</span>")
	else
		active = 0
		icon_state = "pinoff"
		to_chat(usr, "<span class='notice'>You deactivate the pinpointer.</span>")


/obj/item/weapon/pinpointer/advpinpointer/verb/toggle_mode()
	set category = "Object"
	set name = "Toggle Pinpointer Mode"
	set src in view(1)

	if(usr.stat || usr.restrained() || !usr.canmove)
		return

	active = 0
	icon_state = "pinoff"
	target=null
	location = null

	switch(alert("Please select the mode you want to put the pinpointer in.", "Pinpointer Mode Select", "Location", "Disk Recovery", "Other Signature"))
		if("Location")
			mode = 1

			var/locationx = input(usr, "Please input the x coordinate to search for.", "Location?" , "") as num
			if(!locationx || !(usr in view(1,src)))
				return
			var/locationy = input(usr, "Please input the y coordinate to search for.", "Location?" , "") as num
			if(!locationy || !(usr in view(1,src)))
				return

			var/turf/Z = get_turf(src)

			location = locate(locationx,locationy,Z.z)

			to_chat(usr, "<span class='notice'>You set the pinpointer to locate [locationx],[locationy]</span>")


			return attack_self()

		if("Disk Recovery")
			mode = 0
			return attack_self()

		if("Other Signature")
			mode = 2
			switch(alert("Search for item signature or DNA fragment?" , "Signature Mode Select" , "" , "Item" , "DNA"))
				if("Item")
					var/targetitem = input("Select item to search for.", "Item Mode Select","") as null|anything in possible_items
					if(!targetitem)
						return
					target=locate(possible_items[targetitem])
					if(!target)
						to_chat(usr, "<span class='warning'>Failed to locate [targetitem]!</span>")
						return
					to_chat(usr, "<span class='notice'>You set the pinpointer to locate [targetitem].</span>")
				if("DNA")
					var/DNAstring = input("Input DNA string to search for." , "Please Enter String." , "")
					if(!DNAstring)
						return
					for(var/mob/living/carbon/C in mob_list)
						if(!C.dna)
							continue
						if(C.dna.unique_enzymes == DNAstring)
							target = C
							break

			return attack_self()


///////////////////////
//nuke op pinpointers//
///////////////////////


/obj/item/weapon/pinpointer/nukeop
	var/mode = 0	//Mode 0 locates disk, mode 1 locates the shuttle
	var/obj/docking_port/mobile/home


/obj/item/weapon/pinpointer/nukeop/attack_self(mob/user)
	if(!active)
		active = 1
		var/mode_text = "Authentication Disk Locator mode"
		if(!mode)
			workdisk()
		else
			mode_text = "Shuttle Locator mode"
			worklocation()
		to_chat(user, "<span class='notice'>You activate the pinpointer([mode_text]).</span>")
	else
		active = 0
		icon_state = "pinoff"
		to_chat(user, "<span class='notice'>You deactivate the pinpointer.</span>")


/obj/item/weapon/pinpointer/nukeop/workdisk()
	if(!active) return
	if(mode)		//Check in case the mode changes while operating
		worklocation()
>>>>>>> master
		return
	scan_for_target()
	point_to_target()
	my_god_jc_a_bomb()
	addtimer(CALLBACK(src, .proc/refresh_target), 50, TIMER_UNIQUE)

/obj/item/weapon/pinpointer/proc/scan_for_target() //Looks for whatever it's tracking
	if(target)
		if(isliving(target))
			var/mob/living/L = target
			if(L.stat == DEAD)
				target = null
		return
	switch(mode)
		if(TRACK_NUKE_DISK)
			var/obj/item/weapon/disk/nuclear/N = locate()
			target = N
		if(TRACK_MALF_AI)
			for(var/V in GLOB.ai_list)
				var/mob/living/silicon/ai/A = V
				if(A.nuking)
					target = A
			for(var/V in GLOB.apcs_list)
				var/obj/machinery/power/apc/A = V
				if(A.malfhack && A.occupier)
					target = A
		if(TRACK_INFILTRATOR)
			target = SSshuttle.getShuttle("syndicate")
		if(TRACK_OPERATIVES)
			var/list/possible_targets = list()
			var/turf/here = get_turf(src)
			for(var/V in SSticker.mode.syndicates)
				var/datum/mind/M = V
				if(M.current && M.current.stat != DEAD)
					possible_targets |= M.current
			var/mob/living/closest_operative = get_closest_atom(/mob/living/carbon/human, possible_targets, here)
			if(closest_operative)
				target = closest_operative
		if(TRACK_ATOM)
			if(constant_target)
				target = constant_target
		if(TRACK_COORDINATES)
			var/turf/T = get_turf(src)
			target = locate(target_x, target_y, T.z)

/obj/item/weapon/pinpointer/proc/point_to_target() //If we found what we're looking for, show the distance and direction
	if(!active)
		return
	if(!target || (mode == TRACK_ATOM && !constant_target))
		icon_state = "pinon[nuke_warning ? "alert" : ""]null"
		return
	var/turf/here = get_turf(src)
	var/turf/there = get_turf(target)
	if(here.z != there.z)
		icon_state = "pinon[nuke_warning ? "alert" : ""]null"
		return
	if(get_dist_euclidian(here,there)<=minimum_range)
		icon_state = "pinon[nuke_warning ? "alert" : ""]direct"
	else
		setDir(get_dir(here, there))
		switch(get_dist(here, there))
			if(1 to 8)
				icon_state = "pinon[nuke_warning ? "alert" : "close"]"
			if(9 to 16)
				icon_state = "pinon[nuke_warning ? "alert" : "medium"]"
			if(16 to INFINITY)
				icon_state = "pinon[nuke_warning ? "alert" : "far"]"

/obj/item/weapon/pinpointer/proc/my_god_jc_a_bomb() //If we should get the hell back to the ship
	for(var/obj/machinery/nuclearbomb/bomb in GLOB.nuke_list)
		if(bomb.timing)
			if(!nuke_warning)
				nuke_warning = TRUE
				playsound(src, 'sound/items/Nuke_toy_lowpower.ogg', 50, 0)
				if(isliving(loc))
					var/mob/living/L = loc
					to_chat(L, "<span class='userdanger'>Your [name] vibrates and lets out a tinny alarm. Uh oh.</span>")

/obj/item/weapon/pinpointer/proc/switch_mode_to(new_mode) //If we shouldn't be tracking what we are
	if(isliving(loc))
		var/mob/living/L = loc
		to_chat(L, "<span class='userdanger'>Your [name] beeps as it reconfigures its tracking algorithms.</span>")
		playsound(L, 'sound/machines/triple_beep.ogg', 50, 1)
	mode = new_mode
	target = null //Switch modes so we can find the new target

<<<<<<< HEAD
/obj/item/weapon/pinpointer/proc/refresh_target() //Periodically removes the target to allow the pinpointer to update (i.e. malf AI shunts, an operative dies)
	target = null

/obj/item/weapon/pinpointer/syndicate //Syndicate pinpointers automatically point towards the infiltrator once the nuke is active.
	name = "syndicate pinpointer"
	desc = "A handheld tracking device that locks onto certain signals. It's configured to switch tracking modes once it detects the activation signal of a nuclear device."

/obj/item/weapon/pinpointer/syndicate/cyborg //Cyborg pinpointers just look for a random operative.
	name = "cyborg syndicate pinpointer"
	desc = "An integrated tracking device, jury-rigged to search for living Syndicate operatives."
	mode = TRACK_OPERATIVES
	flags = NODROP
=======
/obj/item/weapon/pinpointer/operative/attack_self()
	if(!usr.mind || !(usr.mind in ticker.mode.syndicates))
		to_chat(usr, "<span class='danger'>AUTHENTICATION FAILURE. ACCESS DENIED.</span>")
		return 0
	if(!active)
		active = 1
		workop()
		to_chat(usr, "<span class='notice'>You activate the pinpointer.</span>")
	else
		active = 0
		icon_state = "pinoff"
		to_chat(usr, "<span class='notice'>You deactivate the pinpointer.</span>")
>>>>>>> master



<<<<<<< HEAD
=======
/obj/item/weapon/pinpointer/operative/examine(mob/user)
	..()
	if(active)
		if(nearest_op)
			to_chat(user, "Nearest operative detected is <i>[nearest_op.real_name].</i>")
		else
			to_chat(user, "No operatives detected within scanning range.")
>>>>>>> master
