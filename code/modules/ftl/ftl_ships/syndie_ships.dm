/datum/starship/skirmisher
	name = "syndicate skirmisher"
	description = "A small Syndicate fighter, known for its low production cost"
	faction = list("syndicate",60)
	salvage_map = "skirmisher.dmm"

	x_num = 3
	y_num = 3

	hull_integrity = 8
	shield_strength = 1000
	evasion_chance = 30

	repair_time = 300
	recharge_rate = 150

	init_ship_components = list("2,1" = "weapon",\
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

	//Boarding vars
	boarding_map = "bulker.dmm"
	boarding_chance = 20

	x_num = 5
	y_num = 2

	hull_integrity = 15
	shield_strength = 0
	evasion_chance = 10

	repair_time = 250
	recharge_rate = 125
	build_resources = list("iron" = 300, "silicon" = 150, "hyper" = 25)
	heat_points = 3

	init_ship_components = list("1,1" = "s_weapon", "2,1" = "slow_weapon", "3,1" = "slow_chaingun","4,1" = "slow_weapon", "5,1" = "s_weapon",\
	"1,2" = "engine", "2,2" = "repair", "3,2" = "cockpit", "4,2" = "reactor", "5,2" = "engine")

	/*WWWWW
		ERCRE
	*/

	/datum/starship/carrier
		name = "syndicate carrier"
		description = "The syndicate carrier, usually used in guerilla and invasion operations"
		faction = list("syndicate",5)
		salvage_map = "skirmisher.dmm"

		//Boarding vars
		boarding_map = "bulker.dmm" //temp map
		boarding_chance = 10

		x_num = 3
		y_num = 3

		hull_integrity = 15
		shield_strength = 1000
		evasion_chance = 10
		repair_time = 250
		recharge_rate = 125
		build_resources = list("iron" = 500, "silicon" = 150, "hyper" = 25)
		heat_points = 3

		init_ship_components = list("1,1" = "hull", "2,1" = "cockpit", "3,1" = "hull",\
		"1,2" = "carrier_weapon", "2,2" = "shields", "3,2" = "carrier_weapon",\
		 "1,3" = "engine", "2,3" = "reactor", "3,3" = "engine")


/datum/starship/ravager
	name = "syndicate ravager"
	description = "The bane of every NanoTrasen crew; the huge Syndicate ravager, known for its strong hull and amazing firepower. You might want to run."
	faction = list("syndicate",5)
	salvage_map = "ravager.dmm"

	//Boarding vars
	boarding_map = "bulker.dmm" //temp map
	boarding_chance = 5

	x_num = 5
	y_num = 5

	hull_integrity = 40 //you're ded kiddo
	shield_strength = 3000
	evasion_chance = 5

	repair_time = 200
	recharge_rate = 150
	build_resources = list("iron" = 500, "silicon" = 250, "hyper" = 100)
	heat_points = 10

	init_ship_components = list("1,1" = "chaingun", "2,1" = "hull", "3,1" = "weapon", "4,1" = "hull", "5,1" = "mac_cannon",\
	"1,2" = "hull", "2,2" = "slow_firebomber", "3,2" = "cockpit", "4,2" = "slow_ion_weapon", "5,2" = "hull",\
	"1,3" = "hull", "2,3" = "shields", "3,3" = "slow_stunbomber", "4,3" = "shields", "5,3" = "hull",\
	"1,4" = "hull", "2,4" = "repair", "3,4" = "reactor", "4,4" = "repair", "5,4" = "hull",\
	"1,5" = "engine", "2,5" = "engine", "3,5" = "engine", "4,5" = "engine", "5,5" = "engine")

	/* WHWHW
	   HWCWH
	   HSWSH
		 HRRRH
	   EEEEE Jesus this thing is huge
	*/

/datum/starship/unknown_ship
	name = "Unknown ship class"
	description = "It's... Huge... You feel like this is the end for you"
	faction = list("syndicate",0)
	salvage_map = "skirmisher.dmm"

	hide_from_random_ships = TRUE
	heat_points = 100 //Hey turns out wiping an expensive ship really pisses off people who knew??

	x_num = 7
	y_num = 12

	hull_integrity = 400
	shield_strength = 60000 //Balanced
	evasion_chance = 1 //Big ship

	repair_time = 500
	recharge_rate = 200

	init_ship_components = list("2,1" = "r_weapon", "6,1" = "r_weapon",\
	"2,2" = "hull", "6,2" = "hull",\
	"1,3" = "r_weapon", "2,3" = "hull", "3,3" = "hull", "5,3" = "hull","6,3" = "hull", "7,3" = "r_weapon",\
	"2,4" = "shields", "3,4" = "hull", "5,4" = "hull","6,4" = "shields",\
	"1,5" = "r_weapon", "2,5" = "hull", "3,5" = "reactor", "5,5" = "reactor","6,5" = "hull", "7,5" = "r_weapon",\
	"2,6" = "shields", "3,6" = "hull", "4,6" = "unknown_ship_weapon", "5,6" = "hull","6,6" = "shields",\
	"1,7" = "r_weapon", "2,7" = "hull", "3,7" = "hull", "4,7" = "repair", "5,7" = "hull","6,7" = "hull", "7,7" = "r_weapon",\
	"2,8" = "repair", "3,8" = "hull", "4,8" = "cockpit", "5,8" = "hull","6,8" = "repair",\
	"1,9" = "engine", "2,9" = "hull", "3,9" = "reactor", "4,9" = "shields", "5,9" = "reactor","6,9" = "hull", "7,9" = "engine",\
	"1,10" = "engine", "2,10" = "hull", "3,10" = "reactor", "4,10" = "shields", "5,10" = "reactor","6,10" = "hull", "7,10" = "engine",\
	"2,11" = "r_weapon", "3,11" = "hull", "4,11" = "repair", "5,11" = "hull","6,11" = "r_weapon",\
	"2,12" = "engine", "3,12" = "engine", "4,12" = "r_weapon", "5,12" = "engine","6,12" = "engine")

/*
		X	W	X	X	X	W	X
		X	H	X	X	X	H	X
		W	H	H	X	H	H	W
		X	S	H	X	H	S	X
		W	H	R	X	R	H	W
		X	S	H	W	H	S	X
		W	H	H	r	H	H	W
		X	r	H	C	H	r	X
		E	H	R	S	R	H	E
		E	H	R	S	R	H	E
		X	W	H	r	H	W	X
		X	E	E	W	E	E	X
*/
