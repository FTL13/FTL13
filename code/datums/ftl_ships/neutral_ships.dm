//this file is uncinluded because currently it crashes the ship generation


/datum/starship/freighter //not a threat
	name = "small freighter"
	salvage_map = "small_freighter.dmm"

	x_num = 3
	y_num = 3

	faction = list("neutral",50)

	hull_integrity = 15
	shield_strength = 1
	evasion_chance = 10

	fire_rate = 600 //peashooter
	repair_time = 200
	recharge_rate = 75 //double-phase shields

	init_components = list("1,1" = "hull", "2,1" = "weapon", "3,1" = "hull", "1,2" = "hull", "2,2" = "cockpit", "3,2" = "hull", "1,3" = "repair", "2,3" = "engine", "3,3" = "shields")

	/*
		HWH
		HCH
		RES
	*/
	
/datum/starship/large_freighter //not a threat
	name = "large freighter"
	salvage_map = "large_freighter.dmm"

	x_num = 4
	y_num = 5

	faction = list("neutral",60)

	hull_integrity = 30 //bulky fucker
	shield_strength = 1
	evasion_chance = 5

	fire_rate = 300 
	repair_time = 200
	recharge_rate = 75 //double-phase shields

	init_components = list("1,1" = "weapon", "2,1" = "cockpit", "3,1" = "weapon", "1,2" = "engine", "2,2" = "hull", "3,2" = "shields", "1,3" = "repair", "2,3" = "engine", "3,3" = "shields")

	/*
		WCW
		EHS
		HHH
		HHH
		ERE
	*/


/datum/starship/drone
	name = "patrol drone"
	salvage_map = "drone.dmm"

	x_num = 3
	y_num = 1

	faction = list("neutral",70)

	hull_integrity = 3
	shield_strength = 0
	evasion_chance = 30

	fire_rate = 200
	repair_time = 0
	recharge_rate = 200

	init_components = list("1,1" = "engine", "2,1" = "drone", "3,1" = "engine")

	/*
		EDE
	*/
