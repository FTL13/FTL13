/obj/machinery/ftl_shieldgen
	name = "Shield Generator"
	anchored = 1
	density = 1
	layer = FLY_LAYER
	bound_x = -32
	bound_y = 0
	bound_width = 96
	bound_height = 64
	pixel_x = -32
	icon = 'icons/obj/96x96.dmi'
	icon_state = "shield_gen"
	var/obj/machinery/atmospherics/components/unary/terminal/atmos_terminal
	var/obj/machinery/power/terminal/power_terminal

	use_power = FALSE

	var/plasma_charge = 100
	var/plasma_charge_max = 100

	var/power_charge = 4000
	var/power_charge_max = 4000

	var/charging_plasma = FALSE
	var/charging_power = FALSE

	var/load = 50000

	var/minimal_power_charge = 500 //Need this amount of power to be active
	var/minimal_plasma_charge = 50 //Need this amount of plasma to be active

	var/power_charge_rate = 200 //lol is this fast who knows, I dont.
	var/plasma_charge_rate = 10

	var/list/shield_barrier_objs = list()

	var/on = FALSE //Are we turned on o3o
	var/shield_active = FALSE //IS THE SERVER UP???????
	var/do_update = TRUE

/obj/machinery/ftl_shieldgen/New()
	..()
	if(!atmos_terminal)
		atmos_terminal = new(loc)
		atmos_terminal.master = src
	if(!power_terminal)
		power_terminal = new(get_step(src, SOUTH))
		power_terminal.dir = NORTH
		power_terminal.master = src
		power_terminal.connect_to_network()

/obj/machinery/ftl_shieldgen/Destroy()
	atmos_terminal.master = null
	qdel(atmos_terminal)
	atmos_terminal = null
	if(SSstarmap.ftl_shieldgen == src)
		SSstarmap.ftl_shieldgen = null
	. = ..()

/obj/machinery/ftl_shieldgen/Initialize()
	. = ..()
	if(!istype(get_area(src), /area/shuttle/ftl) || (SSstarmap.ftl_shieldgen && isturf(SSstarmap.ftl_shieldgen.loc)))
		stat |= BROKEN
		return
	SSstarmap.ftl_shieldgen = src
	update_physical()

/obj/machinery/ftl_shieldgen/proc/can_terminal_dismantle()
	return FALSE

/obj/machinery/ftl_shieldgen/proc/disconnect_terminal()
	power_terminal = new(get_step(src, SOUTH))
	power_terminal.dir = NORTH
	power_terminal.master = src
	power_terminal.disconnect_from_network()

/obj/machinery/ftl_shieldgen/process()
	if(stat & (BROKEN|MAINT)) //Are we broken?
		charging_power = FALSE
		update_icon()
		update_active()
		return
	if(power_terminal.avail(load))		// if there's power available, try to charge
		if(power_charge < power_charge_max) //If we aren't full charge, try adding some
			power_terminal.add_load(load)
			power_charge = min(power_charge_max, power_charge + power_charge_rate)
			charging_power = TRUE
		else //Else, we're not charging
			charging_power = FALSE
	else
		charging_power = FALSE

	update_icon()
	update_active()

/obj/machinery/ftl_shieldgen/proc/terminal_process_atmos()
	if(stat & (BROKEN|MAINT))
		charging_plasma = FALSE
		return
	var/datum/gas_mixture/air1 = atmos_terminal.AIR1
	var/list/cached_gases = air1.gases
	air1.assert_gas("plasma")
	if(cached_gases.len > 1) //If it contains anything other than plasma, eject it
		var/plasma = cached_gases["plasma"][MOLES] //don't eject the plasma
		cached_gases["plasma"][MOLES] = 0
		var/datum/gas_mixture/temp_air = air1.remove(air1.total_moles())
		var/turf/T = get_turf(src)
		T.assume_air(temp_air)
		air_update_turf()
		air1.assert_gas("plasma")
		cached_gases["plasma"][MOLES] = plasma
		air1.garbage_collect()
	if(!atmos_terminal.NODE1 || !atmos_terminal.AIR1 || !("plasma" in cached_gases) || cached_gases["plasma"][MOLES] <= 5) // Turn off if the machine won't work.
		charging_plasma = FALSE
		update_icon()
		update_active()
		return
	if(!charging_plasma)
		charging_plasma = TRUE
	var/remove_amount = min(min(cached_gases["plasma"][MOLES], plasma_charge_max-plasma_charge), plasma_charge_rate)
	if(remove_amount > 0)
		plasma_charge += remove_amount
		cached_gases["plasma"][MOLES] -= remove_amount
	else
		charging_plasma = FALSE
	update_icon()
	update_active()

/obj/machinery/ftl_shieldgen/update_icon()
	if(charging_plasma || charging_power || (plasma_charge >= (plasma_charge_max*0.25) && power_charge >= (power_charge_max*0.25)))
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]_off"

/obj/machinery/ftl_shieldgen/proc/is_active() //Can we protect from incoming attacks?
	return on && plasma_charge >= minimal_plasma_charge && power_charge >= minimal_power_charge && istype(loc.loc, /area/shuttle/ftl)

/obj/machinery/ftl_shieldgen/proc/update_active()
	var/temp_active = is_active()
	if(shield_active != temp_active) //Has our state changed since last time? then update our physical state
		shield_active = temp_active
		update_physical()

/obj/machinery/ftl_shieldgen/proc/take_hit(shield_damage, var/hitsound = 'sound/weapons/Ship_Hit_Shields.ogg',var/volume = 100)
	power_charge = max(0, power_charge - shield_damage)
	if(!is_active()) //If the shield has lost too much power due to this hit, our plasma escapes the energy barrier
		plasma_charge = 0
		SSstarmap.ftl_sound('sound/weapons/ship_hit_shields_down.ogg', volume)
	else
		SSstarmap.ftl_sound(hitsound, volume)

	update_icon()
	update_active()

/obj/machinery/ftl_shieldgen/proc/raise_physical()
	for(var/S in GLOB.ftl_shields)
		var/obj/effect/ftl_shield/shield = S
		shield.active = TRUE
		shield.alpha = 100
		shield.update_icon()

/obj/machinery/ftl_shieldgen/proc/drop_physical()
	for(var/S in GLOB.ftl_shields)
		var/obj/effect/ftl_shield/shield = S
		shield.active = FALSE
		shield.alpha = 0
		shield.update_icon()

/obj/machinery/ftl_shieldgen/proc/update_physical()
	if(shield_active)
		raise_physical()
	else
		drop_physical()

/obj/effect/ftl_shield
	name = "Shield"
	desc = "A powerful ship shields. A simple hand weapon would not be enough to take it out."
	icon = 'icons/effects/effects.dmi'
	icon_state = "ftl_shield"
	density = 1
	alpha = 100
	var/active = FALSE
	anchored = 1
	pass_flags = LETPASSTHROW

	var/list/adjacent_shields_dir = list()

/obj/effect/ftl_shield/Initialize()
	. = ..()
	GLOB.ftl_shields += src //Add to list of shield objects
	set_adjacencies()
	update_icon()

/obj/effect/ftl_shield/forceMove(turf/target) //Don't move this effect during FTL
	return

/obj/effect/ftl_shield/CanPass(atom/movable/mover, turf/target, height=0) //Shields are just open because that shit is dumb
	if(istype(mover,/obj/effect/meteor))
		if(active)
			var/obj/effect/meteor/M = mover
			SSstarmap.ftl_shieldgen.take_hit(M.hits*M.hitpwr* 20, 'sound/weapons/ship_hit_shields.ogg',50) //Damage ranges from 60 for dust to 240 for large meteors.
			impact_effect(M.hits*M.hitpwr) //Effect ranges from 3 for dust and 12 for large meteor
			SSship.broadcast_message("<span class=warning>Impact detected from a meteor! Hit absorbed by shields.",SSship.error_sound)
			qdel(mover) //Now delete the meteor
			return
	return TRUE

/obj/effect/ftl_shield/Destroy()
	.=..()
	update_icon()
	set_adjacencies(TRUE)

/obj/effect/ftl_shield/ex_act()
	return 0

/obj/effect/ftl_shield/attack_hand(var/mob/living/user)
	.=..()
	impact_effect(3) // Harmless, but still produces the 'impact' effect.

/obj/effect/ftl_shield/update_icon(var/update_neighbors = 0)
	if(active)
		set_light(3, 3, "#66FFFF")
	else
		set_light(0, 0, "#66FFFF")

// Small visual effect, makes the shield tiles 	brighten up by becoming more opaque for a moment, and spreads to nearby shields.
/obj/effect/ftl_shield/proc/impact_effect(var/i, var/list/affected_shields = list())
	if(active) //This prevents the effect from revealing dropped shields
		alpha = 200
		animate(src, alpha = initial(alpha), time = 2)
		affected_shields[src] = TRUE
		i--
		if(i)
			addtimer(CALLBACK(src, .proc/spread_impact, i, affected_shields), 2)

/obj/effect/ftl_shield/proc/set_adjacencies(var/update_neighbors = 0)
	var/list/adjacent_shields_dir = list()
	overlays.Cut()
	for(var/direction in GLOB.cardinals)
		var/turf/T = get_step(loc, direction)
		if(T) // Incase we somehow stepped off the map.
			for(var/obj/effect/ftl_shield/F in T)
				if(update_neighbors)
					F.update_icon()
				adjacent_shields_dir |= direction
				break

	for(var/found_dir in adjacent_shields_dir)
		add_overlay(image(src.icon, src, "ftl_shield_edge", dir = found_dir))

/obj/effect/ftl_shield/proc/spread_impact(var/i, var/list/affected_shields = list())
	for(var/direction in GLOB.cardinals)
		var/turf/T = get_step(src, direction)
		if(T) // Incase we somehow stepped off the map.
			for(var/obj/effect/ftl_shield/F in T)
				if(!(affected_shields[F]))
					F.impact_effect(i, affected_shields) // Spread the effect to them.
