/datum/starship/clownship
	name = "Honkmothership"
	description = "A mischievious ship full of dangerous prank materials"
	faction = list("pirate",0)
	salvage_map = "placeholder.dmm"

	x_num = 4
	y_num = 4

	hull_integrity = 25 //Can't bring down memes easily
	shield_strength = 1
	evasion_chance = 5

	repair_time = 400
	recharge_rate = 200

	init_components = list("1,1" = "meme_weapon", "2,1" = "meme_weapon", "3,1" = "meme_weapon", "4,1" = "meme_weapon",\
	"1,2" = "shields", "2,2" = "repair", "3,2" = "cockpit", "4,2" = "shields",\
	"1,3" = "meme_weapon", "2,3" = "meme_weapon", "3,3" = "meme_weapon", "4,3" = "meme_weapon",\
	"1,4" = "engine", "2,4" = "engine", "3,4" = "engine", "4,4" = "engine",)


	/*
		WWWW
		SRCS
		WWWW
		EEEE
	*/

/datum/starship/test
	name = "Tester ship"
	description = "Shoot me to start boarding"
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

/datum/starship/ntescapeshuttle
	name = "civillian escape shuttle"
	faction = list("nanotrasen",0)
	salvage_map = "nanotrasen_escape_shuttle"

	x_num = 3
	y_num = 3

	hull_integrity = 5 // majority of the ship is hull, have fun living with the guilt of massacring civillians
	shield_strength = 0 // no shields on this ride to hell
	evasion_chance = 45 // decent evasion

	repair_time = 50 // crew are desperately trying to survive
	recharge_rate = 0
	operations_ai = /datum/ship_ai/flee
	init_components = list("1,1" = "hull", "2,1" = "cockpit", "3,1" = "hull", "1,2" = "hull", "2,2" = "hull", "3,2" = "hull", "1,3" = "engine", "2,3" = "repair", "3,3" = "engine")

	/*
	  HCH
	  HHH
	  ERE
	*/

/datum/starship/solgovpolice
	name = "space police vessel"
	faction = list("solgov",0)
	salvage_map = "space_police_vessel.dmm"

	x_num = 7
	y_num = 5

	hull_integrity = 12 // sol gov ships actually get funded by T A X P A Y E R S  D O L L A R S
	shield_strength = 6 // state of the art anti-cannonball protective fields
	evasion_chance = 5 // who needs evasion when the brigged convicts serve as extra hull

	fire_rate = 85 // the weapons officer is a retired chef and swiss cheese is on the menu
	repair_time = 250 // fixing those breaches would be easy af if it wasn't for the brig cells being blown open
	recharge_rate = 750 // majority of the power systems are focused on keeping the menaces of spess society in their brig cells
	init_components = list("2,1" = "hull", "3,1" = "r_weapon", "4,1" = "cockpit", "5,1" = "r_weapon", "6,1" = "hull", "1,2" = "weapon", "2,2" = "hull", "3,2" = "hull", "4,2" = "shields", "5,2" = "hull", "6,2" = "hull", "7,2" = "weapon", "2,3" = "engine", "3,3" = "hull", "4,3" = "hull", "5,3" = "hull", "6,3" = "engine", "3,4" = "engine", "4,4" = "repair", "5,4" = "engine", "4,5" = "engine")

	/*
	   HWCWH
	  WHHSHHW
	   EHHHE
	    ERE
	     E
	*/

/datum/starship/solgovpolicedrone
	name = "space police drone"
	faction = list("solgov",0)
	salvage_map = "null.dmm"

	x_num = 3
	y_num = 3

	hull_integrity = 5 // slightly tougher than your average drone
	shield_strength = 0 //
	evasion_chance = 45 // bit more nimble

	fire_rate = 75 // made to compliment the space police vessel firing rate, but otherwise useless without one
	repair_time = 0 //
	recharge_rate = 750 //
	init_components = list("1,1" = "ion_weapon", "2,1" = "drone", "3,1" = "ion_weapon", "1,2" = "ion_weapon", "2,2" = "engine", "3,2" = "ion_weapon")

	/*
	   WDW
	   WEW
	*/


/datum/starship/abductorterrorship
	name = "abductor terror ship"
	faction = list("pirate",0)
	salvage_map = "abductor_terror_ship.dmm"

	x_num = 4
	y_num = 4

	hull_integrity = 16 // extra thicc alien alloys
	shield_strength = 3 // powered by the dreams and souls of your loved ones
	evasion_chance = 35

	fire_rate = 60 // greyyliens gonna have a barbeque bonanza
	repair_time = 150 // regenerative hull, I may or may not have stole that idea from stellaris
	recharge_rate = 200 // the shields are recharged by dabbing floyds, pulling levers as they dab
	init_components = list("1,1" = "r_weapon", "2,1" = "hull", "3,1" = "hull", "4,1" = "r_weapon", "1,2"= "s_weapon", "2,2" = "hull", "3,2" = "hull", "4,2" = "s_weapon", "1,3" = "s_weapon", "2,3" = "shields", "3,3" = "hull", "4,3" = "s_weapon", "1,4" = "engine", "2,4" = "drone", "3,4" = "repair", "4,4" = "engine")

	/*
	   WHHW
	   WHHW
	   WSHW
	   EDRE
	*/