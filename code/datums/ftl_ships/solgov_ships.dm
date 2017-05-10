/datum/starship/fighter
	name = "SolGov sparrow attack craft"
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
	init_components = list("1,1" = "weapon", "2,1" = "cockpit", "3,1" = "weapon",\
	"1,2" = "engine", "2,2" = "shields", "3,2" = "engine")

	/*
	  WCW
	  ERE
	*/


/datum/starship/harrasser
	name = "SolGov eagle harrasment craft"
	faction = list("solgov",20)
	salvage_map = "sparrow_craft.dmm" //placeholder

	x_num = 3
	y_num = 4

	hull_integrity = 7
	shield_strength = 1
	evasion_chance = 35 //still high as fuck ya know

	repair_time = 800 // long repair times
	recharge_rate = 250
	build_resources = list("iron" = 250, "silicon" = 200)
	init_components = list("2,1" = "fast_weapon", "3,1" = "fast_weapon",\
	"2,2" = "cockpit", "3,2" = "shields",\
	"1,3" = "engine", "2,3" = "reactor", "3,3" = "repair", "4,3" = "engine",\
	"2,4" = "engine", "3,4" = "engine")

	/*
	   WW
		 CS
		ERRE
	   EE
	*/
