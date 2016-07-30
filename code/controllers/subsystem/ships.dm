
var/datum/subsystem/ship/SSship

/datum/subsystem/ship
	name = "Ships"
	init_order = 1 //not very important
	wait = 10

	var/list/ships = list()

	var/list/star_factions = list()
	var/list/ship_components = list()
	var/list/ship_types = list()

	var/list/consoles = list()

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

			playsound(target,'sound/effects/clockcult_gateway_disrupted.ogg',100,0) //give people a quick few seconds to get the hell out of the way

			spawn(30)
				explosion(target,1,3,5,10) //BOOM!

			broadcast_message("<span class=warning>Enemy ship ([S.name]) fired and hit! Hit location: [A.name].</span>",error_sound)


/datum/subsystem/ship/proc/damage_ship(var/datum/starship/S,var/damage)
	if(!S.attacking_player) //if they're friendly, make them unfriendly
		make_hostile(S.faction,"ship")
	if(S.planet != SSstarmap.current_planet)
		broadcast_message("<span class=notice>Shot missed! Enemy ship ([S.name]) out of range!</span>",error_sound)
		return
	if(prob(S.evasion_chance))
		broadcast_message("<span class=notice>Shot missed! Enemy ship ([S.name]) evaded!</span>",error_sound)
		return
	else
		broadcast_message("<span class=notice>Shot hit! ([S.name])</span>",success_sound)
	if(S.shield_strength >= 1)
		S.shield_strength = max(S.shield_strength - damage, 0)
		if(S.shield_strength <= 0)
			broadcast_message("<span class=notice>Shot hit enemy shields. Enemy ship ([S.name]) shields lowered!</span>",notice_sound)
		else
			broadcast_message("<span class=notice>Shot hit enemy shields. Enemy ship shields at [S.shield_strength / initial(S.shield_strength) * 100]%!</span>",notice_sound)
		return
	if(S.hull_integrity > 0)
		S.hull_integrity = max(S.hull_integrity - damage,0)
		var/datum/component/C = pick(S.components)

		C.health -= damage

		if(C.health <= 0)
			if(C.active) broadcast_message("<span class=notice>Shot hit enemy hull ([S.name]). Enemy ship's [C.name] destroyed at ([C.x_loc],[C.y_loc]). Enemy ship hull integrity at [S.hull_integrity].</span>",notice_sound)
			else broadcast_message("<span class=notice>Shot hit enemy hull ([S.name]). Enemy ship's [C.name] was hit at ([C.x_loc],[C.y_loc]) but was already destroyed. Enemy ship hull integrity at [S.hull_integrity].</span>",notice_sound)

			C.active = 0
		else
			broadcast_message("<span class=notice>Shot hit enemy hull ([S.name]). Enemy ship's [C.name] damaged at ([C.x_loc],[C.y_loc]). Enemy ship hull integrity at [S.hull_integrity].</span>",notice_sound)

	if(S.hull_integrity <= 0) destroy_ship(S)


/datum/subsystem/ship/proc/destroy_ship(var/datum/starship/S)
	broadcast_message("<span class=notice>Enemy ship ([S.name]) reactor going supercritical! Enemy ship destroyed!</span>",success_sound)
	qdel(S)

/datum/subsystem/ship/proc/broadcast_message(var/message,var/sound)
	for(var/obj/machinery/computer/ftl_scanner/C in consoles)
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

/datum/subsystem/ship/proc/process_ships()
	for(var/datum/starship/S in ships)
		if(SSstarmap.current_planet == S.planet)
			if(!check_hostilities(S.faction,"ship") && !S.attacking_player) commence_attack_player(S)
		calculate_damage_effects(S)
		repair_tick(S)
		if(S.attacking_player) attack_tick(S)
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




