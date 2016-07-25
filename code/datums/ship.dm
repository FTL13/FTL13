/datum/ship/
	var/name = "generic thing"
	var/cname = "thing"

/datum/ship/starship
	name = "generic ship"
	cname = "ship"
	var/x_num = 0
	var/y_num = 0

	var/hull_integrity = 0
	var/shield_strength = 0
	var/fire_rate = 0 //in deciseconds. DO NOT leave this default or else the ship will fire every second. Unless, you want it to or something, you evil bastard.
	var/evasion_chance = 0

	var/repair_time = 0 // same as fire rate
	var/recharge_rate = 0 // shield points per second

	var/list/components = list()

	var/list/faction //the faction the ship belongs to. Leave blank for a "neutral" ship that all factions can use. with second argument being spawn chance

	var/list/init_components

	var/datum/star_system/system
	var/datum/planet/planet

	var/next_attack = 0
	var/attacking_player = 0

	var/next_repair = 0

	var/broken_components = 0

/datum/ship/starship/New(var/add_to_ships=0)
	generate_ship()
	if(add_to_ships) //to prevent the master ship list from being processed
		SSship.ships += src

/datum/ship/starship/Del()
	SSship.ships -= src

/datum/ship/starship/Destroy()
	return QDEL_HINT_HARDDEL_NOW

/datum/ship/starship/proc/generate_ship() //a bit hacky but I can't think of a better way.... multidimensional lists?
	for(var/i in init_components)
		var/datum/ship/component/component = SSship.cname2component(i)
		var/datum/ship/component/C = new component.type
		components += C

		var/list/coords = splittext(init_components[i],",")

		C.x_loc = coords[1]
		C.y_loc = coords[2]








/datum/ship/faction
	name = "generic faction"
	cname = "faction"

	var/list/relations //1 for ally, 0 for neutral, -1 for enemy


/datum/ship/faction/solgov
	name = "SolGov"
	cname = "solgov"
	relations = list("ship"=-1,"nanotrasen"=-1,"syndicate"=0) //"ship" faction represents the ship the players are on. E.g. if you attack NT ships NT ships will attack you.

/datum/ship/faction/nanotrasen
	name = "Nanotrasen"
	cname = "nanotrasen"
	relations = list("ship"=1,"syndicate"=0,"solgov"=-1)

/datum/ship/faction/syndicate
	name = "Syndicate"
	cname = "syndicate"
	relations = list("ship"=0,"nanotrasen"=0,"solgov"=0)

/datum/ship/faction/ship
	name = "Ship"
	cname = "ship"
	relations = list("nanotrasen"=1,"syndicate"=0,"solgov"=-1)


/datum/ship/component
	name = "generic component"
	cname = "component"

	var/health = 2
	var/flags = 0

	var/x_loc = 0 //(0,0) is top left
	var/y_loc = 0

	var/active = 1

/datum/ship/component/cockpit
	name = "bridge"
	cname = "cockpit"

	health = 3

	flags = SHIP_CONTROL

/datum/ship/component/weapon
	name = "weapon mount"
	cname = "weapon"

	flags = SHIP_WEAPONS

/datum/ship/component/shields
	name = "shield generator"
	cname = "shields"

	flags = SHIP_SHIELDS

/datum/ship/component/repair
	name = "engineering section"
	cname = "repair"

	flags = SHIP_REPAIR

/datum/ship/component/engines
	name = "engine nacelle"
	cname = "engine"

	health = 1

	flags = SHIP_ENGINES

/datum/ship/component/hull
	name = "hull"
	cname = "hull"

/datum/ship/component/reactor //compact engineering + shield component for smaller ships.
	name = "reactor compartment"
	cname = "reactor"

	flags = SHIP_SHIELDS | SHIP_REPAIR
