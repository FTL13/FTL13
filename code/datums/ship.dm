/datum/starship
	var/name = "generic ship"
	var/x_num = 0
	var/y_num = 0

	var/hull_integrity = 0
	var/shield_strength = 0
	var/fire_rate = 0 //in deciseconds. DO NOT leave this default or else the ship will fire every second. Unless, you want it to or something, you evil bastard.
	var/evasion_chance = 0

	var/repair_time = 0 // same as fire rate
	var/recharge_rate = 0 // shield points per second

	var/list/components = list()
	var/salvage_map = "placeholder.dmm"

	var/list/faction //the faction the ship belongs to. Leave blank for a "neutral" ship that all factions can use. with second argument being spawn chance

	var/list/init_components

	var/datum/star_system/system
	var/datum/planet/planet

	var/next_attack = 0
	var/attacking_player = 0

	var/next_repair = 0
	var/next_recharge = 0


/datum/starship/New(var/add_to_ships=0)
	generate_ship()
	if(add_to_ships) //to prevent the master ship list from being processed
		SSship.ships += src



/datum/starship/Destroy()
	SSship.ships -= src
	system.ships -= src
	return QDEL_HINT_HARDDEL_NOW

/datum/starship/proc/generate_ship() //a bit hacky but I can't think of a better way.... multidimensional lists?
	for(var/i in init_components)
		var/datum/component/component = SSship.cname2component(init_components[i])
		var/datum/component/C = new component.type
		components += C

		var/list/coords = splittext(i,",")

		C.x_loc = coords[1]
		C.y_loc = coords[2]








/datum/star_faction
	var/name = "generic faction"
	var/cname = "faction"

	var/list/relations //1 for ally, -1 for neutral, 0 for enemy


/datum/star_faction/solgov
	name = "SolGov"
	cname = "solgov"
	relations = list("ship"=-1,"nanotrasen"=-1,"syndicate"=0,"pirate"=0) //"ship" faction represents the ship the players are on. E.g. if you attack NT ships NT ships will attack you.

/datum/star_faction/nanotrasen
	name = "Nanotrasen"
	cname = "nanotrasen"
	relations = list("ship"=1,"syndicate"=0,"solgov"=-1,"pirate"=0)

/datum/star_faction/syndicate
	name = "Syndicate"
	cname = "syndicate"
	relations = list("ship"=0,"nanotrasen"=0,"solgov"=0,"pirate"=0)

/datum/star_faction/pirate //arr matey get me some rum
	name = "Pirates"
	cname = "pirate"
	relations = list("ship"=0,"nanotrasen"=0,"solgov"=0,"syndicate"=0)

/datum/star_faction/ship
	name = "Ship"
	cname = "ship"
	relations = list("nanotrasen"=1,"syndicate"=0,"solgov"=-1)


/datum/component
	var/name = "generic component"
	var/cname = "component"

	var/health = 2
	var/flags = 0

	var/x_loc = 0 //(0,0) is top left
	var/y_loc = 0

	var/active = 1

/datum/component/cockpit
	name = "bridge"
	cname = "cockpit"

	health = 3

	flags = SHIP_CONTROL

/datum/component/weapon
	name = "weapon mount"
	cname = "weapon"

	flags = SHIP_WEAPONS

/datum/component/shields
	name = "shield generator"
	cname = "shields"

	flags = SHIP_SHIELDS

/datum/component/repair
	name = "engineering section"
	cname = "repair"

	flags = SHIP_REPAIR

/datum/component/engines
	name = "engine nacelle"
	cname = "engine"

	health = 1

	flags = SHIP_ENGINES

/datum/component/hull
	name = "hull"
	cname = "hull"

/datum/component/reactor //compact engineering + shield component for smaller ships.
	name = "reactor compartment"
	cname = "reactor"

	flags = SHIP_SHIELDS | SHIP_REPAIR

/datum/component/drone_core
	name = "drone control core"
	cname = "drone"

	health = 2

	flags = SHIP_WEAPONS | SHIP_CONTROL