/datum/starship/fighter
	name = "sparrow attack craft"
	faction = list("solgov",80)

	no_damage_retreat = 1

	x_num = 3
	y_num = 2

	hull_integrity = 3
	shield_strength = 1
	evasion_chance = 80 //ridiculous evasion

	fire_rate = 50 //rapid fire cannons
	repair_time = 1000 // long repair times
	recharge_rate = 150

	init_components = list("1,1" = "weapon", "2,1" = "cockpit", "3,1" = "weapon", "2,1" = "engine", "2,2" = "repair", "3,2" = "engine")

	/*
	  WCW
	  ERE
	*/