/*
BOARDING EVENT - FTL13
Boarding event happens with some probability when player ship nearly destroys the enemy ship, making it unable to escape.
Survivors(aka Def) can reinitiate their ftl drive with control program and explode it, but it would take some time to adjust the settings.
They got a spare control program hidden in the remaining spare terminal(aka Point). Also they got some TC installed in there. In order for termial to
work it should be anchored somewhere, so you would manage TC to get some shit to defend themselves.
Player ship crew (aka Atk) should rush into the wreckage and capture the Point or just murderbone every enemy crewmen they will encounter.
Atk wins = Atk got access to Vault and can have some nice things from it, remaining Def explodes violently.
Def wins = ship explodes into the pieces, everyone involved dies. VIOLENTLY.
*/

//Loading boarding map
/datum/controller/subsystem/starmap/proc/init_boarding(var/datum/starship/S, var/admin_called = null)
	if(mode)
		return 0
	//doing this because ship should get to qdel faster than map loads
	var/full_name = "boarding/[S.boarding_map]"
	var/ship_name = S.name
	var/crew_type = S.crew_outfit
	var/captain_type = S.captain_outfit
	var/planet_type = S.planet
	var/list/components = S.components
	var/hull_integrity = S.hull_integrity
	qdel(S)
	minor_announce("Warning! Receiving signals from ([ship_name])!\
	 Their ship's system set up a Self-Destruct Mechanism! You need to hack their main panel and cancel destruction,\
		if you want to loot this ship!","Ship sensor automatic announcment")
	//Now adding map to planet_loader
	SSmapping.add_z_to_planet(planet_type, full_name, ship_name)
	if(!mode) //you can run only at one boarding event at the time
		testing("Boarding event starting...")
		if(prob(100) || admin_called) //TODO:prob(40)
			mode = new /datum/round_event/ghost_role/boarding
			mode.planet = planet_type
			if(!mode.check_role())
				message_admins("Boarding event start failed due lack of candidates.")
				mode = null
			else
				message_admins("Boarding event started!")
				mode.event_setup(crew_type,captain_type)
	//Bombing the damaged ship
	if(admin_called)
		for(var/datum/component/C in components)
			C.health = rand(0,3)
		hull_integrity = rand(0,3)
	var/area/NA = locate(/area/ship_salvage/component) in world
	NA.name = ship_name
	for(var/datum/component/C in components)
		var/area/CA = locate(text2path("/area/ship_salvage/component/c_[C.x_loc]_[C.y_loc]"))
		var/amount_health = C.health / initial(C.health)
		for(var/atom/A in CA)
			if(isturf(A))
				NA.contents += A
			if(amount_health <= 0.5)
				if(prob(10))
					A.ex_act(rand(2,3))

	var/area/HA = locate(/area/ship_salvage/hull) in world
	var/amount_hull = hull_integrity / initial(hull_integrity)
	for(var/atom/A in HA)
		if(isturf(A))
			HA.contents += A
		if(amount_hull <= 0.5)
			if(prob(10))
				A.ex_act(rand(2,3))
	return 1
