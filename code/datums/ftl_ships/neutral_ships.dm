//this file is uncinluded because currently it crashes the ship generation


/datum/starship/freighter //not a threat
	name = "small freighter"

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

/datum/starship/drone
	name = "patrol drone"
	salvage_map = "drone.dmm"

	no_damage_retreat = 1
	scout_ship = 1

	x_num = 3
	y_num = 1

	faction = list("neutral",50)

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