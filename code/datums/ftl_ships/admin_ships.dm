/datum/starship/clownship
	name = "Honkmothership"
	faction = list("pirate",0)
	salvage_map = "placeholder.dmm"

	x_num = 4
	y_num = 4

	hull_integrity = 25 //Can't bring down memes easily
	shield_strength = 1
	evasion_chance = 5

	fire_rate = 100 //HUEHUEHUE
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

	fire_rate = 200
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

	fire_rate = 120 // the weapons officer is a retired chef and swiss cheese is on the menu
	repair_time = 250 // fixing those breaches would be easy af if it wasn't for the brig cells being blown open
	recharge_rate = 750 // majority of the power systems are focused on keeping the menaces of spess society in their brig cells
	init_components = list("2,1" = "hull", "3,1" = "weapon", "4,1" = "cockpit", "5,1" = "weapon", "6,1" = "hull", "1,2" = "weapon", "2,2" = "hull", "3,2" = "hull", "4,2" = "shields", "5,2" = "hull", "6,2" = "hull", "7,2" = "weapon", "2,3" = "engine", "3,3" = "hull", "4,3" = "hull", "5,3" = "hull", "6,3" = "engine", "3,4" = "engine", "4,4" = "repair", "5,4" = "engine", "4,5" = "engine")

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
	salvage_map = "sparrow_craft.dmm"

	x_num = 3
	y_num = 3

	hull_integrity = 5 // slightly tougher than your average drone
	shield_strength = 0 //
	evasion_chance = 45 // bit more nimble

	fire_rate = 90 // made to compliment the space police vessel firing rate
	repair_time = 0 //
	recharge_rate = 750 //
	init_components = list("1,1" = "ion_weapon", "2,1" = "drone", "3,1" = "ion_weapon", "1,2" = "ion_weapon", "2,2" = "engine", "3,2" = "ion_weapon")

	/*
	   WDW
	   WEW
	*/


/datum/starship/abductorterrorship
	name = "abductor battle ship"
	faction = list("pirate",0)
	salvage_map = "null.dmm"

	x_num = 13
	y_num = 6

	hull_integrity = 35 // rare alien alloys
	shield_strength = 3 // decent shields
	evasion_chance = 0 // more of a stationary battle-ship

	fire_rate = 250 // human space barbeque, all greyyliens invited
	repair_time = 150 // multiple repair bays
	recharge_rate = 200 // good recharge rate
	init_components = list("3,1" = "ion_weapon", "4,1" = "hull", "5,1" = "ion_weapon", "6,1" = "hull", "7,1" = "ion_weapon", "8,1" = "hull", "9,1" = "ion_weapon", "10,1" = "hull", "11,1" = "ion_weapon", "1,2" = "s_weapon", "2,2" = "hull", "3,2" = "hull", "4,2" = "s_weapon", "5,2" = "cockpit", "6,2" = "s_weapon", "7,2" = "hull", "8,2" = "s_weapon", "9,2" = "cockpit", "10,2" = "s_weapon", "11,2" = "hull", "12,2" = "hull", "13,2" = "s_weapon", "2,3" = "s_weapon", "3,3" = "hull", "4,3" = "hull", "5,3" = "repair", "6,3" = "hull", "7,3" = "cockpit", "8,3" = "hull", "9,3" = "repair", "10,3" = "hull", "11,3" = "hull", "12,3" = "s_weapon", "3,4" = "hull", "4,4" = "engine", "5,4" = "engine", "6,4" = "hull", "7,4" = "shields", "8,4" = "hull", "9,4" = "engine", "10,4" = "engine", "11,4" = "hull", "3,5" = "hull", "6,5" = "hull", "7,5" = "hull", "8,5" = "hull", "9,5" = "hull", "11,5" = "hull", "3,6" = "s_weapon", "6,6" = "weapon", "7,6" = "weapon", "8,6" = "weapon", "11,6" = "s_weapon")


	/*
	     WHWHWHWHW
	   WHHWCWHWCWHHW
	    WHHRHCHRHHW
	   	 HEEHSHEEH
	   	 H  HHH  H
	   	 W  WWW  W
	*/