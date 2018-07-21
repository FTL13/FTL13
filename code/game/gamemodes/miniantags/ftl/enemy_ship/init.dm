/*
BOARDING EVENT - FTL13
Boarding event happens with some probability when player ship nearly destroys the enemy ship, making it unable to escape.
Survivors(aka Def) can reinitiate their ftl drive with control program and explode it, but it would take some time to adjust the settings.
They got a spare control program hidden in the remaining spare terminal(aka Point). Also they got some TC installed in there. In order for termial to
work it should be anchored somewhere, so you would manage TC to get some shit to defend themselves.
Player ship crew (aka Atk) should rush into the wreckage and capture the Point or just murderbone every enemy crewmen they will encounter.
Atk wins = Atk got access to Vault and can have some nice things from it.
Def wins = ship explodes into the pieces, everyone involved dies. VIOLENTLY. Bonus points if Atk is still docked to the ship.
*/

//Loading boarding map
/datum/controller/subsystem/starmap/proc/init_boarding(var/datum/starship/S, var/admin_called = null)
	if(mode)
		return 0
	//doing this because ship should get to qdel faster than map loads
	var/full_name = "boarding/[S.boarding_map]"
	var/ship_name = S.name
	var/datum/star_faction.F = SSship.cname2faction(S.faction)
	var/crew_type = F.default_crew_outfit
	var/captain_type = F.default_captain_outfit
	var/planet_type = S.planet
	var/list/ship_components = S.ship_components
	var/mob_faction = S.mob_faction
	var/datum/star_system/location = S.system
	var/datum/objective/ftl/boardship/mission_objective
	for(var/datum/objective/ftl/boardship/O in ship_objectives)
		if(!O.failed && !O.completed) //Is the objective even active
			if(O.ship_target == S)
				mission_objective = O
				O.boarding_progress = BOARDING_MISSION_STARTED
				location.forced_boarding = null //Boarding has started. Remove the forced boarding ref
				minor_announce("Target ship [S] has been critically damaged. Scanning integrity...","Ship sensor automatic announcement") //To prevent the crew getting confused as to why the ship didn't insta begin boarding
				break
	message_admins("Boarding event starting, checking for players...")
	qdel(S)
	if(!mode) //you can run only at one boarding event at the time
		mode = new /datum/round_event/ghost_role/boarding //Check we even have people who want to play as defender before loading the z level
		if(mission_objective)
			mode.mission_datum = mission_objective
		testing("Boarding event starting...")
		mode.location = location
		if(prob(100) || admin_called)
			mode.planet = planet_type
			if(!mode.check_role() && !mission_objective)
				message_admins("Boarding event start failed due lack of candidates.")
				mode = null
			else
				var/alloc = SSmapping.add_z_to_planet(planet_type, full_name, ship_name)
				mode.shipname = ship_name
				message_admins("Boarding event started!")
				if(mission_objective)
					minor_announce("Ship in local system - Name: [ship_name]. has been critically damaged. The Blackbox is still intact and on the move. Boarding possible once the shield has ran out of power.","Ship sensor automatic announcement")
				else
					minor_announce("Ship in local system - Name: [ship_name]. has activated its Self-Destruct Mechanism. Expected detonation time is 18 minutes. Several lifesigns have been detected and have activated an anti-boarding shield. Boarding possible once the shield has ran out of power.","Ship sensor automatic announcement")
				mode.allocated_zlevel = alloc
				mode.event_setup(crew_type,captain_type,mob_faction,!mission_objective)
	//Bombing the damaged ship
	if(admin_called) //If admin_called, randomly damage components
		for(var/datum/ship_component/C in ship_components)
			C.health = rand(0,3)
	var/area/NA = locate(/area/ship_salvage/component) in world
	NA.name = ship_name
	for(var/datum/ship_component/C in ship_components)
		var/area/CA = locate(text2path("/area/ship_salvage/component/c_[C.x_loc]_[C.y_loc]"))
		var/amount_health = C.health / initial(C.health)
		for(var/atom/A in CA)
			if(isturf(A))
				NA.contents += A
			if(amount_health <= 0.5)
				if(prob(10))
					A.ex_act(rand(2,3))

	var/area/HA = locate(/area/ship_salvage/hull) in world
	var/amount_hull = rand(2,10)/10
	for(var/atom/A in HA)
		if(isturf(A))
			HA.contents += A
		if(amount_hull <= 0.5)
			if(prob(10))
				A.ex_act(rand(2,3))
	return 1
