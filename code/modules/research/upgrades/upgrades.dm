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

-overlay_probabilities:
	An associative list for getting a key representing an overlay group with weighted randomness

-overlay_amounts:
	How many overlays exist in the category represented by the key.
	Do not overwrite. Any new categories added for any new upgrade overlays should be added only to the base type.

-overlay_colors:
	What color to use for the overlay category represented by the key.

-overlay_quantity:
	How many overlays to apply on creation

-overlay_color:
	What color the overlays are colored

//////////////////////////////////////////////////////////////////////////////////////////////

Upgrade datum variables:
-owner:
	Machine the upgrade is in

Upgrade datum procs:
-before_initialize()
	Called before begining the initialization process

-effect_initialize()
	Makes changes to owner and returns flags indicating if successful
	IF YOU RETURN FAILED OR WAIT: DO NOT MAKE CHANGES TO OWNER

-after_initialize()
	Called after the initialization process has completely finished

-effect_tick()
	Do something every tick if machine is processing

Eventualy mods will be applied in a more complex (in-game) procedure but it's like this for now for testing purposes.
*/

//////////////////////////////////////////////////////////////////////////////////////////////

/obj/item/weapon/upgrade
	name = "\improper Base Upgrade"
	desc = "How did you get this?"
	var/rarity = 0
	var/machine_type
	var/upgrade_type
	var/uses = -1

	var/apply_sound = 'sound/items/change_jaws.ogg'
	var/fail_sound = 'sound/machines/triple_beep.ogg'
	var/succeed_sound = 'sound/items/rped.ogg'
	
	icon = 'icons/obj/items.dmi'
	icon_state = "blank_blueprints"
	var/overlay_file = 'icons/obj/machines/upgrade_overlays.dmi'
	var/overlay_probabilities = list("base" = 10) 					//Higher numbers means higher probability
	var/overlay_amounts = list("base" = 9) 							//How many different icon states there are for that group
	var/overlay_colors = list("base" = "#000") 						//What color you want that group
	var/overlay_quantity = 4
	
/obj/item/weapon/upgrade/Initialize()
	. = ..()
	for(var/i in 1 to overlay_quantity)
		var/overlay_type = pick(overlay_probabilities)				//First pick an overlay group
		var/overlay_num = rand(1, overlay_amounts[overlay_type])	//Then pick which overlay in that group
		var/overlay_color = overlay_colors[overlay_type]			//Then grab the color for that group
		var/icon/scribbles = icon(overlay_file, "[overlay_type]-[overlay_num]")
		scribbles.Blend(overlay_color)
		add_overlay(scribbles)

/obj/item/weapon/upgrade/proc/get_upgrade_datum(machine)
	var/datum/upgrade_effect/upgrade
	if(upgrade_type)
		upgrade = new upgrade_type
	else
		return FALSE

	upgrade.name = initial(name)
	upgrade.owner = machine
	return upgrade
	
//////////////////////////////////////////////////////////////////////////////////////////////

/datum/upgrade_effect
	var/name
	var/owner

/datum/upgrade_effect/proc/before_initialize(mob/user, machine)

/datum/upgrade_effect/proc/effect_initialize(mob/user)
	return SUCCESS

/datum/upgrade_effect/proc/after_initialize(mob/user)

/datum/upgrade_effect/proc/effect_tick(mob/user)