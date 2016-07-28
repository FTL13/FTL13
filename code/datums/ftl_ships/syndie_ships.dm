/datum/starship/skirmisher
	name = "syndicate skirmisher"
	faction = list("syndicate",80)

	x_num = 3
	y_num = 3

	hull_integrity = 8
	shield_strength = 1
	evasion_chance = 30

	fire_rate = 100
	repair_time = 300
	recharge_rate = 150

	init_components = list("weapon"="2,1","cockpit"="2,2","engine"="1,3","reactor"="2,3","engine"="3,3")

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

	init_components = list("weapon"="1,1","hull"="2,1","cockpit"="3,1","hull"="4,1","weapon"="5,1","weapon"="1,2","shields"="2,2"\
	,"repair"="3,2","shields"="4,2","weapon"="5,2","hull"="1,3","shields"="2,3","repair"="3,3","shields"="4,3","hull"="5,3"\
	,"engine"="1,5","engine"="2,5","engine"="3,5","engine"="4,5","engine"="5,5")

	/* WHCHW
	   WSRSW
	   HSRSH
	   EEEEE Jesus this thing is huge
	*/

