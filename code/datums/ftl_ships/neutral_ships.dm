//this file is uncinluded because currently it crashes the ship generation


/datum/starship/freighter //not a threat
	name = "small freighter"
	description = "A small freighter carrying various types of cargo to distribute to local stations in the area"
	salvage_map = "small_freighter.dmm"

	x_num = 3
	y_num = 3

	faction = list("neutral",60)

	hull_integrity = 15
	shield_strength = 1000
	evasion_chance = 10

	repair_time = 200
	recharge_rate = 75 //double-phase shields

	operations_type = 1
	cargo_limit = 100

	heat_points = 2 //attacking shipping makes factions mad

	init_ship_components = list("1,1" = "hull", "2,1" = "weapon", "3,1" = "hull",\
	"1,2" = "hull", "2,2" = "cockpit", "3,2" = "hull",\
	"1,3" = "repair", "2,3" = "engine", "3,3" = "shields")

	/*
		HWH
		HCH
		RES
	*/

/datum/starship/large_freighter //not a threat
	name = "large freighter"
	description = "The larger brother of the small freighter, mainly used to carry large amounts of resources for ship construction"
	salvage_map = "large_freighter.dmm"

	x_num = 4
	y_num = 5

	faction = list("neutral",20)

	hull_integrity = 30 //bulky fucker
	shield_strength = 1000
	evasion_chance = 5

	repair_time = 200
	recharge_rate = 75 //double-phase shields

	operations_type = 1
	cargo_limit = 500
	build_resources = list("iron" = 1000, "silicon" = 400)
	heat_points = 5 //these things are really expensive

	init_ship_components = list("1,1" = "fast_weapon", "2,1" = "cockpit", "3,1" = "slow_chaingun",\
	"1,2" = "engine", "2,2" = "hull", "3,2" = "shields",\
	"1,3" = "hull", "2,3" = "hull", "3,3" = "hull",\
	"1,4" = "hull", "2,4" = "hull", "3,4" = "hull",\
	"1,5" = "engine", "2,5" = "repair", "3,5" = "engine")

	/*
		WCW
		EHS
		HHH
		HHH
		ERE
	*/

/datum/starship/drone
	name = "patrol drone"
	description = "A small patrol drone used for scouting operations"
	salvage_map = "drone.dmm"

	x_num = 3
	y_num = 2

	faction = list("neutral",70)

	hull_integrity = 3
	shield_strength = 0
	evasion_chance = 30

	repair_time = 0
	recharge_rate = 200

	init_ship_components = list("2,1" = "fast_weapon",\
	"1,2" = "engine", "2,2" = "drone", "3,2" = "engine")
	build_resources = list("iron" = 150, "silicon" = 50)

	operations_ai = /datum/ship_ai/standard_operations/scout_operations

	/*
		 W
		EDE
	*/
