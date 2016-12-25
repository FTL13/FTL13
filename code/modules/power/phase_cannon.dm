/obj/machinery/power/shipweapon
	name = "phase cannon"
	desc = "A powerful weapon designed to take down shields.\n<span class='notice'>Alt-click to rotate it clockwise.</span>"
	icon = 'icons/obj/singularity.dmi'
	icon_state = "emitter"
	power_group = POWER_GROUP_PARTIALPOWER
	var/icon_state_on = "emitter_+a"
	anchored = 0
	density = 1
	var/obj/item/weapon/stock_parts/cell/cell
	var/charge_rate = 30000

	var/state = 0
	var/locked = 0

	var/projectile_type = /obj/item/projectile/ship_projectile/phase_blast
	var/projectile_sound = 'sound/effects/phasefire.ogg'


/obj/machinery/power/shipweapon/New()
	..()
	var/obj/item/weapon/circuitboard/machine/B = new /obj/item/weapon/circuitboard/machine/phase_cannon(null)
	B.apply_default_parts(src)
	RefreshParts()

/obj/machinery/power/shipweapon/RefreshParts()
	..()
	cell = null
	for(var/obj/item/weapon/stock_parts/cell/C in component_parts)
		cell = C

/obj/item/weapon/circuitboard/machine/phase_cannon
	name = "circuit board (Phase Cannon)"
	build_path = /obj/machinery/power/shipweapon
	origin_tech = "programming=3;powerstorage=4;combat=4"
	req_components = list(
							/obj/item/weapon/stock_parts/micro_laser = 1,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/stock_parts/cell = 1)

/obj/machinery/power/shipweapon/process()
	power_requested = 0
	if(stat & (BROKEN|MAINT))
		return
	if(state != 2)
		return
	var/load = min((cell.maxcharge-cell.charge)/CELLRATE, charge_rate)		// charge at set rate, limited to spare capacity
	power_requested = load // add the load to the terminal side network
	cell.give(last_power_received * CELLRATE)	// increase the charge

	update_icon()

/obj/machinery/power/shipweapon/proc/can_fire()
	if(state != 2)
		return 0
	return cell.charge >= 200

/obj/machinery/power/shipweapon/proc/attempt_fire(var/datum/component/target_component)
	if(!can_fire())
		return 0
	cell.use(200)

	var/obj/item/projectile/ship_projectile/A = PoolOrNew(projectile_type,src.loc)

	A.setDir(src.dir)
	A.set_data(1,1,0,target_component)
	playsound(src.loc, projectile_sound, 50, 1)
	for(var/obj/machinery/computer/ftl_weapons/C in world)
		if(!istype(get_area(C), /area/shuttle/ftl))
			continue
		if(!(src in C.laser_weapons))
			continue
		playsound(C, projectile_sound, 50, 1)

	if(prob(35))
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(5, 1, src)
		s.start()

	switch(dir)
		if(NORTH)
			A.yo = 20
			A.xo = 0
		if(EAST)
			A.yo = 0
			A.xo = 20
		if(WEST)
			A.yo = 0
			A.xo = -20
		else // Any other
			A.yo = -20
			A.xo = 0
		A.starting = loc
	A.fire()
	update_icon()

	return 1




/obj/machinery/power/shipweapon/verb/rotate()
	set name = "Rotate"
	set category = "Object"
	set src in oview(1)

	if(usr.stat || !usr.canmove || usr.restrained())
		return
	if (src.anchored)
		usr << "<span class='warning'>It is fastened to the floor!</span>"
		return 0
	src.setDir(turn(src.dir, 270))
	return 1

/obj/machinery/power/shipweapon/AltClick(mob/user)
	..()
	if(user.incapacitated())
		user << "<span class='warning'>You can't do that right now!</span>"
		return
	if(!in_range(src, user))
		return
	else
		rotate()

/obj/machinery/power/shipweapon/initialize()
	..()
	if(state == 2 && anchored)
		connect_to_network()

/obj/machinery/power/shipweapon/update_icon()
	if (can_fire())
		icon_state = icon_state_on
	else
		icon_state = initial(icon_state)

/obj/machinery/power/shipweapon/attackby(obj/item/W, mob/user, params)

	if(istype(W, /obj/item/weapon/wrench))
		switch(state)
			if(0)
				if(isinspace()) return
				state = 1
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				user.visible_message("[user.name] secures [src.name] to the floor.", \
					"<span class='notice'>You secure the external reinforcing bolts to the floor.</span>", \
					"<span class='italics'>You hear a ratchet</span>")
				src.anchored = 1
			if(1)
				state = 0
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				user.visible_message("[user.name] unsecures [src.name] reinforcing bolts from the floor.", \
					"<span class='notice'>You undo the external reinforcing bolts.</span>", \
					"<span class='italics'>You hear a ratchet.</span>")
				src.anchored = 0
			if(2)
				user << "<span class='warning'>The [src.name] needs to be unwelded from the floor!</span>"
		return

	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		switch(state)
			if(0)
				user << "<span class='warning'>The [src.name] needs to be wrenched to the floor!</span>"
			if(1)
				if (WT.remove_fuel(0,user))
					playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
					user.visible_message("[user.name] starts to weld the [src.name] to the floor.", \
						"<span class='notice'>You start to weld \the [src] to the floor...</span>", \
						"<span class='italics'>You hear welding.</span>")
					if (do_after(user,20/W.toolspeed, target = src))
						if(!src || !WT.isOn()) return
						state = 2
						user << "<span class='notice'>You weld \the [src] to the floor.</span>"
						connect_to_network()
			if(2)
				if (WT.remove_fuel(0,user))
					playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
					user.visible_message("[user.name] starts to cut the [src.name] free from the floor.", \
						"<span class='notice'>You start to cut \the [src] free from the floor...</span>", \
						"<span class='italics'>You hear welding.</span>")
					if (do_after(user,20/W.toolspeed, target = src))
						if(!src || !WT.isOn()) return
						state = 1
						user << "<span class='notice'>You cut \the [src] free from the floor.</span>"
						disconnect_from_network()
		return

	if(default_deconstruction_screwdriver(user, "emitter_open", "emitter", W))
		return

	if(exchange_parts(user, W))
		return

	if(default_pry_open(W))
		return

	if(default_deconstruction_crowbar(W))
		return

	return ..()
