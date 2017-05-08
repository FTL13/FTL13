<<<<<<< HEAD
/datum/game_mode/devil
	name = "devil"
	config_tag = "devil"
	antag_flag = ROLE_DEVIL
	protected_jobs = list("Lawyer", "Curator", "Chaplain", "Head of Security", "Captain", "AI")
	required_players = 0
	required_enemies = 1
	recommended_enemies = 4
	reroll_friendly = 1
	enemy_minimum_age = 0

	var/traitors_possible = 4 //hard limit on devils if scaling is turned off
	var/num_modifier = 0 // Used for gamemodes, that are a child of traitor, that need more than the usual.
	var/objective_count = 2
	var/minimum_devils = 1
=======
/datum/game_mode
	var/list/datum/mind/sintouched = list()
	var/list/datum/mind/devils = list()
	var/devil_ascended = 0 // Number of arch devils on station

/datum/game_mode/proc/auto_declare_completion_sintouched()
	var/text = ""
	if(sintouched.len)
		text += "<br><span class='big'><b>The sintouched were:</b></span>"
		var/list/sintouchedUnique = uniqueList(sintouched)
		for(var/S in sintouchedUnique)
			var/datum/mind/sintouched_mind = S
			text += printplayer(sintouched_mind)
			text += printobjectives(sintouched_mind)
		text += "<br>"
	text += "<br>"
	to_chat(world, text)

/datum/game_mode/proc/auto_declare_completion_devils()
	/var/text = ""
	if(devils.len)
		text += "<br><span class='big'><b>The devils were:</b></span>"
		for(var/D in devils)
			var/datum/mind/devil = D
			text += printplayer(devil)
			text += printdevilinfo(devil)
			text += printobjectives(devil)
		text += "<br>"
	to_chat(world, text)
>>>>>>> master

	announce_text = "There are devils onboard the station!\n\
		+	<span class='danger'>Devils</span>: Purchase souls and tempt the crew to sin!\n\
		+	<span class='notice'>Crew</span>: Resist the lure of sin and remain pure!"

/datum/game_mode/devil/pre_setup()

<<<<<<< HEAD
	if(config.protect_roles_from_antagonist)
		restricted_jobs += protected_jobs
	if(config.protect_assistant_from_antagonist)
		restricted_jobs += "Assistant"

	var/num_devils = 1
=======
/datum/game_mode/proc/finalize_devil(datum/mind/devil_mind)
	var/mob/living/carbon/human/S = devil_mind.current
	var/trueName= randomDevilName()
	var/datum/objective/devil/soulquantity/soulquant = new
	soulquant.owner = devil_mind
	var/datum/objective/devil/obj_2 = pick(new /datum/objective/devil/soulquality(null), new /datum/objective/devil/sintouch(null))
	obj_2.owner = devil_mind
	devil_mind.objectives += obj_2
	devil_mind.objectives += soulquant
	devil_mind.devilinfo = devilInfo(trueName, 1)
	devil_mind.store_memory("Your devilic true name is [devil_mind.devilinfo.truename]<br>[lawlorify[LAW][devil_mind.devilinfo.ban]]<br>You may not use violence to coerce someone into selling their soul.<br>You may not directly and knowingly physically harm a devil, other than yourself.<br>[lawlorify[LAW][devil_mind.devilinfo.bane]]<br>[lawlorify[LAW][devil_mind.devilinfo.obligation]]<br>[lawlorify[LAW][devil_mind.devilinfo.banish]]<br>")
	devil_mind.devilinfo.owner = devil_mind
	devil_mind.devilinfo.give_base_spells(1)
	spawn(10)
		devil_mind.devilinfo.update_hud()
		if(devil_mind.assigned_role == "Clown")
			to_chat(S, "<span class='notice'>Your infernal nature has allowed you to overcome your clownishness.</span>")
			S.dna.remove_mutation(CLOWNMUT)

/datum/mind/proc/announceDevilLaws()
	if(!devilinfo)
		return
	to_chat(current, "<span class='warning'><b>You remember your link to the infernal.  You are [src.devilinfo.truename], an agent of hell, a devil.  And you were sent to the plane of creation for a reason.  A greater purpose.  Convince the crew to sin, and embroiden Hell's grasp.</b></span>")
	to_chat(current, "<span class='warning'><b>However, your infernal form is not without weaknesses.</b></span>")
	to_chat(current, "You may not use violence to coerce someone into selling their soul.")
	to_chat(current, "You may not directly and knowingly physically harm a devil, other than yourself.")
	to_chat(current, lawlorify[LAW][src.devilinfo.bane])
	to_chat(current, lawlorify[LAW][src.devilinfo.ban])
	to_chat(current, lawlorify[LAW][src.devilinfo.obligation])
	to_chat(current, lawlorify[LAW][src.devilinfo.banish])
	to_chat(current, "<br/><br/><span class='warning'>Remember, the crew can research your weaknesses if they find out your devil name.</span><br>")
	var/obj_count = 1
	to_chat(current, "<span class='notice'>Your current objectives:</span>")
	for(var/O in objectives)
		var/datum/objective/objective = O
		to_chat(current, "<B>Objective #[obj_count]</B>: [objective.explanation_text]")
		obj_count++
>>>>>>> master

	if(config.traitor_scaling_coeff)
		num_devils = max(minimum_devils, min( round(num_players()/(config.traitor_scaling_coeff*3))+ 2 + num_modifier, round(num_players()/(config.traitor_scaling_coeff*1.5)) + num_modifier ))
	else
		num_devils = max(minimum_devils, min(num_players(), traitors_possible))

	for(var/j = 0, j < num_devils, j++)
		if (!antag_candidates.len)
			break
		var/datum/mind/devil = pick(antag_candidates)
		devils += devil
		devil.special_role = traitor_name
		devil.restricted_roles = restricted_jobs

		log_game("[devil.key] (ckey) has been selected as a [traitor_name]")
		antag_candidates.Remove(devil)

	if(devils.len < required_enemies)
		return 0
	return 1


/datum/game_mode/devil/post_setup()
	for(var/datum/mind/devil in devils)
		post_setup_finalize(devil)
	modePlayer += devils
	..()
	return 1

/datum/game_mode/devil/proc/post_setup_finalize(datum/mind/devil)
	set waitfor = FALSE
	sleep(rand(10,100))
	finalize_devil(devil, TRUE)
	sleep(100)
	add_devil_objectives(devil, objective_count) //This has to be in a separate loop, as we need devil names to be generated before we give objectives in devil agent.
	devil.announceDevilLaws()
	devil.announce_objectives()