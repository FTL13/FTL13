/*
Machine upgrade system

Upgrade obj variables:
-rarity:
	Rarity decides the worth of the mod and where it can be found
	Rarity -1 is admin spawn only
	Rarity 0 can be found for sale at the first station
	Rarity 1 can be found for sale in friendly space every round
	Rarity 2 can very rarely be found for sale in friendly space or more commonly in unfriendly space
	Rarity 3 can be found very rarely for sale in unfriendly space or found as salvage/boarding loot
	Rarity 4 can only be found from high tier salvage or boarding
	Rarity 5 is only found from special events or planet exploration

-machine_type:
	The type path of the machine it applies to, it also applies to all child paths

-part_overlay:
	What overlay the mod applies on the machine

-uses:
	How many times this can be used on machines, -1 for infinite.

-apply_sound:
	Played on application of the mod

-fail_sound:
	Played if the mod is rejected by the machine or vice versa

-succeed_sound:
	Played if the mod successfuly initializes

-overlay_file:
	The overlay file for all upgrades

-overlay_states:
	A multi dimensional list where each internal list contains the icon_state prefix and a number for how many variations there are.

-overlay_quantity:
	How many overlays to apply on creation

-overlay_color:
	What color the overlays are colored

Upgrade datum variables:

-timid:
	Whether it will add itself to SSmachines.upgrades or not

-owner:
	Machine the upgrade is in

-overlay:
	An overlay applied to the owner machine

Upgrade datum procs:
-before_initialize(owner)
	owner is the /obj/machinery which the upgrade is attached to
	Called before begining the initialization process

-effect_initialize(owner)
	owner is the /obj/machinery which the upgrade is attached to
	Makes changes to owner and returns flags indicating if successful
	IF YOU RETURN FAILED OR WAIT: DO NOT MAKE CHANGES TO OWNER

-after_initialize(owner)
	owner is the /obj/machinery which the upgrade is attached to
	Called after the initialization process has completely finished

-effect_tick(owner)
	owner is this /obj/machinery which the upgrade is attached to
	Do something every tick if in SSmachines.upgrades

Eventualy mods will be applied in a more complex (in-game) procedure but it's like this for now for testing purposes.
*/

//////////////////////////////////////////////////////////////////////////////////////////////

/obj/item/weapon/upgrade
	name = "\improper Base Upgrade"
	desc = "How did you get this?"
	var/rarity = 0
	var/machine_type
	var/upgrade_path
	var/uses = -1

	var/apply_sound = 'sound/items/change_jaws.ogg'
	var/fail_sound = 'sound/machines/triple_beep.ogg'
	var/succeed_sound = 'sound/items/rped.ogg'
	
	icon = 'icons/obj/items.dmi'
	icon_state = "blank_blueprints"
	var/overlay_file = 'icons/obj/machines/upgrade_overlays.dmi'
	var/overlay_states = list(list("base", 9) = 10)
	var/overlay_quantity = 4
	var/overlay_color = "#FFFFFF" //Not used until I figure out how this works
	
/obj/item/weapon/upgrade/Initialize()
	. = ..()
	for(var/i in 1 to overlay_quantity)
		var/overlay_dat = pick(overlay_states)
		var/overlay_num = rand(1, overlay_dat[2])
		add_overlay(image(overlay_file, "[overlay_dat[1]]-[overlay_num]"))

/obj/item/weapon/upgrade/proc/get_upgrade_datum(machine)
	var/datum/upgrade_effect/upgrade
	if(upgrade_path)
		upgrade = new upgrade_path
	else
		return FALSE

	upgrade.name = "[initial(name)] datum"
	upgrade.owner = machine
	return upgrade
	
//////////////////////////////////////////////////////////////////////////////////////////////

/datum/upgrade_effect
	var/name
	var/timid = TRUE
	var/owner
	var/overlay

/datum/upgrade_effect/proc/before_initialize(mob/user, machine)

/datum/upgrade_effect/proc/effect_initialize(mob/user)
	return SUCCESS

/datum/upgrade_effect/proc/after_initialize(mob/user)

/datum/upgrade_effect/proc/effect_tick(mob/user)