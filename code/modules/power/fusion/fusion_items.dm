/*
Fusion engine upgrade system

This file contains all the different possible mods and fuels for the various parts of the POMF fusion engine.

When applied to an engine part, the engine calls on the mod's get_effects() proc in order to determine what happens.
A return value of 0 means the mod cannot be applied.
A return value of 1 means the proc was successful.
A return value of 2 means the mod needs to wait for another mod to initialize first.
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
	
//Rarity 0 mods
	
//Rarity 1 mods
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
	