/proc/check_ship_objectives()
	var/go_home = FALSE
	var/completed_objectives = 0
	if(world.time > 54000 || !get_ship_objective_types_len())
		go_home = TRUE
	for(var/datum/objective/O in get_ship_objectives())
		if(O.failed || O.completed) //Already finished
			completed_objectives++
			continue
		O.completed = O.check_completion()
		if((O.failed || O.completed)) //NOW we're finished, time to generate an objective!
			completed_objectives++
			priority_announce("Ship objective [O.completed?"completed":"failed"].", null, null)
			generate_ship_objective(TRUE)
	if(go_home && completed_objectives >= config.mandatory_objectives && !locate(/datum/objective/ftl/gohome) in get_ship_objectives())
		priority_announce("Mandatory expedition time exceeded. Feel free to come home if you so wish.", null, null)
		add_ship_objective(new /datum/objective/ftl/gohome, TRUE)

/proc/generate_ship_objective(var/announce = FALSE)
	var/list/objective_types = get_ship_objective_types()
	var/objectivetype = pickweight(objective_types)
	objective_types[objectivetype]--
	if(objective_types[objectivetype] <= 0)
		objective_types -= objectivetype
	add_ship_objective(new objectivetype, announce)


/proc/add_ship_objective(var/datum/objective/O, var/announce = FALSE)
	ASSERT(istype(O))
	if(O.find_target())
		SSstarmap.ship_objectives += O
		if(announce)
			priority_announce("Ship objectives updated. Please check a communications console for details.", null, null)
	else
		qdel(O)

/proc/get_ship_objectives()
	return SSstarmap.ship_objectives

/proc/get_ship_objective_types()
	return SSstarmap.objective_types

/proc/get_ship_objective_types_len()
	return SSstarmap.objective_types.len