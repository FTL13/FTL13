/datum/starship/corvette
	name = "NT patrol corvette"
	description = "A small patrol ship used by NanoTrasen to protect their assets"
	salvage_map = "patrol_corvette.dmm"

	faction = list("nanotrasen",80)

	x_num = 3
	y_num = 3

	hull_integrity = 10
	shield_strength = 1
	evasion_chance = 25

	repair_time = 300
	recharge_rate = 150

	init_components = list("2,1" = "cockpit",\
	"1,2" = "fast_weapon", "2,2" = "hull", "3,2" = "mac_cannon",\
	"1,3" = "engine", "2,3" = "reactor", "3,3" = "engine")

	/*
	     C
	    WHW
	    ERE

	*/

/datum/starship/frigate //the ship the crew flies EDIT: okay maybe not. A smaller version of the ship the players fly.
	name = "NT patrol frigate"
	description = "A medium-size frigate used by NanoTrasen to protect important landmarks and other ships"

	//Boarding vars
	boarding_map = "frigate.dmm"
	boarding_chance = 5
	crew_outfit = /datum/outfit/defender/nanotrasen
	captain_outfit = /datum/outfit/defender/command/nanotrasen

	faction = list("nanotrasen",40)

	x_num = 3
	y_num = 3

	hull_integrity = 15
	shield_strength = 2
	evasion_chance = 20

	repair_time = 300
	recharge_rate = 150
	build_resources = list("iron" = 600, "silicon" = 400)
	init_components = list("1,1" = "hull", "1,2" = "mac_cannon", "3,1" = "hull",\
	"1,2" = "fast_weapon", "2,2" = "cockpit", "3,2" = "s_weapon",\
	"1,3" = "hull", "2,3" = "reactor", "3,3" = "hull",\
	"1,4" = "engine", "2,4" = "hull", "3,4" = "engine")

	/*
		HWH
		WCW
		HRH
		EHE
	*/

/datum/starship/cruiser //NT's big'um
	name = "NT battlecruiser"
	description = "A large cruiser used by NanoTrasen to protect the capital and lead their fleets"

	//Boarding vars
	boarding_map = "frigate.dmm" //temporary
	boarding_chance = 15
	crew_outfit = /datum/outfit/defender/nanotrasen
	captain_outfit = /datum/outfit/defender/command/nanotrasen

	faction = list("nanotrasen",10)

	x_num = 4
	y_num = 4

	hull_integrity = 30
	shield_strength = 2
	evasion_chance = 5

	repair_time = 250
	recharge_rate = 200
	build_resources = list("iron" = 1000, "silicon" = 750, "hyper" = 75)
	heat_points = 10

	init_components = list("1,1" = "hull", "2,1" = "mac_cannon", "3,1" = "chaingun", "4,1" = "hull",\
	"1,2" = "fast_weapon", "2,2" = "cockpit", "3,2" = "repair", "4,2" = "s_weapon",\
	"1,3" = "hull", "2,3" = "shields", "3,3" = "reactor", "4,3" = "hull",\
	"1,4" = "engine", "2,4" = "engine", "3,4" = "engine", "4,4" = "engine")


/*
	HWWH
	WCRW
	HSRH
	EEEE
*/
