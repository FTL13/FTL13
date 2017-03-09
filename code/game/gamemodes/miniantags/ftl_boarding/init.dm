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
/datum/subsystem/starmap/proc/init_boarding(var/datum/starship/S, var/admin_called = null)
	var/full_name = "boarding/[S.boarding_map]"
	var/ship_name = S.name
	SSmapping.add_z_to_planet(S.planet, full_name)
	message_admins("Boarding event starting...")
	var/datum/round_event/ghost_role/boarding/mode = new /datum/round_event/ghost_role/boarding/
	if(prob(40) || admin_called) //TWEAKING
		if(!mode.check_role())
			message_admins("Boarding event start failed due lack of candidates.")
		else
			mode.event_setup()
	/*
	else
		bomb_the_fuck_out_of_ship()
	*/
	return 1
