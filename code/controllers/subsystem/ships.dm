
var/datum/controller/subsystem/ship/SSship

var/global/list/ftl_weapons_consoles = list()

/datum/controller/subsystem/ship
	name = "Ships"
	init_order = 100002 //before starmap
	wait = 10

	var/list/ships = list()

	var/list/star_factions = list()
	var/list/ship_components = list()
	var/list/ship_types = list()

	var/alert_sound = 'sound/machines/warning-buzzer.ogg'
	var/success_sound = 'sound/machines/ping.ogg'
	var/error_sound = 'sound/machines/buzz-sigh.ogg'
	var/notice_sound = 'sound/machines/twobeep.ogg'

	var/player_evasion_chance = 25 //evasion chance for the player ship

	var/datum/star_system/last_known_player_system = null

	var/heat_level = 0 //increases with every enemy ship destroyed, makes enemy factions more likely to gank you



/datum/controller/subsystem/ship/New()
	NEW_SS_GLOBAL(SSship)

/datum/controller/subsystem/ship/Initialize(timeofday)
	init_datums()


/datum/controller/subsystem/ship/proc/init_datums()
	var/list/factions = typesof(/datum/star_faction) - /datum/star_faction

	for(var/i in factions)
		star_factions += new i

	var/list/components = typesof(/datum/component) - /datum/component

	for(var/i in components)
		ship_components += new i

	var/list/ships = typesof(/datum/starship) - /datum/starship

	for(var/i in ships)
		ship_types += new i


/datum/controller/subsystem/ship/proc/cname2component(var/string)
	ASSERT(istext(string))
	for(var/datum/component/C in SSship.ship_components)
		if(C.cname == string) return C

/datum/controller/subsystem/ship/proc/faction2list(var/faction)
	var/list/f_ships = list()
	for(var/datum/starship/S in SSship.ship_types)
		if(S.faction[1] == faction || S.faction[1] == "neutral" || faction == "pirate") //If it matches the faction we're looking for or has no faction (generic neutral ship), or for pirates, any ship
			var/N = new S.type
			f_ships += N
			f_ships[N] = S.faction[2]

	return f_ships

/datum/controller/subsystem/ship/proc/cname2faction(var/faction)
	ASSERT(istext(faction))
	for(var/datum/star_faction/F in SSship.star_factions)
		if(F.cname == faction) return F

/datum/controller/subsystem/ship/proc/check_hostilities(var/A,var/B)
	var/datum/star_faction/faction_A = cname2faction(A)
	for(var/i in faction_A.relations)
		if(i == B)
			return faction_A.relations[i]


/datum/controller/subsystem/ship/proc/calculate_damage_effects(var/datum/starship/S)

	S.fire_rate = round(initial(S.fire_rate) * factor_damage_inverse(SHIP_WEAPONS,S))
	S.evasion_chance = round(initial(S.evasion_chance) * factor_damage(SHIP_ENGINES,S))
	S.recharge_rate = round(initial(S.recharge_rate) * factor_damage_inverse(SHIP_SHIELDS,S))
	S.repair_time = round(initial(S.repair_time) * factor_damage_inverse(SHIP_REPAIR,S))

	if(!factor_damage(SHIP_CONTROL,S)) S.evasion_chance = 0 //if you take out the bridge, they lose all evasion

/datum/controller/subsystem/ship/proc/repair_tick(var/datum/starship/S)
	var/starting_shields = S.shield_strength
	if(world.time > S.next_recharge && S.recharge_rate)
		S.next_recharge = world.time + S.recharge_rate
		S.shield_strength = min(initial(S.shield_strength), S.shield_strength + 1)
		if(S.shield_strength >= initial(S.shield_strength))
			if(S.shield_strength > starting_shields) broadcast_message("<span class=notice>[faction2prefix(S)] ship ([S.name]) has recharged shields to 100% strength.</span>",notice_sound,S)

	if(!find_broken_components(S))
		S.next_repair = world.time + S.repair_time
	if(world.time > S.next_repair && S.repair_time)
		S.next_repair = world.time + S.repair_time
		var/datum/component/C

		while(!C && find_broken_components(S)) //pick a broken component to fix
			C = pick(S.components)
			if(C.active) C = null
		if(C)
			C.active = 1 //fix that shit

			broadcast_message("<span class=notice>[faction2prefix(S)] ship ([S.name]) has repaired [C.name] at ([C.x_loc],[C.y_loc]).</span>",notice_sound,S)

/datum/controller/subsystem/ship/proc/attack_tick(var/datum/starship/S)
	if(S.attacking_player)
		if(SSstarmap.in_transit || SSstarmap.in_transit_planet)
			S.attacking_player = 0
			return
		if(S.planet != SSstarmap.current_planet)
			return
		if(world.time > S.next_attack && S.fire_rate)
			S.next_attack = world.time + S.fire_rate
			attack_player(S,pick(get_attacks(S)))
	if(S.attacking_target)
		if(S.attacking_target.planet != S.planet)
			return
		if(world.time > S.next_attack && S.fire_rate)
			S.next_attack = world.time + S.fire_rate
			ship_attack(S.attacking_target,S)

/datum/controller/subsystem/ship/proc/ship_attack(var/datum/starship/S,var/datum/starship/attacker)
	if(isnull(S)) // fix for runtime
		return
	damage_ship(pick(S.components),pick(get_attacks(S)),attacker)

/datum/controller/subsystem/ship/proc/attack_player(var/datum/starship/S,var/datum/ship_attack/attack_data)
	if(prob(player_evasion_chance))
		broadcast_message("<span class=notice> Enemy ship ([S.name]) fired but missed!</span>",success_sound,S)
	else
		if(SSstarmap.ftl_shieldgen && SSstarmap.ftl_shieldgen.is_active())
			SSstarmap.ftl_shieldgen.take_hit()
			broadcast_message("<span class=warning>Enemy ship ([S.name]) fired and hit! Hit absorbed by shields.",error_sound,S)
			for(var/area/shuttle/ftl/A in world)
				A << 'sound/weapons/Ship_Hit_Shields.ogg'
		else
			var/obj/docking_port/mobile/D = SSshuttle.getShuttle("ftl")


			var/list/target_list = D.return_unordered_turfs()
			var/turf/target
			while(!target)
				var/turf/T = pick(target_list)
				if(!istype(T,/turf/open/space))
					target = T

			playsound(target,'sound/effects/hit_warning.ogg',100,0) //give people a quick few seconds to get the hell out of the way

			spawn(50)
				attack_data.damage_effects(target) //BOOM!
				broadcast_message("<span class=warning>Enemy ship ([S.name]) fired and hit! Hit location: [target.loc].</span>",error_sound,S) //so the message doesn't get there early
				for(var/mob/living/carbon/human/M in player_list)
					if(!istype(M.loc.loc, /area/shuttle/ftl))
						continue
					var/dist = get_dist(M.loc, target.loc)
					shake_camera(M, dist > 20 ? 3 : 5, dist > 20 ? 1 : 3)


/datum/controller/subsystem/ship/proc/damage_ship(var/datum/component/C,var/datum/ship_attack/attack_data,var/datum/starship/attacking_ship = null)
	var/datum/starship/S = C.ship
	if(!S.attacking_player && !attacking_ship) //if they're friendly, make them unfriendly
		if(S.faction != "nanotrasen") //start dat intergalactic war
			make_hostile(S.faction,"ship")
			make_hostile(S.faction,"nanotrasen")
			make_hostile("nanotrasen",S.faction)
		else
			make_hostile(S.faction,"ship")
	if(attacking_ship)
		broadcast_message("<span class=notice>[faction2prefix(attacking_ship)] ship ([attacking_ship.name]) firing on [faction2prefix(S)] ship ([S.name]).",null,S)
	if((!attacking_ship && S.planet != SSstarmap.current_planet) || (attacking_ship && attacking_ship.planet != S.planet))
		spawn(10) //a bit of a delay wouldn't hurt, especially since we now have a cool af laser sound
			if(istype(S)) // fix for runtime (ship might have ceased to exist during the spawn)
				broadcast_message("<span class=notice>Shot missed! [faction2prefix(S)] ship ([S.name]) out of range!</span>",error_sound,S)
		return
	if(prob(S.evasion_chance * attack_data.evasion_mod))
		spawn(10)
			if(istype(S)) // fix for runtime (ship might have ceased to exist during the spawn)
				broadcast_message("<span class=notice>Shot missed! [faction2prefix(S)] ship ([S.name]) evaded!</span>",error_sound,S)
		return
	else
		spawn(10)
			if(istype(S)) // fix for runtime (ship might have ceased to exist during the spawn)
				broadcast_message("<span class=notice>Shot hit! ([S.name])</span>",success_sound,S)
	if(S.shield_strength >= 1 && !attack_data.shield_bust)
		S.shield_strength = max(S.shield_strength - attack_data.hull_damage, 0)
		S.next_recharge = world.time + S.recharge_rate
		if(S.shield_strength <= 0)
			spawn(10)
				if(istype(S)) // fix for runtime (ship might have ceased to exist during the spawn)
					broadcast_message("<span class=notice>Shot hit [faction2prefix(S)] shields. [faction2prefix(S)] ship ([S.name]) shields lowered!</span>",notice_sound,S)
		else
			spawn(10)
				if(istype(S)) // fix for runtime (ship might have ceased to exist during the spawn)
					broadcast_message("<span class=notice>Shot hit [faction2prefix(S)] shields. [faction2prefix(S)] ship shields at [S.shield_strength / initial(S.shield_strength) * 100]%!</span>",notice_sound,S)
		return
	if(S.hull_integrity > 0)
		S.hull_integrity = max(S.hull_integrity - attack_data.hull_damage,0)
		C.health = max(C.health - attack_data.hull_damage, 0)

		if(C.health <= 0)
			if(C.active)
				spawn(10)
					if(istype(S)) // fix for runtime (ship might have ceased to exist during the spawn)
						broadcast_message("<span class=notice>Shot hit [faction2prefix(S)] hull ([S.name]). [faction2prefix(S)] ship's [C.name] destroyed at ([C.x_loc],[C.y_loc]). [faction2prefix(S)] ship hull integrity at [S.hull_integrity].</span>",notice_sound,S)
			else
				spawn(10)
					if(istype(S)) // fix for runtime (ship might have ceased to exist during the spawn)
						broadcast_message("<span class=notice>Shot hit [faction2prefix(S)] hull ([S.name]). [faction2prefix(S)] ship's [C.name] was hit at ([C.x_loc],[C.y_loc]) but was already destroyed. [faction2prefix(S)] ship hull integrity at [S.hull_integrity].</span>",notice_sound,S)

			C.active = 0
		else
			spawn(10)
				if(istype(S)) // fix for runtime (ship might have ceased to exist during the spawn)
					broadcast_message("<span class=notice>Shot hit [faction2prefix(S)] hull ([S.name]). [faction2prefix(S)] ship's [C.name] damaged at ([C.x_loc],[C.y_loc]). [faction2prefix(S)] ship hull integrity at [S.hull_integrity].</span>",notice_sound,S)

	if(S.hull_integrity <= 0) destroy_ship(S)


/datum/controller/subsystem/ship/proc/destroy_ship(var/datum/starship/S)
	message_admins("[S.name] destroyed in [S.system] due to battle damage.")
	if(S.system != SSstarmap.current_system)
		qdel(S)
		return


	playsound_global (
		pick (
			'sound/effects/Enemy_Ship_Destroyed.ogg',
			'sound/effects/Enemy_Ship_Destroyed_2.ogg',
			'sound/effects/Enemy_Ship_Destroyed_3.ogg',
			)
	)
	broadcast_message("<span class=notice>[faction2prefix(S)] ship ([S.name]) reactor going supercritical! [faction2prefix(S)] ship destroyed!</span>",success_sound,S)

	if(S.planet != SSstarmap.current_planet)
		qdel(S)
		return

	if(S.attacking_player)
		heat_level += S.heat_points
	for(var/datum/objective/ftl/killships/O in SSstarmap.ship_objectives)
		if(S.faction == O.faction)
			O.ships_killed++
	if(S.boarding_map && prob(S.boarding_chance) && S.boarding_chance)
		if(SSstarmap.init_boarding(S))
			S.boarding_chance = 0
			broadcast_message("<span class=notice>[faction2prefix(S)] ([S.name]) main systems got disrupted! Now you can board it!</span>",alert_sound,S)
			message_admins("[faction2prefix(S)] ([S.name]) is able to be boarded")
			qdel(S)
	else
		var/obj/docking_port/D = S.planet.main_dock// Get main docking port
		var/list/coords = D.return_coords_abs()
		var/turf/T = locate(coords[3] + rand(1, 5), rand(coords[2], coords[4]), D.z)
		var/file = file("_maps/ship_salvage/[S.salvage_map]")
		if(isfile(file) && isturf(T))
			maploader.load_map(file, T.x, T.y, T.z)

			var/area/NA = new /area/ship_salvage
			NA.name = S.name

			for(var/datum/component/C in S.components)
				var/area/CA = locate(text2path("/area/ship_salvage/component/c_[C.x_loc]_[C.y_loc]"))
				var/amount_health = C.health / initial(C.health)
				for(var/atom/A in CA)
					if(isturf(A))
						NA.contents += A
					if(amount_health > 0.5 && amount_health < 1)
						A.ex_act(rand(2,3))
					else if(amount_health <= 0.5)
						A.ex_act(rand(1,2))

			var/area/HA = locate(/area/ship_salvage/hull)
			var/amount_hull = S.hull_integrity / initial(S.hull_integrity)
			for(var/atom/A in HA)
				if(isturf(A))
					NA.contents += A
				if(amount_hull > 0.5 && amount_hull < 1)
					A.ex_act(rand(2,3))
				else if(amount_hull <= 0.5)
					A.ex_act(rand(1,2))
		qdel(S)
	qdel(S)

/datum/controller/subsystem/ship/proc/broadcast_message(var/message,var/sound,var/datum/starship/S)
	if(S && S.system &&  S.system != SSstarmap.current_system)
		return //don't need information about every combat sequence happening across the galaxy
	for(var/obj/machinery/computer/ftl_weapons/C in ftl_weapons_consoles)
		C.status_update(message,sound)
	for (var/mob/living/silicon/aiPlayer in player_list)
		to_chat(aiPlayer, message)

/datum/controller/subsystem/ship/proc/factor_damage(var/flag,var/datum/starship/S)
	return factor_active_component(flag,S) / factor_component(flag,S)

/datum/controller/subsystem/ship/proc/factor_damage_inverse(var/flag,var/datum/starship/S) //oh god why
	if(!factor_active_component(flag,S)) return 0 //No dividing by 0.
	return factor_component(flag,S) / factor_active_component(flag,S)

/datum/controller/subsystem/ship/proc/factor_component(var/flag,var/datum/starship/S)
	var/comp_numb = 0
	for(var/datum/component/C in S.components)
		if(C.flags & flag) comp_numb++

	return comp_numb

/datum/controller/subsystem/ship/proc/factor_active_component(var/flag,var/datum/starship/S)
	var/comp_numb = 0
	for(var/datum/component/C in S.components)
		if((C.flags & flag) && C.active) comp_numb++

	return comp_numb

/datum/controller/subsystem/ship/proc/ship_ai(var/datum/starship/S)
	S.mission_ai.fire(S)
	S.operations_ai.fire(S)
	S.combat_ai.fire(S)



/datum/controller/subsystem/ship/proc/process_ftl(var/datum/starship/S)
	if(isnull(S)) // fix for runtime: cannot read null.name
		return
	if(!S.is_jumping)
		return

	S.jump_progress += round(S.evasion_chance / initial(S.evasion_chance))
	if((S.jump_progress >= S.jump_time) && !S.target)
		broadcast_message("<span class=notice>[faction2prefix(S)] ship ([S.name]) successfully charged FTL drive. [faction2prefix(S)] ship has left the system. Destination vector: ([S.ftl_vector.name])</span>",notice_sound,S)
		S.is_jumping = 0
		remove_system(S,S.system)
		S.jump_progress = 0
		spawn transit_system(S)
	if((S.jump_progress >= S.jump_time / 2) && S.target)
		broadcast_message("<span class=notice>[faction2prefix(S)] ship ([S.name]) sucessfully jumped to [S.target].</span>",notice_sound,S)
		S.planet = S.target
		S.is_jumping = 0
		S.jump_progress = 0

/datum/controller/subsystem/ship/proc/distress_call(var/datum/starship/caller,var/player_distress,var/datum/starship/target)
	if(caller.system.capital_planet)
		return //if the person calling for help is in the capital.. well screw you. Even if you're in the enemy capital you're on your own

	var/chance
	if(player_distress)
		chance = max(5,(heat_level * 5 + (caller.system.danger_level - 1) * 10) - 30)
		last_known_player_system = caller.system

	else
		chance = max(5,((caller.system.danger_level - 1) * 10) - 30)
		target.last_known_system = caller.system

	if(prob(chance))
		var/datum/star_faction/faction = cname2faction(caller.faction)
		var/list/possible_ships = list()

		for(var/datum/starship/S in faction.ships)
			if(S.mission_ai.cname == "MISSION_PATROL") //get roaming fleets to go first
				possible_ships += S

		if(!possible_ships.len && prob(FLEET_FORMATION_CHANCE))
			var/list/adjacent_systems = caller.system.adjacent_systems(caller.ftl_range)

			var/datum/star_system/formation_system = pick(adjacent_systems)
			var/datum/starship/flagship = pick(formation_system.ships)
			if(flagship.faction != caller.faction)
				return
			flagship.mission_ai = new /datum/ship_ai/chase

			if(player_distress)
				flagship.mission_ai:hunting_player = 1
			else
				flagship.mission_ai:chase_target = target

			for(var/datum/starship/other in formation_system)
				if(other.faction != flagship.faction)
					continue
				other.flagship = flagship
				other.mission_ai = new /datum/ship_ai/escort

		else if(possible_ships.len)
			var/datum/starship/flagship = pick(possible_ships)

			flagship.mission_ai = new /datum/ship_ai/chase

			if(player_distress)
				flagship.mission_ai:hunting_player = 1
			else
				flagship.mission_ai:chase_target = target









	broadcast_message("<span class=notice>[SSship.faction2prefix(caller)] communications intercepted from [SSship.faction2prefix(caller)] ship ([caller.name]). Distress signal to [caller.faction] fleet command decrypted.</span>",SSship.alert_sound,caller)



/datum/controller/subsystem/ship/proc/process_ships()
	process_factions()
	for(var/datum/starship/S in ships)
		process_ftl(S)
		calculate_damage_effects(S)
		repair_tick(S)
		if(S.attacking_player ||S.target) attack_tick(S)
		ship_ai(S)

//		if(S.system != SSstarmap.current_system)
//			qdel(S) //If we jump out of the system the ship is in, get rid of it to save processing power. Also gives the illusion of emergence.

/datum/controller/subsystem/ship/proc/make_hostile(var/A,var/B)
	var/datum/star_faction/F = cname2faction(A)
	for(var/i in F.relations)
		if(i == B) F.relations[i] = 0


/datum/controller/subsystem/ship/proc/find_broken_components(var/datum/starship/S)
	for(var/datum/component/C in S.components)
		if(!C.active) return 1

/datum/controller/subsystem/ship/proc/faction2prefix(var/datum/starship/S)
	if(!S) //Runtimes are bad
		return "Unknown"
	switch(check_hostilities(S.faction,"ship"))
		if(1)
			return "Allied"
		if(0)
			return "Enemy"
		if(-1)
			return "Neutral"

/datum/controller/subsystem/ship/proc/get_attacks(var/datum/starship/S)
	var/list/possible_attacks = list()
	for(var/datum/component/C in S.components)
		if(C.attack_data && C.active)
			possible_attacks += C.attack_data

	return possible_attacks

/datum/controller/subsystem/ship/proc/create_ship(var/datum/starship/starship,var/faction,var/datum/star_system/system,var/datum/planet/planet)
	ASSERT(faction && starship)

	var/datum/starship/S = new starship.type(1)
	var/datum/star_faction/mother_faction = cname2faction(faction)
	mother_faction.ships += S
	S.faction = faction

	if(S.operations_type)
		mother_faction.num_merchants += 1
	else
		mother_faction.num_warships += 1

	mother_faction.ships += S

	if(system)
		assign_system(S,system,planet)

	return S

/datum/controller/subsystem/ship/proc/assign_system(var/datum/starship/S,var/datum/star_system/system,var/datum/planet/planet)
	if(S.system)
		S.system.ships -= S

	S.system = system
	system.ships += S
	if(planet)
		S.planet = planet
	else
		S.planet = pick(system.planets)

	broadcast_message("<span class=notice>[faction2prefix(S)] ship ([S.name]) has jumped into the system. Arrival vector: ([S.last_system ? S.last_system : "Unknown"]) </span>",notice_sound,S)

/datum/controller/subsystem/ship/proc/remove_system(var/datum/starship/S,var/datum/star_system/system)
	for(var/datum/starship/other in S.system)
		if(!SSship.check_hostilities(other.faction,S.faction))
			S.last_known_system = S.ftl_vector
			break

	S.last_system = S.system
	S.system.ships -= S
	S.system = null
	S.planet = null

	S.attacking_target = null
	S.attacking_player = 0
	S.target = null


/datum/controller/subsystem/ship/proc/transit_system(var/datum/starship/S)
	sleep(S.ftl_time)
	assign_system(S,S.ftl_vector)
	S.ftl_vector = null

/datum/controller/subsystem/ship/proc/plot_course(var/datum/starship/S,var/datum/star_system/system)
	S.target_system = system
	S.star_path = get_path_to_system(S.system, system, S.ftl_range, 200)

/datum/controller/subsystem/ship/proc/spool_ftl(var/datum/starship/S,var/datum/star_system/target)
	if(!S.system || S.is_jumping)
		return //Don't spool up when we're already in transit, for the love of all things holy
	S.jump_progress = 0 //just in case things break horribly
	broadcast_message("<span class=notice>[SSship.faction2prefix(S)] ship ([S.name]) detected powering up FTL drive. FTL jump imminent.</span>",SSship.notice_sound,S)
	S.is_jumping = 1
	S.ftl_vector = target

/datum/controller/subsystem/ship/proc/process_factions()
	for(var/datum/star_faction/faction in star_factions)
		if(faction.abstract)
			continue

		var/idle_ships = list()

		for(var/datum/starship/S in faction.ships)
			if(S.mission_ai.cname == "MISSION_IDLE" && !S.operations_type)
				idle_ships += S

		for(var/datum/starship/S in idle_ships)
			var/system_to_protect = null

			for(var/datum/star_system/system in faction.systems) //systems are in descending order from highest to lowest danger level
				if(system.ships.len < system.danger_level)
					system_to_protect = system
					break

			S.mission_ai = new /datum/ship_ai/guard
			S.mission_ai:assigned_system = system_to_protect

	SSstarmap.process_economy()

/datum/controller/subsystem/ship/fire()
	process_ships()
