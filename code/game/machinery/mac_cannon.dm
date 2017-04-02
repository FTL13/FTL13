/obj/machinery/mac_barrel
	name = "\improper MAC cannon barrel"
	desc = "Make sure this is pointing the right way."
	icon = 'icons/obj/96x96.dmi'
	icon_state = "mac_barrel"
	pixel_x = -32
	pixel_y = -32

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

/obj/machinery/mac_barrel/proc/can_fire(console=FALSE)
	. = 0
	if(breech.loader)
		return
	if(breech.charge_process < 100)
		return
	if(breech.flags & NOPOWER)
		return
	if(breech.actuator.spent || !breech.actuator)
		if(!console)
			visible_message("\icon[src] <span class=notice>Error. Firing actuator missing or broken. Unable to fire.</span>")
			playsound(loc,'sound/machines/buzz-sigh.ogg',50,0)
			return
	return 1

/obj/machinery/mac_barrel/proc/attempt_fire(var/datum/component/target_component)
	if(!can_fire()) return
	if(prob(5))
		breech.actuator.spent = 1
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(3, 1, src)
		s.start()
	spawn toggle_hatch()
	breech.charge_process = 0
	playsound(breech,'sound/weapons/mac_fire.ogg',100,0)
	if(breech.panel_open)
		visible_message("<span class=userdanger>Arcs of electricity fly out of the MAC cannon's open maintenance panel!</span>")
		tesla_zap(breech,5,30000) //dayum son, get roasted. This will seriously cuck anyone in the munitions bay.
	if(breech.loaded_shell)
		if(breech.loaded_objects.len > 1||!breech.alignment) // if there is a shell and other shit in the barrel, blow it up
			explosion(breech,1,2,6)
		else
			var/obj/item/projectile/ship_projectile/mac_round/M = PoolOrNew(breech.loaded_shell.projectile,get_step(src,dir))
			if(breech.loaded_shell.armed)
				M.attack_data = breech.loaded_shell.attack_data
			M.target = target_component
			M.setDir(src,dir)
			M.starting = src.loc
			M.fire()
			fire_sound()
		var/obj/item/weapon/twohanded/required/shell_casing/C = new breech.loaded_shell.casing
		C.forceMove(breech)
		qdel(breech.loaded_shell)
		breech.loaded_objects -= breech.loaded_shell
		breech.loaded_shell = null
		if(prob(20))
			breech.alignment = max(0,breech.alignment - 0.1) //20% chance the barrel becomes 10% more inaccurate

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
		if(M.id && M.id == id)
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
	icon = 'icons/obj/96x96.dmi'
	icon_state = "mac_breech"
	pixel_x = -32
	pixel_y = -32

	var/obj/structure/loader/loader = null
	var/list/loaded_objects = list()
	var/obj/structure/shell/loaded_shell = null
	var/obj/item/weapon/twohanded/required/firing_actuator/actuator = new
	flags = OPENCONTAINER
	var/charge_process = 100

	active_power_usage = 80000
	idle_power_usage = 300

	var/alignment = 1 //coeff from 0 to 1


	density = 1
	anchored = 1

/obj/machinery/mac_breech/New()
	..()
	var/obj/item/weapon/circuitboard/machine/B = new /obj/item/weapon/circuitboard/machine/mac_breech(null)
	B.apply_default_parts(src)
	RefreshParts()
	create_reagents(1000)
	reagents.add_reagent("oil",50)

/obj/machinery/mac_breech/on_reagent_change()
	for(var/reagent in reagents.reagent_list)
		var/datum/reagent/R = reagent
		if(R.id != "oil")
			visible_message("\icon[src] <span class=warning>Warning: foreign contaminant found in lubricant chamber, activating emergency dump.</span>")
			reagents.clear_reagents()
			return


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
	if(istype(A,/obj/item/weapon/twohanded/required/firing_actuator))
		return
	loaded_objects += A
	if(istype(A,/obj/structure/shell))
		loaded_shell = A //You can't really load more than one shell at a time without adminbus.
		playsound(src,'sound/weapons/mac_load.ogg',100,0)

/obj/machinery/mac_breech/Exited(var/atom/A)
	loaded_objects -= A

	if(A == loaded_shell)
		loaded_shell = null

/obj/machinery/mac_breech/attack_hand(mob/user)
	if(!reagents.has_reagent("oil"))
		user << "<span class=warning>Try as you might you can't pry open the MAC cannon's breach as its hinges are stuck.</span>"
		return
	reagents.remove_reagent("oil",rand(1,3))
	var/loaded_shell
	for(var/obj/structure/shell/S in loaded_objects)
		if(S.armed)
			loaded_shell = 1
	if(loaded_shell)
		var/choice = input("WARNING: There is a loaded shell inside the MAC cannon! Opening it may cause severe damage to the ship, are you sure you wish to open it?", "WARNING!", "No") in list("Yes", "No")
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
	. = update_icon()
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

/obj/machinery/mac_breech/attackby(obj/item/O, mob/user, params)

	if(default_deconstruction_screwdriver(user, "mac_breech_o", "mac_breech", O))
		updateUsrDialog()
		update_icon()
		return

	if(panel_open)
		if(istype(O, /obj/item/weapon/crowbar))
			if(actuator)
				actuator.forceMove(src.loc)
				if(actuator.spent)
					user.visible_message("<span class=notice>[user]pries out the cannon's fried firing actuator.</span>","<span class=notice>You pry out the cannon's broken firing actuator.</span>")
					actuator.icon_state = "firing_actuator_smoked"
				else
					user.visible_message("<span class='notice'>[user] pries out the cannon's actuator.</span>", "<span class='notice'>You pry out the cannon's firing actuator.</span>")
				actuator = null
		if(istype(O,/obj/item/weapon/twohanded/required/firing_actuator))
			if(actuator)
				user << "<span class=notice>There is already a firing actuator loaded into the cannon.</span>"
				return
			else
				if(!user.drop_item())
					return
				user.visible_message("<span class='notice'>[user] inserts a new firing actuation into the MAC cannon's breech..</span>", "<span class='notice'>You insert a new firing actuator into the cannon's breech.</span>")
				O.forceMove(src)
				actuator = O

		if(istype(O,/obj/item/device/multitool))
			alignment = 1
			if(actuator.spent)
				user<< "<span class=notice>You try to realign the firing coils in the MAC cannon's breech but they're all burnt out.</span>"
				return
			else
				user.visible_message("<span class=notice>[user] realigns the firing coils in the MAC cannon's breech with their multitool.</span>","<span class=notice>You realign the firing coils in the MAC cannon's breech with your multitool.</span>")
			if(prob(10))
				visible_message("<span class=warning>The MAC cannon sparks as its firing coil burns out!</span>")
				actuator.spent = 1
				var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
				s.set_up(3, 1, src)
				s.start()


	if(user.a_intent == "harm")
		return ..()

/obj/machinery/mac_breech/update_icon()
	if(panel_open)
		if(loaded_shell && loaded_shell.armed)
			icon_state = "mac_breech_o_a"
			return
		if(loaded_shell)
			icon_state = "mac_breech_o_i"
			return
		else
			icon_state = "mac_breech_o"
	else
		if(loaded_shell && loaded_shell.armed)
			icon_state = "mac_breech_a"
			return
		if(loaded_shell)
			icon_state = "mac_breech_i"
			return
		else
			icon_state = "mac_breech"







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
	layer = 3.1

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

/obj/item/weapon/twohanded/required/firing_actuator
	name = "cannon firing actuator"
	desc = "The actuator that releases the charged up energy of the MAC cannon and allows it to fire. Tends to burn out."
	icon = 'icons/obj/stationobjs.dmi' //for simplicity
	icon_state = "firing_actuator"
	item_state = "casing"

	w_class = 4

	force = 10

	force_unwielded = 10
	force_wielded = 10

	var/spent = 0
