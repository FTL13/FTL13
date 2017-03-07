/datum/round_event/ghost_role/boarding
	minimum_required = 1 //tweaking
	role_name = "defender team"
  var/list/mob/dead/observer/candidates //calling so we can decide is event is set or not

/datum/round_event/ghost_role/boarding/spawn_role()
	candidates = get_candidates("defenders", null, ROLE_OPERATIVE)
	if(candidates.len < minimum_required)
		return 0

/datum/round_event/ghost_role/boarding/proc/event_setup()
	var/list/spawn_locs = list()
	for(var/obj/effect/landmark/L in landmarks_list)
		if(L.name in list("defender_spawn"))
			spawn_locs += L.loc
	if(!spawn_locs.len)
		return MAP_ERROR

	var/mob/living/carbon/human/defender = new(pick(spawn_locs))
	var/datum/preferences/A = new
	A.copy_to(defender)
	defender.dna.update_dna_identity()

  manageOutfit(defender)


	var/datum/mind/Mind = new /datum/mind(selected.key)
	Mind.assigned_role = "Defender"
	Mind.special_role = "Defender"
	ticker.mode.traitors |= Mind
	Mind.active = 1

  if(spawnTerminal())
		var/datum/objective/defence/D = new()
		D.owner = Mind
		Mind.objectives += D

	Mind.transfer_to(defender)

	message_admins("[defender.key] has been made into lone operative by an event.")
	log_game("[defender.key] was spawned as a lone operative by an event.")
	spawned_mobs += defender
	return SUCCESSFUL_SPAWN
