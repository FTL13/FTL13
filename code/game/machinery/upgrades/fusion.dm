/**********Mods for the pomf fusion reactor**********/

//Admin mods
/obj/item/weapon/upgrade/injector_hugbox
	name = "Hugbox (Injector mod)"
	desc = "Apply directly to whiny baby"
	rarity = -1
	machine_type = obj/machinery/fusion/injector
	
/obj/item/weapon/upgrade/injector_hugbox/effect_initialize(I)
	var/obj/machinery/fusion/injector/M = I
	M.use_fuel = 0
	M.use_energy = 0
	M.use_hydrogen = 0
	return 1
	
/obj/item/weapon/upgrade/pipe_hugbox
	name = "Hugbox (Containment pipe mod)"
	desc = "Apply directly to whiny baby"
	rarity = -1
	machine_type = obj/machinery/atmospherics/pipe/containment
	
/obj/item/weapon/upgrade/pipe_hugbox/effect_initialize(I)
	var/obj/machinery/atmospherics/pipe/containment/M = I
	M.no_damage = 1
	return 1
	
/obj/item/weapon/upgrade/electromagnet_hugbox
	name = "Hugbox (Electromagnet mod)"
	desc = "Apply directly to whiny baby"
	rarity = -1
	machine_type = obj/machinery/fusion/electromagnet
	
/obj/item/weapon/upgrade/electromagnet_hugbox/effect_initialize(I)
	var/obj/machinery/fusion/electromagnet/M = I
	M.max_speed = 9001
	M.max_torque = 9001
	M.precision = 9001
	M.stability = 9001
	return 1
	
//Rarity 0 mods
/obj/item/weapon/upgrade/heat_resistant_coating
	name = "External heat resistant coating (Containment pipe mod)"
	desc = "The tools and design documents to install external heat resistant plates."
	rarity = 0
	machine_type = obj/machinery/atmospherics/pipe/containment
	
/obj/item/weapon/upgrade/pipe_vent/effect_initialize(I)
	var/obj/machinery/atmospherics/pipe/containment/M = I
	M.external_hr += 40
	M.max_durability += 100
	return 1
	
/obj/item/weapon/upgrade/heat_resistant_internals
	name = "Internal heat resistant coating (Containment pipe mod)"
	desc = "The tools and design documents to install internal heat resistant covers"
	rarity = 0
	machine_type = obj/machinery/atmospherics/pipe/containment
	
/obj/item/weapon/upgrade/heat_resistant_internals/effect_initialize(I)
	var/obj/machinery/atmospherics/pipe/containment/M = I
	M.internal_hr += 1000
	M.max_durability += 100
	return 1
	
/obj/item/weapon/upgrade/electromagnet_stabilizer
	name = "Electromagnet stabilizer (Electromagnet mod)"
	desc = "The tools and design documents to install stabilizing guide rails"
	rarity = 0
	machine_type = obj/machinery/fusion/electromagnet
	
/obj/item/weapon/upgrade/electromagnet_stabilizer/effect_initialize(I)
	var/obj/machinery/fusion/electromagnet/M = I
	M.max_speed -= 10
	M.max_torque -= 10
	M.precision -= 1
	M.safety += 10
	
//Rarity 1 mods
/obj/item/weapon/upgrade/pipe_vent
	name = "Auto-vents (Containment pipe mod)"
	desc = "The tools and design documents to install automatic gas vents."
	rarity = 1
	machine_type = obj/machinery/atmospherics/pipe/containment
	uses = 1
	
/obj/item/weapon/upgrade/pipe_vent/effect_initialize(I)
	var/obj/machinery/atmospherics/pipe/containment/M = I
	M.auto_vent = 1
	M.max_durability -= 100
	return 1
	
//Rarity 2 mods

//Rarity 3 mods
/obj/item/weapon/upgrade/pirate_electromagnet
	name = "Pirate junk (Electromagnet mod)"
	desc = "This package says it's an engine modification kit but it looks like someone just threw random parts lying around into a box"
	rarity = 3
	machine_type = obj/machinery/fusion/electromagnet
	uses = 3
	
	var/safety
	var/precision
	var/max_speed
	var/max_torque
	
/obj/item/weapon/upgrade/pirate_electromagnet/New()
	safety = rand(-10,100)/100
	precision = rand(-1,5)
	max_speed = rand(20,300)
	max_torque = rand(20,300)
	..()
	
/obj/item/weapon/upgrade/pirate_electromagnet/effect_initialize(I)
	var/obj/machinery/fusion/electromagnet/M = I
	M.safety += safety
	M.precision += precision
	M.max_speed += max_speed
	M.max_torque = max_torque
	
/obj/item/weapon/upgrade/pirate_injector
	name = "Pirate junk (Injector mod)"
	desc = "This package says it's an engine modification kit but it looks like someone just threw random parts lying around into a box"
	rarity = 3
	machine_type = obj/machinery/fusion/injector
	uses = 3
	
	var/fuel_efficiency
	var/gas_efficiency
	var/yield
	var/heat_multiplier
	
/obj/item/weapon/upgrade/pirate_injector/New()
	fuel_efficiency = rand(-5,10)/100
	gas_efficiency = rand(-5,10)/100
	yield = rand(5,10)
	heat_multiplier = rand(10,50)/100
	..()
	
/obj/item/weapon/upgrade/pirate_injector/effect_initialize(I)
	var/obj/machinery/fusion/injector/M = I
	M.fuel_efficiency += fuel_efficiency
	M.gas_efficiency += gas_efficiency
	M.yield += yield
	M.heat_multiplier += heat_multiplier

//Rarity 4 mods

//Rarity 5 mods
/obj/item/weapon/upgrade/supermatter_charger
	name = "Supermatter Charger (Injector mod)"
	desc = ""
	rarity = 5
	machine_type = obj/machinery/fusion/injector
	uses = 1
	
/obj/item/weapon/upgrade/supermatter_charger/effect_initialize(I)
	var/obj/machinery/fusion/injector/M = I
	M.heat_multiplier += 2
	M.fuel_efficiency -= 0.1
	M.gas_efficiency -= 0.3
	return 1