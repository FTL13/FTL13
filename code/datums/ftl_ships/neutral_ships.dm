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

	init_components = list("hull"="1,1","weapon"="2,1","hull"="3,1","hull"="1,2","cockpit"="2,2","hull"="3,2","repair"="1,3","engine"="2,3","shields"="3,3")

	/*
		HWH
		HCH
		RES
	*/

/datum/starship/drone
	name = "patrol drone"

	x_num = 3
	y_num = 1

	faction = list("neutral",50)

	hull_integrity = 3
	shield_strength = 0
	evasion_chance = 30

	fire_rate = 200
	repair_time = 0
	recharge_rate = 200

	init_components = list("engine"="1,1","drone"="2,1","engine"="3,1")

	/*
		EDE
	*/