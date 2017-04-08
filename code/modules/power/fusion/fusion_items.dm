/*
Fusion engine upgrade system

This file contains all the different possible mods and fuels for the various parts of the POMF fusion engine.

When applied to an engine part, the engine calls on the mod's get_effects() proc in order to determine what happens.
A return value of 0 means the mod cannot be applied.
A return value of 1 means the proc was successful.
A return value of 2 means the mod needs to wait for another mod to initialize first.

Eventualy mods will be applied in a more complex procedure but it's like this for now for testing purposes.
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
	
/obj/item/weapon/fusion_mod/proc/get_effects(I)
	return

//Admin mods
/obj/item/weapon/fusion_mod/injector_hugbox
	name = "Injector mod (Hugbox)"
	desc = "Apply directly to whiny baby"
	rarity = -1
	machine = "injector"
	
/obj/item/weapon/fusion_mod/injector_hugbox/get_effects(I)
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
	
/obj/item/weapon/fusion_mod/pipe_hugbox/get_effects(I)
	var/obj/machinery/atmospherics/pipe/containment/M = I
	M.no_damage = 1
	return 1
	
/obj/item/weapon/fusion_mod/electromagnet_hugbox
	name = "Electromagnet mod (Hugbox)"
	desc = "Apply directly to whiny baby"
	rarity = -1
	machine = "electromagnet"
	
/obj/item/weapon/fusion_mod/electromagnet_hugbox/get_effects(I)
	var/obj/machinery/fusion/electromagnet/M = I
	M.max_speed = 9001
	M.max_torque = 9001
	M.precision = 9001
	M.stability = 9001
	return 1
	
//Rarity 0 mods (Found on first station)
/obj/item/weapon/fusion_mod/heat_resistant_coating
	name = "Containment pipe mod (External heat resistant coating)"
	desc = "The tools and design documents to install external heat resistant plates."
	rarity = 0
	machine = "pipe"
	
/obj/item/weapon/fusion_mod/pipe_vent/get_effects(I)
	var/obj/machinery/atmospherics/pipe/containment/M = I
	M.external_hr += 40
	M.max_durability += 100
	return 1
	
/obj/item/weapon/fusion_mod/heat_resistant_internals
	name = "Containment pipe mod (Internal heat resistant coating)"
	desc = "The tools and design documents to install internal heat resistant covers"
	rarity = 0
	machine = "pipe"
	
/obj/item/weapon/fusion_mod/heat_resistant_internals/get_effects(I)
	var/obj/machinery/atmospherics/pipe/containment/M = I
	M.internal_hr += 1000
	M.max_durability += 100
	return 1
	
//Rarity 1 mods (Expect to find at least one every round)
/obj/item/weapon/fusion_mod/pipe_vent
	name = "Containment pipe mod (Auto-vents)"
	desc = "The tools and design documents to install automatic gas vents."
	rarity = 1
	machine = "pipe"
	
/obj/item/weapon/fusion_mod/pipe_vent/get_effects(I)
	var/obj/machinery/atmospherics/pipe/containment/M = I
	M.auto_vent = 1
	M.max_durability -= 100
	return 1
	
//Rarity 2 mods (Often find one per round)

//Rarity 3 mods (Drops from medium to powerful ships, rarely in shops)

//Rarity 4 mods (Drops from powerful ships, never in shops)

//Rarity 5 mods (Special event or very rare planet exploration)
/obj/item/weapon/fusion_mod/supermatter_charger
	name = "Injector mod (Supermatter Charger)"
	desc = ""
	rarity = 5
	machine = "injector"
	uses = 1
	
/obj/item/weapon/fusion_mod/supermatter_charger/get_effects(I)
	var/obj/machinery/fusion/injector/M = I
	M.heat_multiplier += 2
	M.fuel_efficiency -= 0.1
	M.gas_efficiency -= 0.3
	return 1