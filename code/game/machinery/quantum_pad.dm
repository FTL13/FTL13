<<<<<<< HEAD
=======
// Ported from /tg/
// Github Link: https://github.com/tgstation/tgstation
// Majority of the code written by XDTM

>>>>>>> master
/obj/machinery/quantumpad
	name = "quantum pad"
	desc = "A bluespace quantum-linked telepad used for teleporting objects to other quantum pads."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "qpad-idle"
	anchored = 1
	use_power = 1
	idle_power_usage = 200
	active_power_usage = 5000
<<<<<<< HEAD
	unique_rename = 1
=======
>>>>>>> master
	var/teleport_cooldown = 400 //30 seconds base due to base parts
	var/teleport_speed = 50
	var/last_teleport //to handle the cooldown
	var/teleporting = 0 //if it's in the process of teleporting
	var/power_efficiency = 1
	var/obj/machinery/quantumpad/linked_pad = null

/obj/machinery/quantumpad/New()
	..()
	var/obj/item/weapon/circuitboard/machine/B = new /obj/item/weapon/circuitboard/machine/quantumpad(null)
	B.apply_default_parts(src)

/obj/item/weapon/circuitboard/machine/quantumpad
<<<<<<< HEAD
	name = "Quantum Pad (Machine Board)"
=======
	name = "circuit board (Quantum Pad)"
>>>>>>> master
	build_path = /obj/machinery/quantumpad
	origin_tech = "programming=3;engineering=3;plasmatech=3;bluespace=4"
	req_components = list(
							/obj/item/weapon/ore/bluespace_crystal = 1,
							/obj/item/weapon/stock_parts/capacitor = 1,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/stack/cable_coil = 1)
	def_components = list(/obj/item/weapon/ore/bluespace_crystal = /obj/item/weapon/ore/bluespace_crystal/artificial)

/obj/machinery/quantumpad/RefreshParts()
	var/E = 0
	for(var/obj/item/weapon/stock_parts/capacitor/C in component_parts)
		E += C.rating
	power_efficiency = E
	E = 0
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		E += M.rating
	teleport_speed = initial(teleport_speed)
	teleport_speed -= (E*10)
	teleport_cooldown = initial(teleport_cooldown)
	teleport_cooldown -= (E * 100)

/obj/machinery/quantumpad/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user, "pad-idle-o", "qpad-idle", I))
		return

<<<<<<< HEAD
=======
	if(default_unfasten_wrench(user, I))
		power_change()
		return

>>>>>>> master
	if(panel_open)
		if(istype(I, /obj/item/device/multitool))
			var/obj/item/device/multitool/M = I
			M.buffer = src
			to_chat(user, "<span class='notice'>You save the data in the [I.name]'s buffer.</span>")
<<<<<<< HEAD
=======
			to_chat(user, "<span class='notice'>Use of multitool will link the two [src]s; use on subsequent pads will be a one-way link.</span>")
>>>>>>> master
			return 1
	else if(istype(I, /obj/item/device/multitool))
		var/obj/item/device/multitool/M = I
		if(istype(M.buffer, /obj/machinery/quantumpad))
			linked_pad = M.buffer
<<<<<<< HEAD
			to_chat(user, "<span class='notice'>You link the [src] to the one in the [I.name]'s buffer.</span>")
=======
			var/obj/machinery/quantumpad/Q = M.buffer
			if(Q == src)
				linked_pad = null
				to_chat(user, "<span class='notice'>[src] will now cross-link to the next [src] linked to it.</span>")
			else if(!Q.linked_pad || Q.linked_pad == Q)
				Q.linked_pad = src
				to_chat(user, "<span class='notice'>[src] shows a successful cross-link to the [I.name]'s buffer.</span>")
			else
				to_chat(user, "<span class='notice'>You link the [src] to the one in the [I.name]'s buffer.</span>")
>>>>>>> master
			return 1

	if(exchange_parts(user, I))
		return

	if(default_deconstruction_crowbar(I))
		return

	return ..()

/obj/machinery/quantumpad/attack_hand(mob/user)
<<<<<<< HEAD
=======
	if(!anchored)
		to_chat(user, "<span class='warning'>[src] must be anchored before use!</span>")
		return

>>>>>>> master
	if(panel_open)
		to_chat(user, "<span class='warning'>The panel must be closed before operating this machine!</span>")
		return

<<<<<<< HEAD
	if(!linked_pad || QDELETED(linked_pad))
=======
	if(!linked_pad || qdeleted(linked_pad))
>>>>>>> master
		to_chat(user, "<span class='warning'>There is no linked pad!</span>")
		return

	if(world.time < last_teleport + teleport_cooldown)
		to_chat(user, "<span class='warning'>[src] is recharging power. Please wait [round((last_teleport + teleport_cooldown - world.time) / 10)] seconds.</span>")
		return

	if(teleporting)
		to_chat(user, "<span class='warning'>[src] is charging up. Please wait.</span>")
		return

	if(linked_pad.teleporting)
		to_chat(user, "<span class='warning'>Linked pad is busy. Please wait.</span>")
		return

	if(linked_pad.stat & NOPOWER)
		to_chat(user, "<span class='warning'>Linked pad is not responding to ping.</span>")
		return
	src.add_fingerprint(user)
	doteleport(user)
	return

/obj/machinery/quantumpad/proc/sparks()
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(5, 1, get_turf(src))
	s.start()

/obj/machinery/quantumpad/attack_ghost(mob/dead/observer/ghost)
	if(linked_pad)
		ghost.forceMove(get_turf(linked_pad))

/obj/machinery/quantumpad/proc/doteleport(mob/user)
	if(linked_pad)
		playsound(get_turf(src), 'sound/weapons/flash.ogg', 25, 1)
		teleporting = 1

		spawn(teleport_speed)
<<<<<<< HEAD
			if(!src || QDELETED(src))
=======
			if(!src || qdeleted(src))
>>>>>>> master
				teleporting = 0
				return
			if(stat & NOPOWER)
				to_chat(user, "<span class='warning'>[src] is unpowered!</span>")
				teleporting = 0
				return
<<<<<<< HEAD
			if(!linked_pad || QDELETED(linked_pad) || linked_pad.stat & NOPOWER)
=======
			if(!linked_pad || qdeleted(linked_pad) || linked_pad.stat & NOPOWER)
>>>>>>> master
				to_chat(user, "<span class='warning'>Linked pad is not responding to ping. Teleport aborted.</span>")
				teleporting = 0
				return

			teleporting = 0
			last_teleport = world.time

			// use a lot of power
			use_power(10000 / power_efficiency)
			sparks()
			linked_pad.sparks()

			flick("qpad-beam", src)
			playsound(get_turf(src), 'sound/weapons/emitter2.ogg', 25, 1, extrarange = 3, falloff = 5)
			flick("qpad-beam", linked_pad)
			playsound(get_turf(linked_pad), 'sound/weapons/emitter2.ogg', 25, 1, extrarange = 3, falloff = 5)
			for(var/atom/movable/ROI in get_turf(src))
				// if is anchored, don't let through
				if(ROI.anchored)
					if(isliving(ROI))
						var/mob/living/L = ROI
						if(L.buckled)
							// TP people on office chairs
							if(L.buckled.anchored)
								continue
						else
							continue
					else if(!isobserver(ROI))
						continue
				do_teleport(ROI, get_turf(linked_pad))
