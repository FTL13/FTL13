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

	//Boarding vars
	var/boarding_map = null	//write here the name of the file and exstension - like: "example.dmm"
	var/boarding_chance = null	//chance for this ship not blowup into the pieces
	var/crew_outfit = /datum/outfit/defender/generic 	// write /datum/outfit/defender/<your desired type listed in gamemodes\miniantags\ftl\enemy_ship\outfit>
	var/captain_outfit = /datum/outfit/defender/command/generic	//yeah it's should be /datum/outfit/defender/[crew_outfit]/command but im to stupid to provide a better way

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
	var/datum/ship_ai/mission_ai = /datum/ship_ai/standard_mission

	var/operations_type = 0 //0 = warship, 1 = merchant

	var/ftl_range = 20 //maximum distance the ship can go in one jump (ly)
	var/datum/star_system/ftl_vector = null //next vector to jump in the ship's path
	var/datum/star_system/target_system = null //our ultimate destination
	var/list/star_path = null
	var/ftl_time = 1850

	var/datum/starship/flagship = null //the ship we're following
	var/datum/escort_player = null

	var/datum/star_system/last_known_system = null
	var/datum/star_system/last_system = null

	var/cargo_limit = 0
	var/cargo

	var/list/build_resources = list("iron" = 500, "silicon" = 250)
	var/heat_points = 1 //how angry the faction gets if we kill this

var/next_ship_id
/datum/starship/New(var/add_to_ships=0)
	name = "[name] ([next_ship_id++])"
	generate_ship()
	if(add_to_ships) //to prevent the master ship list from being processed
		SSship.ships += src

/datum/starship/Destroy()
	SSship.ships -= src
	system.ships -= src

	var/datum/star_faction/mother_faction = SSship.cname2faction(faction)
	if(mother_faction)
		mother_faction.ships -= src
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
	mission_ai = new mission_ai



/datum/star_faction
	var/name = "generic faction"
	var/cname = "faction"

	var/list/relations //1 for ally, -1 for neutral, 0 for enemy

	var/abstract = 0 //set to 1 if it shouldn't be simulated
	var/no_economy = 0 //set to 1 if the faction's economy shouldn't be simulated

	var/money = 0
	var/s_money = 0 //money reserved for trade with other factions
	var/b_money = 0 //money reserved for buying from stations
	var/spend_limit = 5000

	var/list/ships = list()
	var/credit_limit = -1000


	var/num_warships = 0
	var/num_merchants = 0

	var/list/resources = list()
	var/list/incoming_resources = list()
	var/list/prices = list()

	var/list/systems = list()
	var/datum/star_system/capital = null

	var/datum/starship/ship_to_build = null
	var/next_build_time = 0

	//bookkeeping
	var/tax_income = 0
	var/starting_funds = 0
	var/trade_income = 0
	var/trade_taxes = 0

	var/building_fee = 0
	var/resource_costs = 0
	var/trade_costs = 0





/datum/star_faction/solgov
	name = "SolGov"
	cname = "solgov"
	relations = list("ship"=-1,"nanotrasen"=-1,"syndicate"=-1,"pirate"=0) //"ship" faction represents the ship the players are on. E.g. if you attack NT ships NT ships will attack you.

/datum/star_faction/nanotrasen
	name = "Nanotrasen"
	cname = "nanotrasen"
	relations = list("ship"=1,"syndicate"=0,"solgov"=-1,"pirate"=0)

/datum/star_faction/syndicate
	name = "Syndicate"
	cname = "syndicate"
	relations = list("ship"=0,"nanotrasen"=0,"solgov"=-1,"pirate"=0)

/datum/star_faction/pirate //arr matey get me some rum
	name = "Pirates"
	cname = "pirate"
	relations = list("ship"=0,"nanotrasen"=0,"solgov"=0,"syndicate"=0)

	no_economy = 1

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

	attack_data = /datum/ship_attack/laser

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

/datum/component/weapon/random/memegun
	name = "meme weapon"
	cname = "meme_weapon"

	possible_weapons = list(/datum/ship_attack/slipstorm,/datum/ship_attack/honkerblaster,/datum/ship_attack/bananabomb)

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
	if(!ship.system || ship.attacking_target || ship.attacking_player || SSstarmap.in_transit || SSstarmap.in_transit_planet )
		return
	
	var/list/possible_targets = list()
	
	for(var/datum/starship/O in ship.system.ships) //TODO: Add different AI algorithms for finding and assigning targets, as well as other behavior
		if(ship.faction == O.faction || ship == O)
			continue
		if(!SSship.check_hostilities(ship.faction,O.faction))
			possible_targets += O
	if(ship.system && ship.system == SSstarmap.current_system && !SSship.check_hostilities(ship.faction,"ship"))
		possible_targets += "ship"
	if(!possible_targets.len)
		return
	var/datum/starship/chosen_target = pick(possible_targets)

	//this bottom part should probably be made into a separate proc when more targetting algorithms are made
	if(!istype(chosen_target)) //if "ship" is picked.
		ship.attacking_player = 1
		SSship.broadcast_message("<span class=notice>Warning! Enemy ship detected powering up weapons! ([ship.name]) Prepare for combat!</span>",SSship.alert_sound,ship)
	else
		ship.attacking_target = chosen_target
		SSship.broadcast_message("<span class=notice>Caution! [SSship.faction2prefix(ship)] ship ([ship.name]) locking on to [SSship.faction2prefix(ship.attacking_target)] ship ([ship.attacking_target.name]).</span>",null,ship)

	message_admins("[ship.name] has entered into combat at [ship.system]! [ship.attacking_player ? "" : "Combat was not due to players!"]")
	ship.next_attack = world.time + ship.fire_rate //so we don't get instantly cucked

//OPERATIONS MODULES
/datum/ship_ai/standard_operations
	cname = "OPS_STANDARD"
	var/retreat_threshold = 0.25
	var/no_damage_retreat = 0
	var/no_damage_intel = 0

/datum/ship_ai/standard_operations/fire(datum/starship/ship)
	if(ship.target_system && ship.target_system == ship.system)
		ship.target_system = null
		return

	if(ship.target_system && ship.system && !ship.is_jumping)
//		message_admins("[ship.name] [ship.system] [ship.mission_ai.cname] [ship.target_system] [ship.system]")
		if(!ship.star_path.len) //dunno how this happens yet but it does
			ship.star_path = get_path_to_system(ship.system, ship.target_system, ship.ftl_range, 200)
		var/datum/star_system/next_system = ship.star_path[1]
		ship.star_path -= next_system
		SSship.spool_ftl(ship,next_system)



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
				ship.mission_ai = new /datum/ship_ai/flee
			else if(!no_damage_intel)
				SSship.broadcast_message("<span class=notice>[SSship.faction2prefix(ship)] communications intercepted from [SSship.faction2prefix(ship)] ship ([ship.name]). Distress signal to [SSship.faction2prefix(ship)] fleet command decrypted. Reinforcements are being sent.</span>",SSship.alert_sound,ship)
				if(ship.attacking_player)
					SSship.distress_call(ship,1)
				else
					SSship.distress_call(ship,0,ship.attacking_target)
				ship.called_for_help = 1

/datum/ship_ai/standard_operations/scout_operations
	cname = "OPS_RECON"
	retreat_threshold = 0.99

//MISSION MODULES
/datum/ship_ai/standard_mission //idle ships chill unless they are out of capital
	cname = "MISSION_IDLE"

/datum/ship_ai/standard_mission/fire(datum/starship/ship)
	if(ship.faction == "pirate")
		return //pirate factions have no capital = nasty runtimes
	var/datum/star_faction/faction = SSship.cname2faction(ship.faction)
	if(ship.system != faction.capital)
		if(!ship.target_system)
			SSship.plot_course(ship,faction.capital)

/datum/ship_ai/guard //guarding ships will stay in their system and do jack shit, unless they're not in their assigned system
	cname = "MISSION_GUARD"
	var/datum/star_system/assigned_system = null

/datum/ship_ai/guard/fire(datum/starship/ship)
	if(!assigned_system)
		ship.mission_ai = new /datum/ship_ai/standard_mission
		return
	if(assigned_system != ship.system && ship.target_system != assigned_system)
		SSship.plot_course(ship,assigned_system)

/datum/ship_ai/flee //ships that flee will run back to the capital and abandon their fleet
	cname = "MISSION_FLEE"

/datum/ship_ai/flee/fire(datum/starship/ship)
	ship.flagship = null
	var/datum/star_system/escape_system = pick(ship.system.adjacent_systems(ship.ftl_range))

	if(escape_system.alignment != ship.faction && ship.faction != "pirate") //pirates don't care, arr
		return	//this ensures if there are no adjacent friendly systems we won't crash the game with a while loop
	if(!ship.target_system)
		SSship.plot_course(ship,escape_system)

	if(ship.target_system == ship.system)
		ship.mission_ai = new /datum/ship_ai/standard_mission

/datum/ship_ai/escort //escorting ships follow their flagships around
	cname = "MISSION_ESCORT"

/datum/ship_ai/escort/fire(datum/starship/ship)
	if(ship.is_jumping || !ship.system)
		return

	if(!ship.flagship)
		ship.mission_ai = new /datum/ship_ai/flee //the flagship is dead, panic!!! (or coders are dumb, in which case, panic!!!)
		return

	if(ship.flagship == "ship")
		if(SSstarmap.in_transit && ship.target_system != SSstarmap.to_system)
			SSship.plot_course(ship,SSstarmap.to_system)

		return

	if(ship.flagship.ftl_time < ship.ftl_time)
		ship.flagship = null
		return //this causes problems if our flagship is faster than us
	if(ship.flagship.target_system && ship.flagship.target_system != ship.target_system && prob(10))
		SSship.plot_course(ship,ship.flagship.ftl_vector)

/datum/ship_ai/patrol //patrolling ships wander around their faction's territory
	cname = "MISSION_PATROL"
	var/roam = 0 //1 = can go into other faction's systems
	var/next_jump_time = 0

/datum/ship_ai/patrol/fire(datum/starship/ship)
	if(ship.target_system || ship.attacking_target) //if we're ganking someone stay for the fight
		return

	if(world.time < next_jump_time)
		return

	var/datum/star_system/system = pick(ship.system.adjacent_systems(ship.ftl_range))
	if(system.alignment != ship.faction && !roam)
		return
	next_jump_time = world.time + ship.ftl_time  + 900
	SSship.plot_course(ship,system)

/datum/ship_ai/patrol/roam //rollin' rollin' rollin'
	cname = "MISSION_FREEROAM"
	roam = 1

/datum/ship_ai/chase //self explanatory
	cname = "MISSION_CHASE"
	var/datum/starship/chase_target
	var/hunting_player = 0

	var/tolerance = 180
	var/frustrated = 0

/datum/ship_ai/chase/fire(datum/starship/ship)
	if(ship.target_system)
		return

	if(chase_target)
		if(!chase_target.last_known_system)
			frustrated += 1
			return
		if(chase_target.last_known_system == ship.system && !ship.system.ships.Find(chase_target))
			frustrated += 1
			return

	if(frustrated >= tolerance || (!chase_target && !hunting_player))
		ship.mission_ai = new /datum/ship_ai/patrol //give up and wander around

	if(hunting_player && ship.system != SSship.last_known_player_system)
		SSship.plot_course(ship,SSship.last_known_player_system)
	if(ship.system != chase_target.last_known_system)
		if(chase_target.last_known_system)
			SSship.plot_course(ship,chase_target.last_known_system)

	if(hunting_player && ship.system == SSship.last_known_player_system && SSship.last_known_player_system != SSstarmap.current_system)
		frustrated += 1

/datum/ship_ai/trade
	cname = "MISSION_TRADE"

	var/datum/star_faction/sell_faction = null
	var/datum/space_station/buy_station = null

	var/resource
	var/exchange_amount = 0

/datum/ship_ai/trade/fire(datum/starship/ship)
	if(!resource)
		ship.mission_ai = new /datum/ship_ai/standard_mission

	if(ship.system != buy_station.planet.parent_system && !ship.target_system)
		SSship.plot_course(ship,buy_station.planet.parent_system)

	if(ship.system != sell_faction.capital && !ship.target_system && ship.cargo)
		SSship.plot_course(ship,sell_faction.capital)

	if(ship.system == buy_station.planet.parent_system && !ship.cargo)

		if(ship.planet == buy_station.planet)
			SSship.broadcast_message("<span class=notice>[SSship.faction2prefix(ship)] ship ([ship.name]) docking with trade station for cargo exchange.</span>",SSship.notice_sound,ship)

			buy_station.reserved_resources[resource] -= ship.cargo_limit
			var/datum/star_faction/buying_faction = SSship.cname2faction(ship.faction)
			buying_faction.b_money -= exchange_amount
			ship.cargo = resource

			var/datum/star_faction/station_faction = SSship.cname2faction(buy_station.planet.parent_system.alignment)

			if(station_faction != buying_faction)
				station_faction.money += exchange_amount * 0.3 //taxes yo
				station_faction.trade_taxes += exchange_amount

			SSstarmap.generate_system_prices(buy_station.planet.parent_system)

		else
			ship.is_jumping = 1
			ship.target = buy_station.planet

	if(ship.system == sell_faction.capital && ship.cargo)
		SSship.broadcast_message("<span class=notice>[SSship.faction2prefix(ship)] ship ([ship.name]) docking with capital spacedock for cargo exchange.</span>",SSship.notice_sound,ship)

		sell_faction.resources[resource] += ship.cargo_limit
		sell_faction.resources[resource] -= ship.cargo_limit
		var/datum/star_faction/buying_faction = SSship.cname2faction(ship.faction)
		if(buying_faction != sell_faction)
			buying_faction.money += exchange_amount
			sell_faction.s_money -= exchange_amount
			buying_faction.trade_income += exchange_amount
			sell_faction.trade_costs += exchange_amount

		else
			sell_faction.resource_costs += exchange_amount

		ship.cargo = null
		resource = null

		SSstarmap.generate_faction_prices(sell_faction)
