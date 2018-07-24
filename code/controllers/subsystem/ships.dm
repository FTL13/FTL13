GLOBAL_LIST_EMPTY(ftl_weapons_consoles)

SUBSYSTEM_DEF(ship)
	name = "Ships"
	init_order = INIT_ORDER_SHIPS
	flags = SS_BACKGROUND
	wait = 10

	var/list/ships = list()
	var/list/currentrun = list()

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


/datum/controller/subsystem/ship/Initialize(timeofday)
	init_datums()

/datum/controller/subsystem/ship/fire(resumed = FALSE)
	if(!resumed)
		src.currentrun = ships.Copy()
		process_factions()

	var/list/currentrun = src.currentrun
	while(currentrun.len)
		var/datum/starship/ship = currentrun[currentrun.len]
		currentrun.len--
		if(!ship || QDELETED(ship))
			ships -= ship
			if(MC_TICK_CHECK)
				return
			continue

		process_ftl(ship)
		calculate_damage_effects(ship)
		repair_tick(ship)

		if( ship.attacking_player || ship.target )
			attack_tick(ship)

		ship_ai(ship)

		if(MC_TICK_CHECK)
			return


/datum/controller/subsystem/ship/proc/init_datums()
	var/list/factions = subtypesof(/datum/star_faction)

	for(var/i in factions)
		star_factions += new i

	var/list/ship_components_paths = subtypesof(/datum/ship_component)

	for(var/i in ship_components_paths)
		ship_components += new i

	var/list/ships = subtypesof(/datum/starship)

	for(var/i in ships)
		ship_types += new i


/datum/controller/subsystem/ship/proc/cname2ship_component(var/string)
	ASSERT(istext(string))
	for(var/datum/ship_component/C in SSship.ship_components)
		if(C.cname == string) return C

/datum/controller/subsystem/ship/proc/faction2list(var/faction,var/only_hidden=FALSE)
	var/list/f_ships = list()
	for(var/datum/starship/S in SSship.ship_types)
		if(S.faction[1] == faction || S.faction[1] == "neutral" || faction == "pirate") //If it matches the faction we're looking for or has no faction (generic neutral ship), or for pirates, any ship
			if(!S.hide_from_random_ships && !only_hidden)
				var/N = new S.type
				f_ships += N
				f_ships[N] = S.faction[2]
			else if(S.hide_from_random_ships && only_hidden && faction != "pirate")
				var/N = new S.type
				f_ships += N
				f_ships[N] = S.faction[2]
				message_admins("[f_ships[N]]")
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
	for(var/datum/ship_component/weapon/W in S.ship_components)
		W.fire_rate = round(initial(W.fire_rate) * factor_damage_inverse(SHIP_WEAPONS,S))
	S.evasion_chance = round(initial(S.evasion_chance) * factor_damage(SHIP_ENGINES,S))
	S.recharge_rate = round(initial(S.recharge_rate) * factor_damage_inverse(SHIP_SHIELDS,S))
	S.repair_time = round(initial(S.repair_time) * factor_damage_inverse(SHIP_REPAIR,S))

	if(!factor_damage(SHIP_CONTROL,S)) S.evasion_chance = 0 //if you take out the bridge, they lose all evasion

/datum/controller/subsystem/ship/proc/repair_tick(var/datum/starship/S)
	var/starting_shields = S.shield_strength
	if(world.time > S.next_recharge && S.recharge_rate)
		S.next_recharge = world.time + S.recharge_rate
		S.shield_strength = min(initial(S.shield_strength), S.shield_strength + S.shield_regen_max * factor_damage(SHIP_SHIELDS,S))
		if(S.shield_strength >= initial(S.shield_strength))
			if(S.shield_strength > starting_shields) broadcast_message("<span class=notice>[faction2prefix(S)] ship ([S.name]) has recharged shields to 100% strength.</span>",notice_sound,S)

	if(!find_broken_ship_components(S))
		S.next_repair = world.time + S.repair_time
	if(world.time > S.next_repair && S.repair_time)
		S.next_repair = world.time + S.repair_time
		var/datum/ship_component/C

		while(!C && find_broken_ship_components(S)) //pick a broken ship_component to fix
			C = pick(S.ship_components)
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
		for(var/datum/ship_component/weapon/W in S.ship_components)
			if(world.time > W.next_attack && W.fire_rate)
				W.next_attack = world.time + W.fire_rate + rand(1,100)
				for(var/i in 1 to W.attack_data.shots_fired)
					addtimer(CALLBACK(src, .proc/attack_player, S, W), W.attack_data.fire_delay*i)
	if(S.attacking_target)
		if(S.attacking_target.planet != S.planet)
			return
		for(var/datum/ship_component/weapon/W in S.ship_components)
			if(world.time > W.next_attack && W.fire_rate)
				W.next_attack = world.time + W.fire_rate + rand(1,100)
				for(var/i in 1 to W.attack_data.shots_fired)
					addtimer(CALLBACK(src, .proc/ship_attack, S.attacking_target,S, W), W.attack_data.fire_delay*i)

/datum/controller/subsystem/ship/proc/ship_attack(var/datum/starship/S, var/datum/starship/attacker, var/datum/ship_component/weapon/W)
	if(isnull(S)) // fix for runtime
		return
	damage_ship(pick(S.ship_components), W.attack_data , attacker)

/datum/controller/subsystem/ship/proc/attack_player(var/datum/starship/S, var/datum/ship_component/weapon/W)
	var/datum/ship_attack/attack_data = W.attack_data

	if(prob(player_evasion_chance)) //Chance to miss
		broadcast_message("<span class=notice> Enemy ship ([S.name]) fired their [W.name] but missed!</span>",success_sound,S)
		return FALSE

	if(~attack_data.unique_effect & SHIELD_PENETRATE && SSstarmap.ftl_shieldgen && SSstarmap.ftl_shieldgen.is_active()) //If I penetrate shields I don't give one fucking shit about your shields so dont even check it, else check if we have a shield
		if(attack_data.shield_damage) //If I do shield damage, fuck those shields up.
			SSstarmap.ftl_shieldgen.take_hit(attack_data.shield_damage)
			broadcast_message("<span class=warning>Enemy ship ([S.name]) fired their [W.name] and hit! Hit absorbed by shields.",error_sound,S)
			return FALSE
		else //You can't pierce the shield if your weapon doesn't damage shields. Too bad kid.
			broadcast_message("<span class=warning>Enemy ship ([S.name]) fired their [W.name] but it was deflected by the shields.",success_sound,S)
			return FALSE

	var/obj/docking_port/mobile/D = SSshuttle.getShuttle("ftl")

	var/list/target_list = D.return_unordered_turfs()
	var/turf/target
	while(!target) //TODO:This will lag if the ship is fucked up too much should replace someday
		var/turf/T = pick(target_list)
		if(!istype(T,/turf/open/space))
			target = T //Turf picked to fire at.

	W.attack_effect(target) //Spawns the hit marker

	spawn(50) //TODO:heretic filth replace with timer someday

		if(W.attack_data.unique_effect & SHIELD_PENETRATE)
			broadcast_message("<span class=warning>Enemy ship ([S.name]) fired their [W.name], which pierced the shield and hit! Hit location: [target.loc].</span>",error_sound,S) //so the message doesn't get there early

		else
			broadcast_message("<span class=warning>Enemy ship ([S.name]) fired their [W.name] and hit! Hit location: [target.loc].</span>",error_sound,S) //so the message doesn't get there early
			for(var/mob/living/carbon/human/M in GLOB.player_list)
				if(!istype(M.loc.loc, /area/shuttle/ftl))
					continue
				var/dist = get_dist(M.loc, target.loc)
				shake_camera(M, dist > 20 ? 3 : 5, dist > 20 ? 1 : 3)

/datum/controller/subsystem/ship/proc/damage_ship(var/datum/ship_component/C,var/datum/ship_attack/attack_data,var/datum/starship/attacking_ship = null,var/shooter)
	var/datum/starship/S = C.ship
	if(attacking_ship)
		broadcast_message("<span class=notice>[faction2prefix(attacking_ship)] ship ([attacking_ship.name]) firing on [faction2prefix(S)] ship ([S.name]).",null,S)
	if((!attacking_ship && S.planet != SSstarmap.current_planet) || (attacking_ship && attacking_ship.planet != S.planet))
		spawn(10) //a bit of a delay wouldn't hurt, especially since we now have a cool af laser sound
			if(istype(S)) // fix for runtime (ship might have ceased to exist during the spawn)
				broadcast_message("<span class=notice>Shot missed! [faction2prefix(S)] ship ([S.name]) out of range!</span>",error_sound,S)
		return
	if(!attacking_ship) //No attacker means its the player
		if(check_hostilities(S.faction,"ship") != 0) //We only care if they ain't at war
			make_hostile(S.faction,"ship")
			log_admin("[key_name(shooter)] just shot a [S.faction] ship, causing them to become hostile!")
			message_admins("[ADMIN_LOOKUPFLW(shooter)] just shot a [S.faction] ship, causing them to become hostile!")
			if(S.faction != "nanotrasen") //start dat intergalactic war
				make_hostile(S.faction,"nanotrasen")
				make_hostile("nanotrasen",S.faction)
	if(prob(S.evasion_chance * attack_data.evasion_mod))
		spawn(10)
			if(istype(S)) // fix for runtime (ship might have ceased to exist during the spawn)
				broadcast_message("<span class=notice>Shot missed! [faction2prefix(S)] ship ([S.name]) evaded!</span>",error_sound,S)
		return
	else
		spawn(10)
			if(istype(S)) // fix for runtime (ship might have ceased to exist during the spawn)
				broadcast_message("<span class=notice>Shot hit! ([S.name])</span>",success_sound,S)
	if(S.shield_strength >= 151 && !(attack_data.unique_effect & SHIELD_PENETRATE))
		S.shield_strength = max(S.shield_strength - attack_data.shield_damage, 0)
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
		if(attack_data.unique_effect)
			if(attack_data.unique_effect & ION_BOARDING_BOOST) //boosts boarding chance if they use an ion cannon
				if(S.boarding_chance) //Prevents giving ships without boarding maps the buff
					S.boarding_chance += 5
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
	var/datum/star_faction/ship_faction_to_be_qdel = SSship.cname2faction(S.faction)
	ship_faction_to_be_qdel.ships -= S
	if(S.system != SSstarmap.current_system)
		qdel(S)
		return


	playsound_global (
		pick (
			'sound/effects/enemy_ship_destroyed.ogg',
			'sound/effects/enemy_ship_destroyed_2.ogg',
			'sound/effects/enemy_ship_destroyed_3.ogg',
			)
	)

	if(S.planet != SSstarmap.current_planet)
		qdel(S)
		return

	if(S.attacking_player)
		heat_level += S.heat_points
	for(var/datum/objective/ftl/killships/O in SSstarmap.ship_objectives)
		if(S.faction == O.faction)
			O.ships_killed++
	for(var/datum/objective/ftl/hold_system/O_h in SSstarmap.ship_objectives)
		if(SSstarmap.current_system == O_h.target_system && O_h.wave_active)
			O_h.ships_remaining--
	if(S.system.forced_boarding == S || (S.boarding_map && prob(S.boarding_chance) && !S.system.forced_boarding))
		broadcast_message("<span class=notice>[faction2prefix(S)] ship ([S.name]) essential systems critically damaged. Analysing for lifesigns.</span>",success_sound,S)
		if(SSstarmap.init_boarding(S,FALSE))
			S.boarding_chance = 0
			minor_announce("[S.name] has been critically damaged but remains intact. Several life signs are detected surrounding the Self-Destruct Mechanism. Docking possible.","Ship sensor automatic announcement")//Broadcasts are probably going to be missed in the combat spam. so have an announcement
			//broadcast_message("<span class=notice>[faction2prefix(S)] ([S.name]) main systems got disrupted! Now you can board it!</span>",alert_sound,S)
			message_admins("[faction2prefix(S)] ([S.name]) is able to be boarded")
			qdel(S)
	else
		broadcast_message("<span class=notice>[faction2prefix(S)] ship ([S.name]) reactor going supercritical! [faction2prefix(S)] ship destroyed!</span>",success_sound,S)
		/*var/obj/docking_port/D = S.planet.main_dock// Get main docking port //Turning all of this off since salvage doesn't init.
		var/list/coords = D.return_coords_abs()
		var/turf/T = locate(coords[3] + rand(1, 5), rand(coords[2], coords[4]), D.z)
		var/file = file("_maps/ship_salvage/[S.salvage_map]")
		if(isfile(file) && isturf(T))
			GLOB.maploader.load_map(file, T.x, T.y, T.z)

			var/area/NA = new /area/ship_salvage
			NA.name = S.name

			for(var/datum/ship_component/C in S.ship_components)
				var/area/CA = locate(text2path("/area/ship_salvage/ship_component/c_[C.x_loc]_[C.y_loc]"))
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
					A.ex_act(rand(1,2))*/
		qdel(S)
	qdel(S)

/datum/controller/subsystem/ship/proc/broadcast_message(var/message,var/sound,var/datum/starship/S)
	if(S && S.system &&  S.system != SSstarmap.current_system)
		return //don't need information about every combat sequence happening across the galaxy
	for(var/obj/machinery/computer/ftl_weapons/C in GLOB.ftl_weapons_consoles)
		C.status_update(message,sound)
	for (var/mob/living/silicon/aiPlayer in GLOB.player_list)
		to_chat(aiPlayer, message)

/datum/controller/subsystem/ship/proc/factor_damage(var/flag,var/datum/starship/S)
	if(!factor_ship_component(flag,S)) return 0 //No dividing by 0.
	return factor_active_ship_component(flag,S) / factor_ship_component(flag,S)

/datum/controller/subsystem/ship/proc/factor_damage_inverse(var/flag,var/datum/starship/S) //oh god why
	if(!factor_active_ship_component(flag,S))
		return 0 //No dividing by 0.
	return factor_ship_component(flag,S) / factor_active_ship_component(flag,S)

/datum/controller/subsystem/ship/proc/factor_ship_component(var/flag,var/datum/starship/S)
	var/comp_numb = 0
	for(var/datum/ship_component/C in S.ship_components)
		if(C.flags & flag) comp_numb++

	return comp_numb

/datum/controller/subsystem/ship/proc/factor_active_ship_component(var/flag,var/datum/starship/S)
	var/comp_numb = 0
	for(var/datum/ship_component/C in S.ship_components)
		if((C.flags & flag) && C.active) comp_numb++

	return comp_numb

/datum/controller/subsystem/ship/proc/ship_ai(var/datum/starship/S)
	S.mission_ai.fire(S)
	S.operations_ai.fire(S)
	S.combat_ai.fire(S)



/datum/controller/subsystem/ship/proc/process_ftl(var/datum/starship/S)
	if(!S.is_jumping)
		return

	S.jump_progress += round(S.evasion_chance / max(initial(S.evasion_chance),1))
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

//		if(S.system != SSstarmap.current_system)
//			qdel(S) //If we jump out of the system the ship is in, get rid of it to save processing power. Also gives the illusion of emergence.

/datum/controller/subsystem/ship/proc/make_hostile(var/A,var/B)
	var/datum/star_faction/F = cname2faction(A)
	for(var/i in F.relations)
		if(i == B) F.relations[i] = 0

/datum/controller/subsystem/ship/proc/find_broken_ship_components(var/datum/starship/S)
	for(var/datum/ship_component/C in S.ship_components)
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
	for(var/datum/ship_component/C in S.ship_components)
		if(C.attack_data && C.active)
			possible_attacks += C.attack_data

			return possible_attacks

/datum/controller/subsystem/ship/proc/create_ship(var/datum/starship/starship,var/faction,var/datum/star_system/system,var/datum/planet/planet)
	ASSERT(faction && starship)

	var/datum/starship/S = new starship.type(1)
	var/datum/star_faction/mother_faction = cname2faction(faction)
	mother_faction.ships += S
	S.faction = faction
	S.crew_outfit = mother_faction.default_crew_outfit
	S.captain_outfit = mother_faction.default_captain_outfit

	if(S.operations_type)
		mother_faction.num_merchants += 1
	else
		mother_faction.num_warships += 1

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
