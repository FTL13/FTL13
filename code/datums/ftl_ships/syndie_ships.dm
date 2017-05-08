/datum/starship/skirmisher
	name = "syndicate skirmisher"
	faction = list("syndicate",60)
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
	faction = list("syndicate",5)
	salvage_map = "ravager.dmm"

	x_num = 5
	y_num = 5

	hull_integrity = 40 //you're ded kiddo
	shield_strength = 3
	evasion_chance = 5

	fire_rate = 50
	repair_time = 200
	recharge_rate = 150
	build_resources = list("iron" = 500, "silicon" = 250, "hyper" = 100)
	heat_points = 10
	init_components = list(
		"1,1" = "r_weapon", "2,1" = "hull", "3,1" = "cockpit", "4,1" = "hull", "5,1" = "r_weapon", "1,2" = "shields", "2,2" = "s_weapon"\
		,"3,2" = "repair", "4,2" = "s_weapon", "5,2" = "shields", "1,3" = "hull", "2,3" = "shields", "3,3" = "repair", "4,3" = "shields", "5,3" = "hull"\
		,"1,4" = "hull", "2,4" = "hull", "3,4" = "hull", "4,4" = "hull", "5,4" = "hull"
		,"1,5" = "engine", "2,5" = "engine", "3,5" = "engine", "4,5" = "engine", "5,5" = "engine"
			)

	/* WHCHW
	   SWRWS
	   HSRSH
		 HHHHH
	   EEEEE Jesus this thing is huge
	*/
