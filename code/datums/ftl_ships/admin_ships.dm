/datum/starship/clownship
	name = "Honkmothership"
	faction = list("pirate",0)
	salvage_map = "placeholder.dmm"

	x_num = 4
	y_num = 4

	hull_integrity = 25 //Can't bring down memes easily
	shield_strength = 1
	evasion_chance = 5

	repair_time = 400
	recharge_rate = 200

	init_components = list("1,1" = "meme_weapon", "2,1" = "meme_weapon", "3,1" = "meme_weapon", "4,1" = "meme_weapon", "1,2" = "shields", "2,2" = "repair", "3,2" = "cockpit", "4,2" = "shields", "1,3" = "meme_weapon"
	,"2,3" = "meme_weapon", "3,3" = "meme_weapon", "4,3" = "meme_weapon", "1,4" = "engine", "2,4" = "engine", "3,4" = "engine", "4,4" = "engine",)


	/*
		WWWW
		SRCS
		WWWW
		EEEE
	*/

/datum/starship/test
	name = "Tester ship"
	faction = list("pirate",0)

	//Boarding vars
	boarding_map = "frigate.dmm"
	boarding_chance = 100
	crew_outfit = /datum/outfit/defender/solgov
	captain_outfit = /datum/outfit/defender/command/solgov


	x_num = 1
	y_num = 1

	hull_integrity = 1

	shield_strength = 1
	evasion_chance = 0

	repair_time = 0
	recharge_rate = 200

	init_components = list("2,3" = "engine")
