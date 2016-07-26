/datum/starship/corvette
	name = "patrol corvette"

	faction = list("nanotrasen",80)

	x_num = 3
	y_num = 3

	hull_integrity = 10
	shield_strength = 1
	evasion_chance = 25

	fire_rate = 100
	repair_time = 300
	recharge_rate = 50

	init_components = list("cockpit"="2,1","weapon"="1,2","hull"="2,2","weapon"="3,2","engine"="1,3","reactor"="2,3","engine"="3,3")

	/*
	     C
	    WHW
	    ERE

	*/

/datum/starship/frigate //the ship the crew flies
	name = "patrol frigate"

	faction = list("nanotrasen",40)

	x_num = 3
	y_num = 3

	hull_integrity = 15
	shield_strength = 2
	evasion_chance = 20

	fire_rate = 100
	repair_time = 300
	recharge_rate = 50

	init_components = list("hull"="1,1","hull"="3,1","weapon"="1,2","cockpit"="2,2","weapon"="3,2","engine"="1,3","reactor"="2,3","engine"="3,3")

	/*
		H H
		WCW
		ERE
	*/




