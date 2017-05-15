/obj/machinery/ftl_drive
	name = "FTL Drive"
	anchored = 1
	density = 1
	layer = FLY_LAYER
	bound_x = -32
	bound_y = 0
	bound_width = 96
	bound_height = 64
	pixel_x = -32
	icon = 'icons/obj/96x96.dmi'
	icon_state = "ftl_drive"
	var/obj/machinery/atmospherics/components/unary/terminal/atmos_terminal
	var/obj/machinery/power/terminal/power_terminal
	var/plasma_charge = 0
	var/plasma_charge_max = 900
	var/power_charge = 0
	var/power_charge_max = 2700
	var/charging_plasma = 0
	var/charging_power = 0
	var/charge_rate = 30000
	var/plasma_charge_rate = 10

/obj/machinery/ftl_drive/New()
	..()
	if(!atmos_terminal)
		atmos_terminal = new(loc)
		atmos_terminal.master = src
	if(!power_terminal)
		power_terminal = new(get_step(src, SOUTH))
		power_terminal.dir = NORTH
		power_terminal.master = src
		power_terminal.connect_to_network()
	if(GLOB.map_ready)
		Initialize()

/obj/machinery/ftl_drive/Destroy()
	atmos_terminal.master = null
	qdel(atmos_terminal)
	atmos_terminal = null
	if(SSstarmap.ftl_drive == src)
		SSstarmap.ftl_drive = null
	. = ..()

/obj/machinery/ftl_drive/Initialize()
	if(!istype(get_area(src), /area/shuttle/ftl) || (SSstarmap.ftl_drive && isturf(SSstarmap.ftl_drive.loc)))
		stat |= BROKEN
		return
	SSstarmap.ftl_drive = src

/obj/machinery/ftl_drive/proc/can_terminal_dismantle()
	return 0

/obj/machinery/ftl_drive/proc/disconnect_terminal()
	power_terminal = new(get_step(src, SOUTH))
	power_terminal.dir = NORTH
	power_terminal.master = src
	power_terminal.disconnect_from_network()

/obj/machinery/ftl_drive/process()
	if(SSstarmap.in_transit || SSstarmap.in_transit_planet)	//doesn't let ftl drive charge POWER whilst in transit
		return
	if(stat & (BROKEN|MAINT))
		charging_power = 0
		update_icon()
		return
	if(power_charge < power_charge_max)		// if there's power available, try to charge
		var/load = charge_rate		// FUCK SEC
		power_terminal.add_load(load)
		power_charge += min(power_charge_max-power_charge, power_terminal.last_power_received * CHARGELEVEL)
		charging_power = 1
	else
		charging_power = 0

	update_icon()

/obj/machinery/ftl_drive/proc/terminal_process_atmos()
	if(SSstarmap.in_transit || SSstarmap.in_transit_planet)	//doesn't let ftl drive charge PLASMA whilt in transit
		return
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

/obj/machinery/ftl_drive/update_icon()
	if(charging_plasma || charging_power || (plasma_charge >= (plasma_charge_max*0.25) && power_charge >= (power_charge_max*0.25)))
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]_off"

/obj/machinery/ftl_drive/proc/can_jump()
	return plasma_charge >= plasma_charge_max && power_charge >= power_charge_max

/obj/machinery/ftl_drive/proc/can_jump_planet()
	return plasma_charge >= (plasma_charge_max*0.25) && power_charge >= (power_charge_max*0.25)
