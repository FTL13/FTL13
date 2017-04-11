/obj/machinery/fusion
	var/master
	var/list/mods
	var/mod_slots = 3
	var/fusion_machine
	var/power = 0
	
/obj/machinery/fusion/attackby(obj/item/I, mob/user, params)
	if(istype(I,/obj/item/weapon/fusion_mod))
		switch(add_part(I)) //Do bitflags maybe?
			if(0)
				user << "<span class='caution'>You install the mod.</span>"
			if(1)
				user << "<span class='caution'>This component has no slots for mods left!</span>"
			if(2)
				user << "<span class='caution'>This mod seems broken, you may want to reconstruct the engine component.</span>"
			if(4)
				user << "<span class='caution'>This mod is incompatible with an instaled mod.</span>"
			if(8)
				user << "<span class='caution'>This mod is incompatible with this machine.</span>"
	..()
	
/obj/machinery/fusion/proc/toggle_power()
	power = !power
	
/obj/machinery/fusion/proc/add_part(I)
	var/obj/item/weapon/fusion_mod/M = I
	if(istype(M))
		if(mods.len == 3)
			return 1 //Failure code for full slots
		if(M.machine != fusion_machine)
			return 8 //Failure code for incorrect machine type
		mods += M
		return(RefreshParts())
	
/obj/machinery/fusion/RefreshParts()
	var/list/initialized //mods that succeded in getting added
	var/list/failed //mods that are incompatible with the machine
	var/i = 0
	var/fail_code = 0 //0 is no failure
	while(mods.len > 0 && i < 10)
		for(var/obj/item/weapon/fusion_mod/M in mods)
			switch(M.get_effects(src))
				if(0)
					failed += M
					mods -= M
				if(1)
					initialized += M
					mods -= M
				if(2)
					continue
		i++
	failed += mods
	mods = initialized
	if(i == 10)
		message_admins("<span class='warning'>An engine mod arangement failed to initialize. Failed:[failed], Succeded:[mods].</span>")
		fail_code = 2 //Failure code for badly coded mod
	if(failed.len > 0)
		fail_code = 4 //Failure code for incompatible mods
	return(fail_code)