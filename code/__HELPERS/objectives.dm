/proc/check_ship_objectives()
	var/go_home = (world.time > 54000 || !get_ship_objective_types().len)
	for(var/datum/objective/O in get_ship_objectives())
		O.check_completion()
		if(!go_home && (O.failed || O.completed))
			generate_ship_objective(TRUE)
	if(go_home && !locate(/datum/objective/ftl/gohome) in get_ship_objectives())
		add_ship_objective(new /datum/objective/ftl/gohome)

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