/*
Machine upgrade system

Rarity decides the worth of the mod and where it can be found
Rarity -1 is admin spawn only
Rarity 0 can be found for sale at the first station
Rarity 1 can be found for sale in friendly space every round
Rarity 2 can very rarely be found for sale in friendly space or more commonly in unfriendly space
Rarity 3 can be found very rarely for sale in unfriendly space or found as salvage/boarding loot
Rarity 4 can only be found from high tier salvage or boarding
Rarity 5 is only found from special events or planet exploration

Eventualy mods will be applied in a more complex (in-game) procedure but it's like this for now for testing purposes.
*/

/obj/item/weapon/upgrade
	name = "\improper Fusion mod"
	var/rarity = 0 //Used to determine sell/buy price
	var/machine_type //Which machine does it apply to
	var/part_overlay //What overlay if any does the mod apply
	var/uses = -1 //How many times it can be used; -1 for infinite
	
	icon = 'icons/obj/items.dmi'
	icon_state = "blank_blueprints"
	var/overlay_file = 'icons/obj/fusion_engine/overlays.dmi'
	var/overlay_state = "mod"
	var/overlay_quantity = 3
	var/overlay_color = "#FFFFFF" //Not used until I figure out how this works
	
/obj/item/weapon/upgrade/New()
	. = ..()
	var/list/num_list = list("1","2","3","4","5","6","7","8","9")
	for(var/i = overlay_quantity; i > 0; i--)
		var/temp_pick = pick(num_list)
		num_list -= temp_pick
		add_overlay(image(overlay_file, "[overlay_state]-[temp_pick]"))
	
/obj/item/weapon/upgrade/proc/effect_initialize(I) //runs when upgrades are initialized
	return
	
/obj/item/weapon/upgrade/proc/effect_process(I) //runs every tick
	return