
var/datum/subsystem/ship/SSship

var/global/list/ftl_weapons_consoles = list()

/datum/subsystem/ship
	name = "Ships"
	init_order = 1 //not very important
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



/datum/subsystem/ship/New()
	NEW_SS_GLOBAL(SSship)

/datum/subsystem/ship/Initialize(timeofday)
	init_datums()


/datum/subsystem/ship/proc/init_datums()
	var/list/factions = typesof(/datum/star_faction) - /datum/faction

	for(var/i in factions)
		star_factions += new i

	var/list/components = typesof(/datum/component) - /datum/component

	for(var/i in components)
		ship_components += new i

	var/list/ships = typesof(/datum/starship) - /datum/starship

	for(var/i in ships)
		ship_types += new i

/datum/subsystem/ship/proc/cname2component(var/string)
	ASSERT(istext(string))
	for(var/datum/component/C in SSship.ship_components)
		if(C.cname == string) return C

/datum/subsystem/ship/proc/faction2list(var/faction)
	var/list/f_ships = list()
	for(var/datum/starship/S in SSship.ship_types)
		if(S.faction[1] == faction || S.faction[1] == "neutral" || faction == "pirate") //If it matches the faction we're looking for or has no faction (generic neutral ship), or for pirates, any ship
			var/N = new S.type
			f_ships += N
			f_ships[N] = S.faction[2]

	return f_ships

/datum/subsystem/ship/proc/cname2faction(var/faction)
	ASSERT(istext(faction))
	for(var/datum/star_faction/F in SSship.star_factions)
		if(F.cname == faction) return F

/datum/subsystem/ship/proc/check_hostilities(var/A,var/B)
	var/datum/star_faction/faction_A = cname2faction(A)
	for(var/i in faction_A.relations)
		if(i == B)
			return faction_A.relations[i]


/datum/subsystem/ship/proc/calculate_damage_effects(var/datum/starship/S)

	S.fire_rate = round(initial(S.fire_rate) * factor_damage_inverse(SHIP_WEAPONS,S))
	S.evasion_chance = round(initial(S.evasion_chance) * factor_damage(SHIP_ENGINES,S))
	S.recharge_rate = round(initial(S.recharge_rate) * factor_damage_inverse(SHIP_SHIELDS,S))
	S.repair_time = round(initial(S.repair_time) * factor_damage_inverse(SHIP_REPAIR,S))

	if(!factor_damage(SHIP_CONTROL,S)) S.evasion_chance = 0 //if you take out the bridge, they lose all evasion

/datum/subsystem/ship/proc/repair_tick(var/datum/starship/S)
	var/starting_shields = S.shield_strength
	if(world.time > S.next_recharge && S.recharge_rate)
		S.next_recharge = world.time + S.recharge_rate
		S.shield_strength = min(initial(S.shield_strength), S.shield_strength + 1)
		if(S.shield_strength >= initial(S.shield_strength))
			if(S.attacking_player && S.shield_strength > starting_shields) broadcast_message("<span class=notice>Enemy ship ([S.name]) has recharged shields to 100% strength.</span>",notice_sound)

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

			broadcast_message("<span class=notice>Enemy ship ([S.name]) has repaired [C.name] at ([C.x_loc],[C.y_loc]).</span>",notice_sound)

/datum/subsystem/ship/proc/attack_tick(var/datum/starship/S)
	if(S.planet != SSstarmap.current_planet)
		S.attacking_player = 0
		broadcast_message("<span class=notice> Left weapons range of enemy ship ([S.name]). Enemy ship disengaging.</span>",notice_sound)
		return
	if(world.time > S.next_attack && S.fire_rate)
		S.next_attack = world.time + S.fire_rate
		attack_player(S)

/datum/subsystem/ship/proc/attack_player(var/datum/starship/S)
	if(prob(player_evasion_chance))
		broadcast_message("<span class=notice> Enemy ship ([S.name]) fired but missed!</span>",success_sound)
	else
		if(SSstarmap.ftl_shieldgen && SSstarmap.ftl_shieldgen.is_active())
			SSstarmap.ftl_shieldgen.take_hit()
			broadcast_message("<span class=warning>Enemy ship ([S.name]) fired and hit! Hit absorbed by shields.",error_sound)
			for(var/area/shuttle/ftl/A in world)
				A << 'sound/weapons/Ship_Hit_Shields.ogg'
		else
			var/list/ship_areas = typesof(/area/shuttle/ftl) - /area/shuttle/ftl - /area/shuttle/ftl/subshuttle

			var/area/shuttle/ftl/A = locate(pick(ship_areas))

			var/list/area_contents = area_contents(A)

			var/list/possible_targets = list()
			for(var/atom/AO in area_contents)
				if(isturf(AO)) possible_targets += AO

			var/turf/target = pick(possible_targets)

			playsound(target,'sound/effects/hit_warning.ogg',100,0) //give people a quick few seconds to get the hell out of the way

			spawn(50)
				explosion(target,1,3,5,10) //BOOM!
				broadcast_message("<span class=warning>Enemy ship ([S.name]) fired and hit! Hit location: [A.name].</span>",error_sound) //so the message doesn't get there early
				for(var/mob/living/carbon/human/M in player_list)
					if(!istype(M.loc.loc, /area/shuttle/ftl))
						continue
					var/dist = get_dist(M.loc, target.loc)
					shake_camera(M, dist > 20 ? 3 : 5, dist > 20 ? 1 : 3)


/datum/subsystem/ship/proc/damage_ship(var/datum/component/C,var/damage,var/evasion_mod=1,var/shield_bust=0)
	var/datum/starship/S = C.ship
	if(!S.attacking_player) //if they're friendly, make them unfriendly
		make_hostile(S.faction,"ship")
	if(S.planet != SSstarmap.current_planet)
		spawn(10) //a bit of a delay wouldn't hurt, especially since we now have a cool af laser sound
			broadcast_message("<span class=notice>Shot missed! Enemy ship ([S.name]) out of range!</span>",error_sound)
		return
	if(prob(S.evasion_chance * evasion_mod))
		spawn(10)
			broadcast_message("<span class=notice>Shot missed! Enemy ship ([S.name]) evaded!</span>",error_sound)
		return
	else
		spawn(10)
			broadcast_message("<span class=notice>Shot hit! ([S.name])</span>",success_sound)
	if(S.shield_strength >= 1 && !shield_bust)
		S.shield_strength = max(S.shield_strength - damage, 0)
		S.next_recharge = world.time + S.recharge_rate
		if(S.shield_strength <= 0)
			spawn(10)
				broadcast_message("<span class=notice>Shot hit enemy shields. Enemy ship ([S.name]) shields lowered!</span>",notice_sound)
		else
			spawn(10)
				broadcast_message("<span class=notice>Shot hit enemy shields. Enemy ship shields at [S.shield_strength / initial(S.shield_strength) * 100]%!</span>",notice_sound)
		return
	if(S.hull_integrity > 0)
		S.hull_integrity = max(S.hull_integrity - damage,0)
		C.health = max(C.health - damage, 0)

		if(C.health <= 0)
			if(C.active)
				spawn(10)
					broadcast_message("<span class=notice>Shot hit enemy hull ([S.name]). Enemy ship's [C.name] destroyed at ([C.x_loc],[C.y_loc]). Enemy ship hull integrity at [S.hull_integrity].</span>",notice_sound)
			else
				spawn(10)
					broadcast_message("<span class=notice>Shot hit enemy hull ([S.name]). Enemy ship's [C.name] was hit at ([C.x_loc],[C.y_loc]) but was already destroyed. Enemy ship hull integrity at [S.hull_integrity].</span>",notice_sound)

			C.active = 0
		else
			spawn(10)
				broadcast_message("<span class=notice>Shot hit enemy hull ([S.name]). Enemy ship's [C.name] damaged at ([C.x_loc],[C.y_loc]). Enemy ship hull integrity at [S.hull_integrity].</span>",notice_sound)

	if(S.hull_integrity <= 0) destroy_ship(S)


/datum/subsystem/ship/proc/destroy_ship(var/datum/starship/S)
	playsound_global (
		pick (
			'sound/effects/Enemy_Ship_Destroyed.ogg',
			'sound/effects/Enemy_Ship_Destroyed_2.ogg',
			'sound/effects/Enemy_Ship_Destroyed_3.ogg',
			)
	)
	broadcast_message("<span class=notice>Enemy ship ([S.name]) reactor going supercritical! Enemy ship destroyed!</span>",success_sound)
	for(var/datum/objective/ftl/killships/O in SSstarmap.ship_objectives)
		if(S.faction == O.faction)
			O.ships_killed++
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

/datum/subsystem/ship/proc/broadcast_message(var/message,var/sound)
	for(var/obj/machinery/computer/ftl_weapons/C in ftl_weapons_consoles)
		C.status_update(message,sound)

/datum/subsystem/ship/proc/factor_damage(var/flag,var/datum/starship/S)
	return factor_active_component(flag,S) / factor_component(flag,S)

/datum/subsystem/ship/proc/factor_damage_inverse(var/flag,var/datum/starship/S) //oh god why
	if(!factor_active_component(flag,S)) return 0 //No dividing by 0.
	return factor_component(flag,S) / factor_active_component(flag,S)

/datum/subsystem/ship/proc/factor_component(var/flag,var/datum/starship/S)
	var/comp_numb = 0
	for(var/datum/component/C in S.components)
		if(C.flags & flag) comp_numb++

	return comp_numb

/datum/subsystem/ship/proc/factor_active_component(var/flag,var/datum/starship/S)
	var/comp_numb = 0
	for(var/datum/component/C in S.components)
		if((C.flags & flag) && C.active) comp_numb++

	return comp_numb

/datum/subsystem/ship/proc/ship_ai(var/datum/starship/S)
	if(!S.is_jumping && !S.called_for_help) //enemy ships can either call for help or run, not both
		if((S.hull_integrity/initial(S.hull_integrity)) <= 0.25 && !S.no_damage_retreat)
			if(prob(50))
				broadcast_message("<span class=notice>Enemy ship ([S.name]) detected powering up FTL drive. FTL jump imminent.</span>",notice_sound)
				S.is_jumping = 1
			else
				broadcast_message("<span class=notice>Enemy communications intercepted from enemy ship ([S.name]). Distress signal to enemy fleet command decrypted. Reinforcements are being sent.</span>",alert_sound)
				S.called_for_help = 1
				spawn(0)
					distress_call(SSstarmap.current_system)
	if(S.planet != SSstarmap.current_planet && prob(1) && !S.target && !check_hostilities(S.faction,"ship"))
		broadcast_message("<span class=warning>Enemy ship ([S.name]) at [S.planet] powering up FTL drive for interplanetary jump.</span>",alert_sound)
		S.is_jumping = 1
		S.target = SSstarmap.current_planet



/datum/subsystem/ship/proc/process_ftl(var/datum/starship/S)
	if(!S.is_jumping)
		return
	S.jump_progress += round(S.evasion_chance / initial(S.evasion_chance))
	if((S.jump_progress >= S.jump_time) && !S.target)
		broadcast_message("<span class=notice>Enemy ship ([S.name]) successfully charged FTL drive. Enemy ship has left the system.</span>",notice_sound)
		qdel(S)
	if((S.jump_progress >= S.jump_time / 2) && S.target)
		broadcast_message("<span class=notice>Enemy ship ([S.name]) sucessfully jumped to [S.target].</span>",notice_sound)
		S.planet = S.target
		S.is_jumping = 0

/datum/subsystem/ship/proc/distress_call(var/datum/star_system/system)
	sleep(100)
	if(system != SSstarmap.current_system)
		return
	var/num_ships = 0
	if(prob(1))
		priority_announce("Large enemy fleet movements detected on long range sensors closing on your position. Recommended course of action: Get the fuck out of there.")
		num_ships = rand(8,20)
	else
		num_ships = rand(1,4)
	sleep(1200)
	if(system != SSstarmap.current_system)
		return
	SSstarmap.generate_npc_ships(num_ships)
	broadcast_message("<span class=warning>Warning: [num_ships] enemy contacts detected jumping into system.</span>",alert_sound)


/datum/subsystem/ship/proc/process_ships()
	for(var/datum/starship/S in ships)
		if(SSstarmap.current_planet == S.planet)
			if(!check_hostilities(S.faction,"ship") && !S.attacking_player) commence_attack_player(S)
		process_ftl(S)
		calculate_damage_effects(S)
		repair_tick(S)
		if(S.attacking_player) attack_tick(S)
		ship_ai(S)
		if(S.system != SSstarmap.current_system)
			qdel(S) //If we jump out of the system the ship is in, get rid of it to save processing power. Also gives the illusion of emergence.


/datum/subsystem/ship/proc/commence_attack_player(var/datum/starship/S)
	broadcast_message("<span class=notice>Warning! Enemy ship detected powering up weapons! ([S.name]) Prepare for combat!</span>",alert_sound)
	S.attacking_player = 1
	S.next_attack = world.time + S.fire_rate //so we don't get instantly cucked

/datum/subsystem/ship/proc/make_hostile(var/A,var/B)
	var/datum/star_faction/F = cname2faction(A)
	for(var/i in F.relations)
		if(i == B) F.relations[i] = 0


/datum/subsystem/ship/proc/find_broken_components(var/datum/starship/S)
	for(var/datum/component/C in S.components)
		if(!C.active) return 1

/datum/subsystem/ship/fire()
	process_ships()
