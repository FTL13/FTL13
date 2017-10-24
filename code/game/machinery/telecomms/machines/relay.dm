/*
	The relay idles until it receives information. It then passes on that information
	depending on where it came from.

	The relay is needed in order to send information pass Z levels. It must be linked
	with a HUB, the only other machine that can send/receive pass Z levels.
*/

/obj/machinery/telecomms/relay
	name = "telecommunication relay"
	icon_state = "relay"
	desc = "A mighty piece of hardware used to send massive amounts of data far away."
	density = TRUE
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 30
	machinetype = 8
	netspeed = 5
	long_range_link = 1
	circuit = /obj/item/weapon/circuitboard/machine/telecomms/relay
	var/broadcasting = 1
	var/receiving = 1

/obj/machinery/telecomms/relay/receive_information(datum/signal/signal, obj/machinery/telecomms/machine_from)
	// Add our level and send it back
	if(can_send(signal))
		signal.data["level"] |= listening_level

// Checks to see if it can send/receive.

/obj/machinery/telecomms/relay/proc/can(datum/signal/signal)
	if(!on)
		return FALSE
	if(!is_freq_listening(signal))
		return FALSE
	return TRUE

/obj/machinery/telecomms/relay/proc/can_send(datum/signal/signal)
	if(!can(signal))
		return FALSE
	return broadcasting

/obj/machinery/telecomms/relay/proc/can_receive(datum/signal/signal)
	if(!can(signal))
		return FALSE
	return receiving

//Preset Relay

/obj/machinery/telecomms/relay/preset
	network = "tcommsat"

/obj/machinery/telecomms/relay/preset/station
	id = "Station Relay"
	listening_level = 1
	autolinkers = list("s_relay")

/obj/machinery/telecomms/relay/preset/telecomms
	id = "Telecomms Relay"
	autolinkers = list("relay")

/obj/machinery/telecomms/relay/preset/mining
	id = "Mining Relay"
	autolinkers = list("m_relay")

/obj/machinery/telecomms/relay/preset/ruskie
	id = "Ruskie Relay"
	hide = 1
	toggled = FALSE
	autolinkers = list("r_relay")

// Portable Relay - A relay that can be dragged around
/obj/machinery/telecomms/relay/portable
	var/obj/item/weapon/stock_parts/cell/power_cell
	name = "portable telecommunication relay"
	desc = "A relay capable of holding it's own power cell and being dragged around."

/obj/machinery/telecomms/relay/portable/attackby(obj/item/P, mob/user, params)
	if(default_unfasten_wrench(user, P))
		power_change()
		return
	if(istype(P, /obj/item/weapon/stock_parts/cell) && !power_cell)
		if(!user.drop_item())
			return 1
		P.loc = src
		power_cell = P
		power_change()
		return
	. = ..()

/obj/machinery/telecomms/relay/portable/New()
	power_cell = new /obj/item/weapon/stock_parts/cell/high(src)
	..()

/obj/machinery/telecomms/relay/portable/Move()
	. = ..()
	listening_level = z

/obj/machinery/telecomms/relay/portable/power_change()
	if(anchored && (powered() || (power_cell && power_cell.charge)))
		stat &= ~NOPOWER
	else

		stat |= NOPOWER
	return

/obj/machinery/telecomms/relay/portable/use_power(amount)
	if(powered())
		return ..()
	else
		power_cell.use(amount/10)
		power_change()

/obj/machinery/telecomms/relay/portable/preset
	network = "tcommsat"
	id = "Portable Relay"
	toggled = 0
	autolinkers = list("s_relay")