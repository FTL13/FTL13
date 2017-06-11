/*
Fusion engine upgrade system

This file contains all the different possible mods and fuels for the various parts of the POMF fusion engine.

When applied to an engine part, the engine calls on the mod's effect_initialize() proc in order to determine what happens.
A return value of 0 means the mod cannot be applied.
A return value of 1 means the proc was successful.
A return value of 2 means the mod needs to wait for another mod to effect_initialize first.

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

/obj/item/weapon/fuel_cell //Until I know how fuel manufacturing works I can't really do much here
	name = "\improper Fuel cell"
	desc = "Handle with care"
	var/amount = 100
	
/obj/item/weapon/fusion_mod
	name = "\improper Fusion mod"
	var/rarity = 0 //Used to determine sell/buy price
	var/machine //Which fusion part does it go in
	var/part_overlay //What overlay if any does the mod apply
	var/uses = -1 //How many times it can be used; -1 for infinite
	
	icon = 'icons/obj/items.dmi'
	icon_state = "blank_blueprints"
	var/overlay_file = 'icons/obj/fusion_engine/overlays.dmi'
	var/overlay_state = "mod"
	var/overlay_quantity = 3
	var/overlay_color = "#FFFFFF" //Not used until I figure out how this works
	
/obj/item/weapon/fusion_mod/New()
	..()
	var/list/num_list = list("1","2","3","4","5","6","7","8","9")
	for(var/i = overlay_quantity; i > 0; i--)
		var/temp_pick = pick(num_list)
		num_list -= temp_pick
		add_overlay(image(overlay_file, "[overlay_state]-[temp_pick]"))
	
/obj/item/weapon/fusion_mod/proc/effect_initialize(I) //runs once
	return
	
/obj/item/weapon/fusion_mod/proc/effect_process(I) //runs every tick
	return

//Admin mods
/obj/item/weapon/fusion_mod/injector_hugbox
	name = "Injector mod (Hugbox)"
	desc = "Apply directly to whiny baby"
	rarity = -1
	machine = "injector"
	
/obj/item/weapon/fusion_mod/injector_hugbox/effect_initialize(I)
	var/obj/machinery/fusion/injector/M = I
	M.use_fuel = 0
	M.use_energy = 0
	M.use_hydrogen = 0
	return 1
	
/obj/item/weapon/fusion_mod/pipe_hugbox
	name = "Containment pipe mod (Hugbox)"
	desc = "Apply directly to whiny baby"
	rarity = -1
	machine = "pipe"
	
/obj/item/weapon/fusion_mod/pipe_hugbox/effect_initialize(I)
	var/obj/machinery/atmospherics/pipe/containment/M = I
	M.no_damage = 1
	return 1
	
/obj/item/weapon/fusion_mod/electromagnet_hugbox
	name = "Electromagnet mod (Hugbox)"
	desc = "Apply directly to whiny baby"
	rarity = -1
	machine = "electromagnet"
	
/obj/item/weapon/fusion_mod/electromagnet_hugbox/effect_initialize(I)
	var/obj/machinery/fusion/electromagnet/M = I
	M.max_speed = 9001
	M.max_torque = 9001
	M.precision = 9001
	M.stability = 9001
	return 1
	
//Rarity 0 mods
/obj/item/weapon/fusion_mod/heat_resistant_coating
	name = "Containment pipe mod (External heat resistant coating)"
	desc = "The tools and design documents to install external heat resistant plates."
	rarity = 0
	machine = "pipe"
	
/obj/item/weapon/fusion_mod/pipe_vent/effect_initialize(I)
	var/obj/machinery/atmospherics/pipe/containment/M = I
	M.external_hr += 40
	M.max_durability += 100
	return 1
	
/obj/item/weapon/fusion_mod/heat_resistant_internals
	name = "Containment pipe mod (Internal heat resistant coating)"
	desc = "The tools and design documents to install internal heat resistant covers"
	rarity = 0
	machine = "pipe"
	
/obj/item/weapon/fusion_mod/heat_resistant_internals/effect_initialize(I)
	var/obj/machinery/atmospherics/pipe/containment/M = I
	M.internal_hr += 1000
	M.max_durability += 100
	return 1
	
/obj/item/weapon/fusion_mod/electromagnet_stabilizer
	name = "Electromagnet mod (Electromagnet stabilizer)"
	desc = "The tools and design documents to install stabilizing guide rails"
	rarity = 0
	machine = "electromagnet"
	
/obj/item/weapon/fusion_mod/electromagnet_stabilizer/effect_initialize(I)
	var/obj/machinery/fusion/electromagnet/M = I
	M.max_speed -= 10
	M.max_torque -= 10
	M.precision -= 1
	M.safety += 10
	
//Rarity 1 mods
/obj/item/weapon/fusion_mod/pipe_vent
	name = "Containment pipe mod (Auto-vents)"
	desc = "The tools and design documents to install automatic gas vents."
	rarity = 1
	machine = "pipe"
	uses = 1
	
/obj/item/weapon/fusion_mod/pipe_vent/effect_initialize(I)
	var/obj/machinery/atmospherics/pipe/containment/M = I
	M.auto_vent = 1
	M.max_durability -= 100
	return 1
	
//Rarity 2 mods

//Rarity 3 mods
/obj/item/weapon/fusion_mod/pirate_electromagnet
	name = "Electromagnet mod (Pirate junk)"
	desc = "This package says it's an engine modification kit but it looks like someone just threw random parts lying around into a box"
	rarity = 3
	machine = "electromagnet"
	uses = 3
	
	var/safety
	var/precision
	var/max_speed
	var/max_torque
	
/obj/item/weapon/fusion_mod/pirate_electromagnet/New()
	safety = rand(-10,100)/100
	precision = rand(-1,5)
	max_speed = rand(20,300)
	max_torque = rand(20,300)
	..()
	
/obj/item/weapon/fusion_mod/pirate_electromagnet/effect_initialize(I)
	var/obj/machinery/fusion/electromagnet/M = I
	M.safety += safety
	M.precision += precision
	M.max_speed += max_speed
	M.max_torque = max_torque
	
/obj/item/weapon/fusion_mod/pirate_injector
	name = "Injector mod (Pirate junk)"
	desc = "This package says it's an engine modification kit but it looks like someone just threw random parts lying around into a box"
	rarity = 3
	machine = "injector"
	uses = 3
	
	var/fuel_efficiency
	var/gas_efficiency
	var/yield
	var/heat_multiplier
	
/obj/item/weapon/fusion_mod/pirate_injector/New()
	fuel_efficiency = rand(-5,10)/100
	gas_efficiency = rand(-5,10)/100
	yield = rand(5,10)
	heat_multiplier = rand(10,50)/100
	..()
	
/obj/item/weapon/fusion_mod/pirate_injector/effect_initialize(I)
	var/obj/machinery/fusion/injector/M = I
	M.fuel_efficiency += fuel_efficiency
	M.gas_efficiency += gas_efficiency
	M.yield += yield
	M.heat_multiplier += heat_multiplier

//Rarity 4 mods

//Rarity 5 mods
/obj/item/weapon/fusion_mod/supermatter_charger
	name = "Injector mod (Supermatter Charger)"
	desc = ""
	rarity = 5
	machine = "injector"
	uses = 1
	
/obj/item/weapon/fusion_mod/supermatter_charger/effect_initialize(I)
	var/obj/machinery/fusion/injector/M = I
	M.heat_multiplier += 2
	M.fuel_efficiency -= 0.1
	M.gas_efficiency -= 0.3
	return 1