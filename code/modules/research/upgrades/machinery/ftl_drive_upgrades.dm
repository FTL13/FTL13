//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/item/weapon/upgrade/drive_energy_booster
	name = "Machine Upgrade (FTL Drive Energy Booster)"
	desc = "Speed up your FTL drive for a faster getaway by supercharging it's capacitors!"
	rarity = 2
	machine_type = /obj/machinery/ftl_drive
	upgrade_type = /datum/upgrade_effect/drive_energy_booster
	uses = 1
	overlay_colors = list("base" = "#00F")


/datum/upgrade_effect/drive_energy_booster/effect_initialize(mob/user)
	. = ..()
	var/obj/machinery/ftl_drive/machine = owner
	machine.power_charge_max *= 1.5
	machine.charge_rate *= 2

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/item/weapon/upgrade/drive_plasma_booster
	name = "Machine Upgrade (FTL Drive Plasma Booster)"
	desc = "Speed up your FTL drive for a faster getaway by increasing plasma intake far more than specifications allow!"
	rarity = 2
	machine_type = /obj/machinery/ftl_drive
	upgrade_type = /datum/upgrade_effect/drive_plasma_booster
	uses = 1
	overlay_colors = list("base" = "#00F")

/datum/upgrade_effect/drive_plasma_booster/effect_initialize(mob/user)
	. = ..()
	var/obj/machinery/ftl_drive/machine = owner
	machine.plasma_charge_rate *= 1.5

/datum/upgrade_effect/drive_plasma_booster/effect_tick()
	. = ..()
	var/obj/machinery/ftl_drive/machine = owner
	if(prob(0.5))
		playsound(machine.loc, 'sound/machines/hiss.ogg', 50, 5)
		machine.atmos_terminal.dump_gas(percentage = 0.1)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////