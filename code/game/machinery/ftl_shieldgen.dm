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
	var/plasma_charge = 0
	var/plasma_charge_max = 40
	var/power_charge = 90
	var/power_charge_max = 90
	var/charging_plasma = 0
	var/charging_power = 0
	var/charge_rate = 30000
	var/plasma_charge_rate = 10
	var/list/shield_barrier_objs = list()
	var/on = 1
	var/do_update = 1

/obj/machinery/ftl_shieldgen/New()
	..()
	if(!atmos_terminal)
		atmos_terminal = new(loc)
		atmos_terminal.master = src
	if(!power_terminal)
		power_terminal = new(get_step(src, SOUTH))
		power_terminal.dir = NORTH
		power_terminal.master = src
		power_terminal.set_power_group(POWER_GROUP_PARTIALPOWER)
	if(map_ready)
		initialize()

/obj/machinery/ftl_shieldgen/Destroy()
	atmos_terminal.master = null
	qdel(atmos_terminal)
	atmos_terminal = null
	if(SSstarmap.ftl_shieldgen == src)
		SSstarmap.ftl_shieldgen = null
	. = ..()

/obj/machinery/ftl_shieldgen/initialize()
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
	power_terminal.set_power_group(POWER_GROUP_PARTIALPOWER)

/obj/machinery/ftl_shieldgen/process()
	power_terminal.power_requested = 0
	if(stat & (BROKEN|MAINT))
		charging_power = 0
		update_icon()
		update_physical()
		return
	if(power_charge < power_charge_max)		// if there's power available, try to charge
		var/load = charge_rate		// FUCK SEC
		power_terminal.power_requested = load
		power_charge += min((power_charge_max-power_charge), power_terminal.last_power_received * CELLRATE)
		charging_power = 1
	else
		charging_power = 0

	update_icon()
	update_physical()

/obj/machinery/ftl_shieldgen/proc/terminal_process_atmos()
	if(stat & (BROKEN|MAINT))
		charging_plasma = 0
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
		charging_plasma = 0
		update_icon()
		update_physical()
		return
	if(!charging_plasma)
		charging_plasma = 1
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
	return on && plasma_charge >= plasma_charge_max && power_charge >= power_charge_max && istype(loc.loc, /area/shuttle/ftl)

/obj/machinery/ftl_shieldgen/proc/take_hit()
	spawn(0)
		drop_physical(1)
		sleep(1)
		plasma_charge *= 0.25
		power_charge *= 0.25
		update_icon()
		update_physical()

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
		if(!istype(T, /turf/open/space))
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
	if(is_active() && !shield_barrier_objs.len)
		raise_physical()
	else if(!is_active() && shield_barrier_objs.len)
		drop_physical()

/obj/effect/ftl_shield
	name = "Shield"
	desc = "A powerful ship shields. A simple hand weapon would not be enough to take it out."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shieldwall"
	density = 1
	var/in_dir = 2
	anchored = 1
	pass_flags = LETPASSTHROW

/obj/effect/ftl_shield/CanPass(atom/movable/mover, turf/target, height=0) // Shields are one-way: Shit can leave, but shit can't enter
	if(istype(loc, /turf/open/space/transit))
		return 0
	if(get_dir(src, target) == in_dir)
		return 1
	return 0
