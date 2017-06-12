/obj/item/weapon/upgrade/generic_efficiency
	name = "Superconducting Cables"
	rarity = 4
	machine_type = obj/machinery
	uses = 1

/obj/item/weapon/upgrade/generic_efficiency/effect_initialize(I)
	var/obj/machinery/machine = I
	machine.active_power_usage -= machine.idle_power_usage * 0.9
	machine.idle_power_usage *= 0.1
	return SUCCESS