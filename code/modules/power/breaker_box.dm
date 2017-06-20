// AI has ability to toggle it in 5 seconds
// Humans need 30 seconds
// Used for advanced grid control (read: Substations)

/obj/machinery/power/breakerbox
	name = "Breaker Box"
	desc = "Large machine with heavy duty switching circuits used for advanced grid control. It is online."
	icon = 'icons/obj/power.dmi'
	icon_state = "bbox_on"
	density = 1
	anchored = 1
	var/on = 1
	var/busy = 0
	var/update_locked = 0

/obj/machinery/power/breakerbox/Initialize()
	. = ..()
	set_state(1)

/obj/machinery/power/breakerbox/update_icon()
	if(on)
		icon_state = "bbox_on"
		desc = "Large machine with heavy duty switching circuits used for advanced grid control. It is online."
	else
		icon_state = "bbox_off"
		desc = "Large machine with heavy duty switching circuits used for advanced grid control. It is offline."

/obj/machinery/power/breakerbox/attack_ai(mob/user)
	toggle_breaker(user, 1)

/obj/machinery/power/breakerbox/attack_hand(mob/user)
	toggle_breaker(user, 0)

/obj/machinery/power/breakerbox/proc/toggle_breaker(mob/user, is_ai)
	if(update_locked)
		to_chat(user, "<span class='warning'>System locked. Please try again later.</span>")
		return

	if(busy)
		to_chat(user, "<span class='warning'>System is busy. Please wait until current operation is finished before changing power settings.</span>")
		return

	busy = 1
	user.visible_message("<span class='warning'>\The [user] starts reprogramming \the [src]!</span>","<span class='warning'>You start reprogramming \the [src]!</span>")
	if(do_after(user, 50,src))
		set_state(!on)
		user.visible_message(\
		"<span class='notice'>[user.name] [on ? "enabled" : "disabled"] the breaker box!</span>",\
		"<span class='notice'>You [on ? "enabled" : "disabled"] the breaker box!</span>")
		update_locked = 1
		if(is_ai) //AHHHHHHHH HOW DOES ADDTIMER WORK
			//addtimer(CALLBACK(src, .proc/procthatdoesstuffyouwant, args), time) //AI is fast
			spawn(50) //AI is fast
				update_locked = 0
		else
			//addtimer(CALLBACK(src, .proc/procthatdoesstuffyouwant, args), time) //People are slow
			spawn(300) //People are slow
				update_locked = 0
	busy = 0

/obj/machinery/power/breakerbox/proc/set_state(var/state)
	on = state
	update_icon()
	if(on)
		var/list/connection_dirs = list()
		for(var/direction in GLOB.cardinal)
			for(var/obj/structure/cable/C in get_step(src,direction))
				if(C.d1 == turn(direction, 180) || C.d2 == turn(direction, 180))
					connection_dirs += direction
					break

		for(var/direction in connection_dirs)
			var/obj/structure/cable/C = new/obj/structure/cable(src.loc)
			C.d1 = 0
			C.d2 = direction
			C.icon_state = "[C.d1]-[C.d2]"
			C.breaker_box = src

			var/datum/powernet/PN = new()
			PN.add_cable(C)

			C.mergeConnectedNetworks(C.d2)
			C.mergeConnectedNetworksOnTurf()

			if(C.d2 & (C.d2 - 1))// if the cable is layed diagonally, check the others 2 possible directions
				C.mergeDiagonalsNetworks(C.d2)
	else
		for(var/obj/structure/cable/C in src.loc)
			qdel(C)

/obj/machinery/power/breakerbox/process()
	return 1
