//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/item/weapon/upgrade/shield_energy_booster
	name = "Machine Upgrade (Shield Generator Energy Booster)"
	desc = "Improve your recharge speed with warantee free discount power capacitors!"
	rarity = 2
	machine_type = /obj/machinery/ftl_shieldgen
	upgrade_type = /datum/upgrade_effect/shield_energy_booster
	uses = 1
	overlay_colors = list("base" = "#00F")

/datum/upgrade_effect/shield_energy_booster/effect_initialize(mob/user)
	. = ..()
	var/obj/machinery/ftl_drive/machine = owner
	machine.power_charge_max *= 1.5
	machine.charge_rate *= 2

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/item/weapon/upgrade/shield_plasma_booster
	name = "Machine Upgrade (Shield Generator Plasma Booster)"
	desc = "Improve your shield plasma intake with bigger, better, faster, cheaper pumps!"
	rarity = 2
	machine_type = /obj/machinery/ftl_shieldgen
	upgrade_type = /datum/upgrade_effect/shield_plasma_booster
	uses = 1
	overlay_colors = list("base" = "#00F")

/datum/upgrade_effect/shield_plasma_booster/effect_initialize(mob/user)
	. = ..()
	var/obj/machinery/ftl_drive/machine = owner
	machine.plasma_charge_rate *= 1.5

/datum/upgrade_effect/shield_plasma_booster/effect_tick()
	. = ..()
	var/obj/machinery/ftl_drive/machine = owner
	if(prob(0.5))
		playsound(machine.loc, 'sound/machines/hiss.ogg', 50, 5)
		machine.atmos_terminal.dump_gas(percentage = 0.1)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////