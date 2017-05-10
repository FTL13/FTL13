/datum/starship/skirmisher
	name = "syndicate skirmisher"
	description = "A small Syndicate fighter, known for its low production cost"
	faction = list("syndicate",60)
	salvage_map = "skirmisher.dmm"

	x_num = 3
	y_num = 3

	hull_integrity = 8
	shield_strength = 1
	evasion_chance = 30

	repair_time = 300
	recharge_rate = 150

	init_components = list("2,1" = "weapon",\
	"2,2" = "cockpit",\
	"1,3" = "engine", "2,3" = "reactor", "3,3" = "engine")

	/*
		 W
	     C
	    ERE
	*/


/datum/starship/bulker
	name = "syndicate bulker"
	description = "A wide, bulky Syndicate ship with an array of weaponry loaded onto it."
	faction = list("syndicate",60)
	salvage_map = "skirmisher.dmm"

	x_num = 4
	y_num = 2

	hull_integrity = 15
	shield_strength = 1
	evasion_chance = 10

	repair_time = 250
	recharge_rate = 125
	build_resources = list("iron" = 300, "silicon" = 150, "hyper" = 25)
	heat_points = 3

	init_components = list("2,1" = "s_weapon", "2,1" = "weapon", "3,1" = "slow_chaingun", "4,1" = "s_weapon",\
	"1,2" = "engine", "2,2" = "cockpit", "3,2" = "reactor", "4,2" = "engine")


/datum/starship/ravager
	name = "syndicate ravager"
	description = "The bane of every NanoTrasen crew; the huge Syndicate ravager, known for its strong hull and amazing firepower. You might want to run."
	faction = list("syndicate",5)
	salvage_map = "ravager.dmm"

	x_num = 5
	y_num = 5

	hull_integrity = 40 //you're ded kiddo
	shield_strength = 3
	evasion_chance = 5

	repair_time = 200
	recharge_rate = 150
	build_resources = list("iron" = 500, "silicon" = 250, "hyper" = 100)
	heat_points = 10

	init_components = list("1,1" = "chaingun", "2,1" = "hull", "3,1" = "weapon", "4,1" = "hull", "5,1" = "mac_cannon",\
	"1,2" = "hull", "2,2" = "slow_firebomber", "3,2" = "cockpit", "4,2" = "slow_ion_cannon", "5,2" = "hull",\
	"1,3" = "hull", "2,3" = "shields", "3,3" = "slow_stun_bomb", "4,3" = "shields", "5,3" = "hull",\
	"1,4" = "hull", "2,4" = "repair", "3,4" = "reactor", "4,4" = "repair", "5,4" = "hull",\
	"1,5" = "engine", "2,5" = "engine", "3,5" = "engine", "4,5" = "engine", "5,5" = "engine")

	/* WHWHW
	   HWCWH
	   HSWSH
		 HRRRH
	   EEEEE Jesus this thing is huge
	*/
