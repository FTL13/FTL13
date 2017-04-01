/*
AI
*/
/datum/job/ai
	title = "AI"
	flag = AI
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 0 // Not used for AI, see is_position_available below and modules/mob/living/silicon/ai/latejoin.dm
	spawn_positions = 1
	selection_color = "#ccffcc"
	supervisors = "your laws"
	req_admin_notify = 1
	minimal_player_age = 30
	exp_type = EXP_TYPE_CREW

/datum/job/ai/equip(mob/living/carbon/human/H)
	if(!H)
		return 0

/datum/job/ai/is_position_available()
	return (empty_playable_ai_cores.len != 0)

/datum/job/ai/config_check()
	if(config && config.allow_ai)
		return 1
	return 0

/*
Cyborg
*/
/datum/job/cyborg
	title = "Cyborg"
	flag = CYBORG
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 0
	spawn_positions = 1
	supervisors = "your laws and the AI"	//Nodrak
	selection_color = "#ddffdd"
	minimal_player_age = 21
	exp_type = EXP_TYPE_CREW

/datum/job/cyborg/equip(mob/living/carbon/human/H)
	if(!H)
		return 0
	return H.Robotize()
