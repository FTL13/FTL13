//this file is uncinluded because currently it crashes the ship generation


/datum/ship/starship/freighter //not a threat
	name = "small freighter"
	cname = "smfg"

	x_num = 3
	y_num = 3

	hull_integrity = 30
	shield_strength = 1
	evasion_chance = 10

	fire_rate = 600 //peashooter
	repair_time = 200
	recharge_rate = 25 //double-phase shields

	init_components = list("hull"="1,1","weapon"="2,1","hull"="3,1","hull"="1,2","cockpit"="2,2","hull"="3,2","repair"="1,3","engine"="2,3","shields"="3,3")

	/*
		HWH
		HCH
		RES
	*/