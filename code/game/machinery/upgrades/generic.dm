/********************************************Base machine upgrades********************************************/

/obj/item/weapon/upgrade/generic_efficiency
	name = "Machine Upgrade (Superconducting Cables)"
	desc = "Tell thermodynamics to fuck off with these room-temperature superconductive cables!"
	rarity = 4
	machine_type = /obj/machinery
	upgrade_type = /datum/upgrade_effect/generic_efficiency
	uses = 10

/datum/upgrade_effect/generic_efficiency/effect_initialize(mob/user)
	. = ..()
	var/obj/machinery/machine = owner
	if(!machine.active_power_usage || !machine.idle_power_usage)
		return INCOMPATIBLE_STATS
	machine.active_power_usage -= machine.idle_power_usage * 0.9
	machine.idle_power_usage *= 0.1

/********************************************Base computer upgrades********************************************/