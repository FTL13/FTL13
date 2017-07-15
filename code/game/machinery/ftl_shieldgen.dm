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

	use_power = 0

	var/plasma_charge = 0
	var/plasma_charge_max = 50
	var/plasma_charge_min = 20

	var/power_charge = 2000
	var/power_charge_max = 2000
	var/power_charge_min = 500


	var/charging_plasma = 0
	var/charging_power = 0
	var/charge_rate = 75000
	var/plasma_charge_rate = 10

	var/power_hitloss = 500
	var/power_passiveloss = 100
	var/plasma_passiveloss = 0.2


	var/list/shield_barrier_objs = list()
	var/on = FALSE
	var/shield_up = FALSE
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

/obj/machinery/ftl_shieldgen/proc/can_terminal_dismantle()
	return 0

/obj/machinery/ftl_shieldgen/proc/disconnect_terminal()
	power_terminal = new(get_step(src, SOUTH))
	power_terminal.dir = NORTH
	power_terminal.master = src
	power_terminal.disconnect_from_network()

/obj/machinery/ftl_shieldgen/process()
	if(stat & (BROKEN|MAINT))
		charging_power = TRUE
		update_icon()
		update_physical()
		return
	if(on)
		if(power_charge < power_charge_max)		// if there's power available, try to charge
			var/load = charge_rate // FUCK seconds
			power_terminal.add_load(load)
			power_charge += min((power_charge_max-power_charge), power_terminal.surplus() * GLOB.CELLRATE)
			charging_power = TRUE
		else
			charging_power = FALSE

	if(power_charge > 0)
		power_charge -= min(power_passiveloss, power_charge)

	update_icon()
	update_physical()

/obj/machinery/ftl_shieldgen/proc/terminal_process_atmos()
	if(stat & (BROKEN|MAINT))
		charging_plasma = TRUE
		return
	if(plasma_charge > 0 && !on)
		plasma_charge -= min(plasma_passiveloss, plasma_charge)
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
		charging_plasma = 0
		update_icon()
		update_physical()
		return
	if(!charging_plasma)
		charging_plasma = TRUE
	var/remove_amount = min(min(cached_gases["plasma"][MOLES], plasma_charge_max-plasma_charge), plasma_charge_rate)
	if(remove_amount > 0)
		plasma_charge += remove_amount
		cached_gases["plasma"][MOLES] -= remove_amount
	else
		charging_plasma = 0
	update_icon()
	update_physical()

/obj/machinery/ftl_shieldgen/update_icon()
	if(charging_plasma || charging_power || (plasma_charge >= (plasma_charge_max*0.25) && power_charge >= (power_charge_max*0.25)))
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]_off"

/obj/machinery/ftl_shieldgen/proc/is_active()
	return on && plasma_charge >= plasma_charge_min && power_charge >= power_charge_min && istype(loc.loc, /area/shuttle/ftl)

/obj/machinery/ftl_shieldgen/proc/take_hit()
	spawn(0)
		sleep(1)
		power_charge -= min(power_hitloss, power_charge)
		update_icon()
		update_physical()
		var/obj/effect/ftl_shield/hitshield = pick(shield_barrier_objs)
		hitshield.impact_effect(10)
		if(!shield_up)
			for(var/area/shuttle/ftl/A in world)
				A << 'sound/weapons/Ship_Hit_Shields_Down.ogg'

/obj/machinery/ftl_shieldgen/proc/raise_physical()
	if(!do_update)
		return
	var/obj/docking_port/mobile/M = SSshuttle.getShuttle("ftl");
	var/list/coords = M.return_coords_abs()
	var/list/shield_turfs = list()
	shield_turfs[locate(coords[1], coords[2], z)] = list(5, 5)
	shield_turfs[locate(coords[3], coords[2], z)] = list(9, 9)
	shield_turfs[locate(coords[1], coords[4], z)] = list(6, 6)
	shield_turfs[locate(coords[3], coords[4], z)] = list(10, 10)
	for(var/turf/T in block(locate(coords[1]+1, coords[2], z), locate(coords[3]-1, coords[2], z)))
		shield_turfs[T] = list(4, 1)

	for(var/turf/T in block(locate(coords[1]+1, coords[4], z), locate(coords[3]-1, coords[4], z)))
		shield_turfs[T] = list(4, 2)

	for(var/turf/T in block(locate(coords[1], coords[2]+1, z), locate(coords[1], coords[4]-1, z)))
		shield_turfs[T] = list(2, 4)

	for(var/turf/T in block(locate(coords[3], coords[2]+1, z), locate(coords[3], coords[4]-1, z)))
		shield_turfs[T] = list(2, 8)

	for(var/turf/T in shield_turfs)
		if(!istype(T.loc, /area/shuttle/ftl))
			continue
		var/list/dirs = shield_turfs[T]
		var/obj/effect/ftl_shield/S = new(T)
		S.dir = dirs[1]
		S.in_dir = dirs[2]
		shield_barrier_objs += S

/obj/machinery/ftl_shieldgen/proc/drop_physical(delayed = 0)
	if(!do_update)
		return
	if(delayed)
		do_update = 0
		while(shield_barrier_objs.len)
			var/obj/to_remove = pick(shield_barrier_objs)
			qdel(to_remove)
			shield_barrier_objs -= to_remove
			if(prob(10))
				sleep(1)
		do_update = 1
	else
		for(var/obj/effect/ftl_shield/S in shield_barrier_objs)
			qdel(S)
		shield_barrier_objs.Cut()

/obj/machinery/ftl_shieldgen/proc/update_physical()
	if(shield_up && power_charge < power_charge_min || plasma_charge < plasma_charge_min)
		if(power_charge < power_charge_min)
			plasma_charge = 0
			drop_physical()
			shield_up = FALSE
		else
			shield_up = TRUE

	if(is_active() && !shield_barrier_objs.len)
		raise_physical()
	else if(!is_active() && shield_barrier_objs.len)
		drop_physical()


/obj/effect/ftl_shield
	name = "Shield"
	desc = "A powerful ship shields. A simple hand weapon would not be enough to take it out."
	icon = 'icons/obj/machines/shielding.dmi'
	icon_state = "shield"
	layer = ABOVE_MOB_LAYER
	density = 1
	alpha = 100
	var/in_dir = 2
	anchored = 1
	pass_flags = LETPASSTHROW

/obj/effect/ftl_shield/CanPass(atom/movable/mover, turf/target, height=0) // Shields are one-way: Shit can leave, but shit can't enter
	if(istype(loc, /turf/open/space/transit))
		return 0
	if(get_dir(src, target) == in_dir)
		return 1
	return 0

/obj/effect/ftl_shield/New(var/newloc)
	..(newloc)
	spawn(1) // Updates neightbors after we're gone.
		for(var/direction in GLOB.cardinal)
			var/turf/T = get_step(src.loc, direction)
			if(T)
				for(var/obj/effect/ftl_shield/F in T)
					F.update_icon()

/obj/effect/ftl_shield/Destroy()
	var/turf/current_loc = get_turf(src)
	spawn(1) // Updates neightbors after we're gone.
		for(var/direction in GLOB.cardinal)
			var/turf/T = get_step(current_loc, direction)
			if(T)
				for(var/obj/effect/ftl_shield/F in T)
					F.update_icon()

/obj/effect/ftl_shield/attack_hand(var/mob/living/user)
	impact_effect(3) // Harmless, but still produces the 'impact' effect.
	..()

/obj/effect/ftl_shield/Bumped(atom/A)
	..(A)
	impact_effect(2)


/obj/effect/ftl_shield/update_icon(var/update_neightbors = 0)
	overlays.Cut()
	var/list/adjacent_shields_dir = list()
	for(var/direction in GLOB.cardinal)
		var/turf/T = get_step(loc, direction)
		if(T) // Incase we somehow stepped off the map.
			for(var/obj/effect/ftl_shield/F in T)
				if(update_neightbors)
					F.update_icon(0)
				adjacent_shields_dir |= direction
				break

	set_light(3, 3, "#66FFFF")

	// Edge overlays
	for(var/found_dir in adjacent_shields_dir)
		add_overlay(image(src.icon, src, "shield_edge", dir = found_dir))


// Small visual effect, makes the shield tiles 	brighten up by becoming more opaque for a moment, and spreads to nearby shields.
obj/effect/ftl_shield/proc/impact_effect(var/i, var/list/affected_shields = list())
	alpha = 200
	animate(src, alpha = initial(alpha), time = 1)
	affected_shields |= src
	i--
	if(i)
		spawn(2)
			for(var/direction in GLOB.cardinal)
				var/turf/T = get_step(src, direction)
				if(T) // Incase we somehow stepped off the map.
					for(var/obj/effect/ftl_shield/F in T)
						if(!(F in affected_shields))
							F.impact_effect(i, affected_shields) // Spread the effect to them.
