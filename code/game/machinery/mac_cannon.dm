/obj/machinery/mac_barrel
	name = "\improper MAC cannon barrel"
	desc = "Make sure this is pointing the right way."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "mac_barrel"

	density = 1
	anchored = 1

	var/obj/machinery/mac_breech/breech = null
	var/id = 0



/obj/machinery/mac_barrel/New()
	..()
	find_breech()

	var/obj/item/weapon/circuitboard/machine/B = new /obj/item/weapon/circuitboard/machine/mac_barrel(null)
	B.apply_default_parts(src)
	RefreshParts()

/obj/item/weapon/circuitboard/machine/mac_barrel
	name = "circuit board (MAC cannon barrel)"
	build_path = /obj/machinery/mac_barrel
	origin_tech = "programming=3;powerstorage=4;combat=4"
	req_components = list(
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/weapon/stock_parts/capacitor = 1,
							/obj/item/weapon/stock_parts/console_screen = 1,)

/obj/machinery/mac_barrel/proc/can_fire()
	.= 0
	if(breech.loader)
		return
	if(breech.charge_process < 100)
		return
	if(breech.flags & NOPOWER)
		return
	return 1

/obj/machinery/mac_barrel/proc/attempt_fire(var/datum/component/target_component)
	if(!can_fire()) return
	spawn toggle_hatch()
	breech.charge_process = 0
	playsound(breech,'sound/weapons/mac_fire.ogg',100,0)
	if(breech.loaded_shell)
		if(breech.loaded_objects.len > 1) // if there is a shell and other shit in the barrel, blow it up
			explosion(breech,1,2,6)
		else
			var/obj/item/projectile/ship_projectile/mac_round/M = PoolOrNew(breech.loaded_shell.projectile,get_step(src,dir))
			M.set_data(breech.loaded_shell.damage,breech.loaded_shell.evasion_mod,breech.loaded_shell.shield_bust,target_component,breech.loaded_shell.armed)
			M.setDir(src,dir)
			M.starting = src.loc
			M.fire()
			fire_sound()
		var/obj/item/weapon/twohanded/required/shell_casing/C = new breech.loaded_shell.casing
		C.forceMove(breech)
		qdel(breech.loaded_shell)
		breech.loaded_objects -= breech.loaded_shell
		breech.loaded_shell = null

	else //otherwise shoot whatever is in the barrel
		for(var/atom/movable/A in breech.loaded_objects)
			A.forceMove(get_step(src,dir))
			if(istype(A,/mob/living/))
				var/mob/living/M = A
				M.Weaken(5)
			var/atom/throw_at = get_edge_target_turf(src, dir)
			A.throw_at_fast(throw_at, 500, 1)

			sleep(2)


/obj/machinery/mac_barrel/proc/toggle_hatch() //just moves the functionality of the massdriver control into the mac cannon, cleaned up a bit
	var/list/activated_doors = list()
	for(var/obj/machinery/door/poddoor/M in machines)
		if(M.id == id)
			activated_doors += M
			spawn(0) M.open()
	sleep(50)

	for(var/obj/machinery/door/poddoor/M in activated_doors)
		spawn(0) M.close()


/obj/machinery/mac_barrel/proc/fire_sound()
	playsound(loc, 'sound/weapons/flashbang.ogg', 100, 1)
	for(var/mob/living/carbon/human/H in range(5,src))
		if(H.check_ear_prot()) continue
		if(!istype(H.loc.loc,/area/shuttle/ftl/munitions)) continue

		H.show_message("<span class='warning'>BANG</span>", 2)
		H.Weaken(5)
		H << sound('sound/weapons/flash_ring.ogg',0,1,0,100) //copied from flashbangs
		H.setEarDamage(H.ear_damage + rand(0, 5), max(H.ear_deaf,15))
		if (H.ear_damage >= 15)
			H << "<span class='warning'>Your ears start to ring badly!</span>"
			if(prob(H.ear_damage - 10 + 5))
				H << "<span class='warning'>You can't hear anything!</span>"
				H.disabilities |= DEAF
		else
			if (H.ear_damage >= 5)
				H << "<span class='warning'>Your ears start to ring!</span>"

/obj/machinery/mac_barrel/proc/find_breech()
	for(var/obj/machinery/mac_breech/P in get_step(src,turn(dir,180)))
		if(istype(P))
			breech = P
			return


/obj/machinery/mac_breech
	name = "\improper MAC cannon breech"
	desc = "You should probably not put your hands in this thing during use."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "mac_breech"

	var/obj/structure/loader/loader = null
	var/list/loaded_objects = list()
	var/obj/structure/shell/loaded_shell = null

	var/charge_process = 100

	active_power_usage = 80000
	idle_power_usage = 300


	density = 1
	anchored = 1

/obj/machinery/mac_breech/New()
	..()
	var/obj/item/weapon/circuitboard/machine/B = new /obj/item/weapon/circuitboard/machine/mac_breech(null)
	B.apply_default_parts(src)
	RefreshParts()


/obj/item/weapon/circuitboard/machine/mac_breech
	name = "circuit board (MAC cannon breech)"
	build_path = /obj/machinery/mac_breech
	origin_tech = "programming=3;powerstorage=4;combat=4"
	req_components = list(
							/obj/item/weapon/stock_parts/scanning_module = 1,
							/obj/item/weapon/stock_parts/capacitor = 1,
							/obj/item/weapon/stock_parts/console_screen = 1,)


/obj/machinery/mac_breech/process()
	if(stat & NOPOWER)
		return
	var/is_charged = charge_process >= 100
	if(charge_process <= 0)
		use_power = 2
		playsound(src,'sound/weapons/mac_charge.ogg',100,0)
	charge_process = min(100,charge_process + 20) // 10 seconds to charge
	if(charge_process >= 100 && !is_charged)
		use_power = 1
		playsound(src,'sound/weapons/mac_hold.ogg',100,0)


	update_icon()


/obj/machinery/mac_breech/Entered(var/atom/A)
	loaded_objects += A
	if(istype(A,/obj/structure/shell))
		loaded_shell = A //You can't really load more than one shell at a time without adminbus.
		playsound(src,'sound/effects/breech_load.ogg',100,0)

/obj/machinery/mac_breech/Exited(var/atom/A)
	loaded_objects -= A

	if(A == loaded_shell)
		loaded_shell = null

/obj/machinery/mac_breech/attack_hand(mob/user)
	var/loaded_shell
	for(var/obj/structure/shell/S in loaded_objects)
		if(S.armed)
			loaded_shell = 1
	if(loaded_shell)
		var/choice = input("WARNING: There is a loaded shell inside the MAC cannon! Are you sure you want to open it?", "WARNING!", "No") in list("Yes", "No")
		if(choice != "Yes")
			return
		message_admins("[key_name_admin(user)] (<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[user]'>FLW</A>) opened an armed MAC cannon!")
	toggle_loader()

/obj/machinery/mac_breech/proc/throw_loader()
	var/atom/target = get_edge_target_turf(src, turn(dir,180))
	for(var/atom/movable/A in loader.loc.contents)
		if(A.anchored) continue
		A.throw_at_fast(target, 50, 5)

/obj/machinery/mac_breech/proc/toggle_loader()
	if(!loader)
		loader = new
		loader.loc = get_step(src,turn(dir,180))
		loader.dir = turn(dir,180)

		for(var/atom/movable/A in loaded_objects)
			A.forceMove(loader.loc)
		throw_loader()

		playsound(src,'sound/effects/breech_open.ogg',100,0)
		return

	if(loader)

		for(var/atom/movable/A in loader.loc.contents)
			if(A.anchored) continue
			A.forceMove(src)

		qdel(loader)
		loader = null

		playsound(src,'sound/effects/breech_close.ogg',100,0)

		return




/obj/structure/loader
	name = "breech loader"
	desc = "Put anything you want to stuff into the MAC cannon on this."

	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "loader"

	density = 0
	anchored = 1

	layer = BELOW_OBJ_LAYER
	pass_flags = LETPASSTHROW

/obj/structure/loader/rack
	name = "ammo rack loading tray"
	desc = "Make sure you insert the right end in first."

/obj/structure/loader/Crossed()
	..()
	playsound(src,'sound/effects/breech_slam.ogg',100,0)

/obj/machinery/ammo_rack
	name = "ammunition rack"
	desc = "A secure and reinforced magazine for storing explosive ordanance."

	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "ammo_rack"

	density = 1
	anchored = 1

	var/shell_capacity = 5

	var/list/loaded_shells = list()
	var/obj/structure/loader/rack/loader = null

/obj/machinery/ammo_rack/New()
	..()
	generate_shells()

/obj/machinery/ammo_rack/Entered(var/atom/A)
	loaded_shells += A

/obj/machinery/ammo_rack/Exited(var/atom/A)
	loaded_shells -= A




/obj/machinery/ammo_rack/proc/generate_shells()
	return

/obj/machinery/ammo_rack/proc/check_loader()
	. = 1
	for(var/atom/movable/A in loader.loc)
		if(!istype(A,/obj/structure/shell) && !A.anchored) return 0

/obj/machinery/ammo_rack/attack_hand(mob/user)
	toggle_loader()

/obj/machinery/ammo_rack/proc/toggle_loader()
	if(!loader)
		loader = new
		loader.loc = get_step(src,turn(dir,180))
		loader.dir = turn(dir,180)

		playsound(src,'sound/effects/breech_open.ogg',100,0)
		return

	if(loader)
		if(!check_loader()) //make sure only shells are being loaded
			visible_message("\icon[src] <span class=notice>A light on the ammo rack blinks red as it detects a foreign object in the loading tray.</span>")
			return

		else

			for(var/atom/movable/A in loader.loc.contents)
				if(A.anchored) continue
				if(loaded_shells.len >= shell_capacity)
					visible_message("\icon[src] <span class=notice>A light on the ammo rack blinks red as the rack is already full to capacity.</span>")
					return
				A.forceMove(src)

			qdel(loader)
			loader = null

			playsound(src,'sound/effects/breech_close.ogg',100,0)

/obj/machinery/ammo_rack/proc/dispense_ammo()
	if(!loaded_shells.len)
		return
	var/turf/T = get_step(src,dir)
	for(var/atom/movable/A in T)
		if(A.density)
			visible_message("\icon[src] <span class=notice>A light on the ammo rack blinks red as the unloading port is obstructed.</span>")
			return
	var/obj/structure/shell/S = loaded_shells[1] //ammo racks use a FIFO structure
	S.forceMove(T)
	flick("ammo_rack_dispense",src)

/obj/machinery/ammo_rack/full
	name = "ammunition rack (HE)"
	var/shell_type = /obj/structure/shell

/obj/machinery/ammo_rack/full/generate_shells()
	for(var/i = 1 to shell_capacity)
		var/obj/structure/shell/S = new shell_type
		S.forceMove(src)

/obj/machinery/ammo_rack/full/shield_piercing
	name = "ammunition rack (SP)"
	shell_type = /obj/structure/shell/shield_piercing

/obj/machinery/ammo_rack/full/smart_homing
	name = "ammunition rack (SH)"
	shell_type = /obj/structure/shell/smart_homing
