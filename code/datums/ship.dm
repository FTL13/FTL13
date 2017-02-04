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
	var/datum/starship/attacking_target = null

	var/next_repair = 0
	var/next_recharge = 0

	var/is_jumping = 0
	var/jump_progress = 0

	var/jump_time = 60
	var/datum/planet/target = null
	var/called_for_help = 0

	var/datum/ship_ai/operations_ai = /datum/ship_ai/standard_operations
	var/datum/ship_ai/combat_ai = /datum/ship_ai/standard_combat

	var/operations_type = 0 //0 = warship, 1 = merchant




/datum/starship/New(var/add_to_ships=0)
	generate_ship()
	if(add_to_ships) //to prevent the master ship list from being processed
		SSship.ships += src

/datum/starship/Destroy()
	SSship.ships -= src
	system.ships -= src

	var/datum/star_faction/mother_faction = SSship.cname2faction(faction)
	if(mother_faction)
		if(operations_type)
			mother_faction.num_merchants -= 1
		else
			mother_faction.num_warships -= 1

	return QDEL_HINT_HARDDEL_NOW

/datum/starship/proc/generate_ship() //a bit hacky but I can't think of a better way.... multidimensional lists?
	for(var/i in init_components)
		var/datum/component/component = SSship.cname2component(init_components[i])
		var/datum/component/C = new component.type
		components += C

		var/list/coords = splittext(i,",")

		C.x_loc = text2num(coords[1])
		C.y_loc = text2num(coords[2])
		C.ship = src
	combat_ai = new combat_ai
	operations_ai = new operations_ai



/datum/star_faction
	var/name = "generic faction"
	var/cname = "faction"

	var/list/relations //1 for ally, -1 for neutral, 0 for enemy

	var/abstract = 0 //set to 1 if it shouldn't be simulated economically

	var/money = 0
	var/s_money = 0 //money reserved for trade with other factions
	var/b_money = 0 //money reserved for buying from stations

	var/list/ships = list()

	var/num_warships = 0
	var/num_merchants = 0

	var/list/resources = list()

	var/list/systems = list()



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
	abstract = 1


/datum/component
	var/name = "generic component"
	var/cname = "component"

	var/health = 2
	var/flags = 0

	var/x_loc = 0 //(1,1) is top left
	var/y_loc = 0

	var/active = 1
	var/datum/starship/ship

	var/datum/ship_attack/attack_data = null

	var/alt_image

/datum/component/New()
	if(attack_data) attack_data = new attack_data

/datum/component/cockpit
	name = "bridge"
	cname = "cockpit"

	health = 3

	flags = SHIP_CONTROL

/datum/component/weapon
	name = "phase cannon"
	cname = "weapon"

	flags = SHIP_WEAPONS
	attack_data = /datum/ship_attack/laser

	alt_image = "weapon"

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

/datum/component/weapon/random
	name = "standard mount"
	cname = "r_weapon"


	var/list/possible_weapons = list(/datum/ship_attack/laser,/datum/ship_attack/ballistic,/datum/ship_attack/chaingun)

/datum/component/weapon/random/New()
		attack_data = pick(possible_weapons)
		attack_data = new attack_data
		name = attack_data.cname

/datum/component/weapon/random/special
	name = "special mount"
	cname = "s_weapon"

	possible_weapons = list(/datum/ship_attack/ion,/datum/ship_attack/stun_bomb,/datum/ship_attack/flame_bomb)

/datum/component/weapon/ion
	name = "ion cannon"
	cname = "ion_weapon"

	attack_data = /datum/ship_attack/ion

/datum/component/weapon/chaingun
	name = "chaingun"
	cname = "chaingun_weapon"

	attack_data = /datum/ship_attack/chaingun

// AI MODULES

/datum/ship_ai
	var/cname = "PARENT"

/datum/ship_ai/proc/fire(var/datum/starship/ship)
	return

// COMBAT MODULES
/datum/ship_ai/standard_combat
	cname = "COMBAT_STANDARD"

/datum/ship_ai/standard_combat/fire(datum/starship/ship)
	var/list/possible_targets = list()
	if(ship.attacking_target || ship.attacking_player)
		return
	for(var/datum/starship/O in ship.system.ships) //TODO: Add different AI algorithms for finding and assigning targets, as well as other behavior
		if(ship.faction == O.faction || ship == O)
			continue
		if(!SSship.check_hostilities(ship.faction,O.faction))
			possible_targets += O
	if(ship.system == SSstarmap.current_system && !SSship.check_hostilities(ship.faction,"ship"))
		possible_targets += "ship"
	if(!possible_targets.len)
		return
	var/datum/starship/chosen_target = pick(possible_targets)

	//this bottom part should probably be made into a separate proc when more targetting algorithms are made
	if(!istype(chosen_target)) //if "ship" is picked.
		ship.attacking_player = 1
		SSship.broadcast_message("<span class=notice>Warning! Enemy ship detected powering up weapons! ([ship.name]) Prepare for combat!</span>",SSship.alert_sound)
	else
		ship.attacking_target = chosen_target
		SSship.broadcast_message("<span class=notice>Caution! [SSship.faction2prefix(ship)] ship ([ship.name]) locking on to [SSship.faction2prefix(ship.attacking_target)] ship ([ship.attacking_target.name]).</span>")

	ship.next_attack = world.time + ship.fire_rate //so we don't get instantly cucked

//OPERATIONS MODULES
/datum/ship_ai/standard_operations
	cname = "OPS_STANDARD"
	var/retreat_threshold = 0.25
	var/no_damage_retreat = 0
	var/no_damage_intel = 0

/datum/ship_ai/standard_operations/fire(datum/starship/ship)
	if((ship.planet != SSstarmap.current_planet && prob(1) && ship.attacking_player)||(ship.attacking_target && ship.planet != ship.attacking_target.planet && prob(1)))
		if(ship.target)
			return
		if(ship.attacking_target && ship.attacking_target.target == ship.planet)
			return //if they're coming to us let em come. Prevents yakety saxing of two ships around the system.
		ship.is_jumping = 1
		if(ship.attacking_player)
			ship.target = SSstarmap.current_planet
		else
			ship.target = ship.attacking_target.planet

	if(!ship.is_jumping && !ship.called_for_help) //enemy ships can either call for help or run, not both
		if(ship.hull_integrity / initial(ship.hull_integrity) <= retreat_threshold)
			if(prob(50) && !no_damage_retreat)
				SSship.broadcast_message("<span class=notice>[SSship.faction2prefix(ship)] ship ([ship.name]) detected powering up FTL drive. FTL jump imminent.</span>",SSship.notice_sound)
				ship.is_jumping = 1
			else if(!no_damage_intel)
				SSship.broadcast_message("<span class=notice>[SSship.faction2prefix(ship)] communications intercepted from [SSship.faction2prefix(ship)] ship ([ship.name]). Distress signal to [SSship.faction2prefix(ship)] fleet command decrypted. Reinforcements are being sent.</span>",SSship.alert_sound)
				ship.called_for_help = 1

/datum/ship_ai/standard_operations/scout_operations
	cname = "OPS_RECON"
	retreat_threshold = 0.99