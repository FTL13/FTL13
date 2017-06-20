/********************************************Base machine upgrades********************************************/

/obj/item/weapon/upgrade/generic_efficiency
	name = "Superconducting Cables"
	rarity = 4
	machine_type = /obj/machinery
	upgrade_path = /datum/upgrade_effect/generic_efficiency
	uses = 1

/datum/upgrade_effect/generic_efficiency/effect_initialize(mob/user)
	. = ..()
	var/obj/machinery/machine = owner
	if(!machine.active_power_usage || !machine.idle_power_usage)
		return INCOMPATIBLE_STATS
	machine.active_power_usage -= machine.idle_power_usage * 0.9
	machine.idle_power_usage *= 0.1

/********************************************Base computer upgrades********************************************/