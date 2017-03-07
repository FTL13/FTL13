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
/datum/subsystem/starmap/proc/init_boarding(var/datum/starship/S)
  var/datum/round_event/ghost_role/boarding/mode = new /datum/ftl_boarding
  if(!mode.spawn_role())
    message_admins("Boarding event start failed due lack of candidates.")
    return 0 //No players - no event
  else
    S.current_planet.board = new(src)//is it even worth mention?
    var/full_name = "boarding/[S.boarding_map]"
    SSmapping.add_z_to_planet(S.current_planet, full_name)
    spawn(3000) //Atk can't reach zlevel for 5 minutes so Def got time to prepare
    	var/obj/docking_port/stationary/ftl_encounter/D = S.planet.main_dock
    	D.id = "ftl_z[S.current_planet.map_names.len]ftldock" //yeah blame me
    	S.current_planet.docks |= D
    	S.current_planet.name_dock(D, "board", S.name)
    mode.event_setup()
  return 1
