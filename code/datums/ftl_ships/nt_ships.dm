/datum/starship/corvette
	name = "patrol corvette"
	salvage_map = "patrol_corvette.dmm"

	faction = list("nanotrasen",80)

	x_num = 3
	y_num = 3

	hull_integrity = 10
	shield_strength = 1
	evasion_chance = 25

	fire_rate = 100
	repair_time = 300
	recharge_rate = 150

	init_components = list("2,1" = "cockpit", "1,2" = "weapon", "2,2" = "hull", "3,2" = "weapon", "1,3" = "engine", "2,3" = "reactor", "3,3" = "engine")

	/*
	     C
	    WHW
	    ERE

	*/

/datum/starship/frigate //the ship the crew flies EDIT: okay maybe not. A smaller version of the ship the players fly.
	name = "patrol frigate"

	//Boarding vars
	boarding_map = "frigate.dmm"
	boarding_chance = 30
	crew_outfit = /datum/outfit/defender/solgov
	captain_outfit = /datum/outfit/defender/command/solgov

	faction = list("nanotrasen",40)

	x_num = 3
	y_num = 3

	hull_integrity = 15
	shield_strength = 2
	evasion_chance = 20

	fire_rate = 100
	repair_time = 300
	recharge_rate = 150
	build_resources = list("iron" = 600, "silicon" = 400)
	init_components = list("1,1" = "hull", "3,1" = "hull", "1,2" = "weapon", "2,2" = "cockpit", "3,2" = "s_weapon", "1,3" = "engine", "2,3" = "reactor", "3,3" = "engine")

	/*
		H H
		WCW
		ERE
	*/
