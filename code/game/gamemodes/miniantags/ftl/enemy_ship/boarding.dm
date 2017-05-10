/datum/round_event/ghost_role/boarding
	minimum_required = 1 //tweaking
	var/max_allowed //tweaking
	role_name = "defender team"
	var/list/mob/dead/observer/candidates = list() //calling so we can decide is event is set or not
	var/list/mob/dead/observer/selected_list = list()
	var/list/mob/carbon/human/defenders_list = list()
	var/datum/planet/planet = null
	var/shield_down
	var/time_set
	var/timer = 720 //time before event end (7 minutes(12 minutes - 5 minutes for shields going down))
	var/docked
	var/victorious = null

/datum/round_event/ghost_role/boarding/New()
	minimum_required = 1 + round(player_list.len*0.1)
	max_allowed = 3 + round(player_list.len*0.1)
	return

/datum/round_event/ghost_role/boarding/proc/check_role()
	candidates = get_candidates("defenders", null, null)
	if(candidates.len < minimum_required)
		message_admins("No roles for boarding nerd")
		return 0
	else
		for(var/i in 1 to candidates.len)
			if(i > max_allowed) //TODO: change it to ship variable
				var/mob/dead/rejected = candidates[i]
				rejected << "Sorry, but defender team is full!"
				continue
			selected_list += candidates[i]
		return 1

/datum/round_event/ghost_role/boarding/proc/event_setup(var/crew_type=null, var/captain_type=null)
	//var/tc = selected_list.len*5
	var/priority = 1
	var/list/spawn_locs = list()
	for(var/obj/effect/landmark/L in landmarks_list)
		if(L.name == "terminal_spawn")
			spawn_locs += get_turf(L)
	if(!spawn_locs.len)
		log_debug("NO SPAWN MARKS")
		return MAP_ERROR
	var/new_loc = pick(spawn_locs)
	spawnTerminal(new_loc)
	for(var/mob/dead/selected in selected_list)
		var/mob/living/carbon/human/defender = new(new_loc)
		var/datum/preferences/A = new
		A.copy_to(defender)
		defender.dna.update_dna_identity()
		var/datum/mind/Mind = new /datum/mind(selected.key)
		Mind.assigned_role = "Defender"
		Mind.special_role = "Defender"
		ticker.mode.traitors |= Mind
		Mind.active = 1

		var/datum/objective/defence/D = new() //TODO:objectives
		D.owner = Mind
		D.mode = src
		Mind.objectives += D

		Mind.transfer_to(defender)
		manageOutfit(defender,priority,crew_type,captain_type)
		priority++

		message_admins("[defender.key] has been made into defender by an event.")
		log_game("[defender.key] was spawned as a defender by an event.")
		spawned_mobs += defender

/datum/round_event/ghost_role/boarding/proc/victory()
	for(var/mob/living/carbon/human/loser in spawned_mobs)
		loser.gib()	//TODO:text
		message_admins("[loser.key] gibbed by an event defeat conditions.")
	victorious = TRUE
	SSstarmap.mode = null
	qdel(src)

/datum/round_event/ghost_role/boarding/proc/defeat(var/zlevel)
	if(victorious)
		return 0
	for(var/obj/docking_port/stationary/D in SSstarmap.current_planet.docks)
		if(D.z != zlevel)
			continue
		planet.docks ^= D
		qdel(D)
	SSstarmap.jump_port(SSstarmap.current_planet.main_dock)
	for(var/mob/living/carbon/human/winner in spawned_mobs)
		winner.gib()	//TODO:text
	qdel(src)
	SSstarmap.mode = null
	return 1

/datum/objective/defence
	explanation_text = "Defend the ship's self-destruction protocol at all cost!"
	martyr_compatible = 1
	var/datum/round_event/ghost_role/boarding/mode

/datum/objective/defence/check_completion()
	if(mode.victorious)
		return 0
	return 1

//Restriction field - we can restrict movement of def and restirct attackers from bringing cyborgs and such
/obj/effect/defence
	name = "syndicate forcefield"
	desc = "Their shield remains strong enough to block pass. It should get down in 5 minutes."
	icon_state = "scanline"
	anchored = 1
	opacity = 0
	density = 1
	unacidable = 1
	var/istime = null
	var/timer = 300 //5 minutes

/obj/effect/defence/proc/callTime()
	istime = 1
	invisibility = INVISIBILITY_OBSERVER
	SSstarmap.mode.shield_down = TRUE

/obj/effect/defence/CanPass(atom/movable/mover, turf/target, height=0)
	if(!istime)
		return 0 //No one can't attack the ship in 5 minutes
	if(istype(mover, /obj/mecha))
		return 0 //Mechas is too stronk
	if(ismob(mover))
		var/mob/M = mover
		if(istype(M, /mob/living/silicon/robot))
			return 0 //no robots allowed
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H.mind && H.mind.special_role == "Defender")
				return 0 //Defenders can't leave the ship
	return 1
