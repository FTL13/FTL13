/datum/starship/fighter
	name = "sparrow attack craft"
	faction = list("solgov",60)
	salvage_map = "sparrow_craft.dmm"

	x_num = 3
	y_num = 2

	hull_integrity = 3
	shield_strength = 1
	evasion_chance = 70 //ridiculous evasion

	repair_time = 1000 // long repair times
	recharge_rate = 150
	build_resources = list("iron" = 150, "silicon" = 100)
	init_components = list("1,1" = "weapon", "2,1" = "cockpit", "3,1" = "weapon", "1,2" = "engine", "2,2" = "shields", "3,2" = "engine")

	/*
	  WCW
	  ERE
	*/
