/datum/starship/skirmisher
	name = "syndicate skirmisher"
	faction = list("syndicate",80)
	salvage_map = "skirmisher.dmm"

	x_num = 3
	y_num = 3

	hull_integrity = 8
	shield_strength = 1
	evasion_chance = 30

	fire_rate = 100
	repair_time = 300
	recharge_rate = 150

	init_components = list("2,1" = "weapon", "2,2" = "cockpit", "1,3" = "engine", "2,3" = "reactor", "3,3" = "engine")

	/*
		 W
	     C
	    ERE
	*/

/datum/starship/ravager
	name = "syndicate ravager"
	faction = list("syndicate",10)

	x_num = 5
	y_num = 5

	hull_integrity = 20
	shield_strength = 3
	evasion_chance = 5

	fire_rate = 50
	repair_time = 200
	recharge_rate = 150

	init_components = list("1,1" = "weapon", "2,1" = "hull", "3,1" = "cockpit", "4,1" = "hull", "5,1" = "weapon", "1,2" = "weapon", "2,2" = "shields"\
	,"3,2" = "repair", "4,2" = "shields", "5,2" = "weapon", "1,3" = "hull", "2,3" = "shields", "3,3" = "repair", "4,3" = "shields", "5,3" = "hull"\
	,"1,5" = "engine", "2,5" = "engine", "3,5" = "engine", "4,5" = "engine", "5,5" = "engine")

	/* WHCHW
	   WSRSW
	   HSRSH
	   EEEEE Jesus this thing is huge
	*/

/datum/starship/bomber
	name = "syndicate bomber"
	faction = list("syndicate",60)
	salvage_map = "bomber.dmm"

	x_num = 3
	y_num = 3

	hull_integrity = 14
	shield_strength = 0
	evasion_chance = 20

	fire_rate = 70
	repair_time = 350
	recharge_rate = 150

	init_components = list("2,1" = "weapon", "2,2" = "cockpit", "1,3" = "weapon", "2,3" = "reactor", "3,3" = "engine")

	/*
		 W
	     C
	    WRE
	*/

/datum/starship/smuggler
	name = "syndicate smuggler"
	faction = list("syndicate",60)
	salvage_map = "bomber.dmm"

	x_num = 3
	y_num = 3

	hull_integrity = 6
	shield_strength = 2
	evasion_chance = 33

	fire_rate = 100
	repair_time = 100
	recharge_rate = 150

	init_components = list("2,1" = "weapon", "2,2" = "cockpit", "1,3" = "weapon"\
	, "5,3" = "hull", "2,3" = "reactor", "3,3" = "engine")

	/*
		 W
	    CH
	    WRE
	*/