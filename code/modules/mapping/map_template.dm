/datum/map_template
	var/name = "Default Template Name"
	var/width = 0
	var/height = 0
	var/mappath = null
	var/loaded = 0 // Times loaded this round

/datum/map_template/New(path = null, rename = null)
	if(path)
		mappath = path
	if(mappath)
		preload_size(mappath)
	if(rename)
		name = rename

/datum/map_template/proc/preload_size(path)
	var/bounds = GLOB.maploader.load_map(file(path), 1, 1, 1, cropMap=FALSE, measureOnly=TRUE)
	if(bounds)
		width = bounds[MAP_MAXX] // Assumes all templates are rectangular, have a single Z level, and begin at 1,1,1
		height = bounds[MAP_MAXY]
	return bounds

/datum/map_template/proc/load_new_z()
	var/x = round(world.maxx/2)
	var/y = round(world.maxy/2)

	var/list/bounds = GLOB.maploader.load_map(file(mappath), x, y)
	if(!bounds)
		return FALSE

	smooth_zlevel(world.maxz)
	repopulate_sorted_areas()

<<<<<<< HEAD
=======
	SSlighting.initialize_lighting_objects(block(locate(bounds[MAP_MINX], bounds[MAP_MINY], bounds[MAP_MINZ]),locate(bounds[MAP_MAXX], bounds[MAP_MAXY], bounds[MAP_MAXZ])))
	//initialize things that are normally initialized after map load
	initTemplateBounds(bounds)
>>>>>>> 4ca78a7... Merge pull request #31336 from AnturK/Fixes-lighting-on-away-missions
	log_game("Z-level [name] loaded at at [x],[y],[world.maxz]")

/datum/map_template/proc/load(turf/T, centered = FALSE)
	if(centered)
		T = locate(T.x - round(width/2) , T.y - round(height/2) , T.z)
	if(!T)
		return
	if(T.x+width > world.maxx)
		return
	if(T.y+height > world.maxy)
		return

	var/list/bounds = GLOB.maploader.load_map(file(mappath), T.x, T.y, T.z, cropMap=TRUE)
	if(!bounds)
		return

	if(!SSmapping.loading_ruins) //Will be done manually during mapping ss init
		repopulate_sorted_areas()
	

	log_game("[name] loaded at at [T.x],[T.y],[T.z]")
	return TRUE

/datum/map_template/proc/get_affected_turfs(turf/T, centered = FALSE)
	var/turf/placement = T
	if(centered)
		var/turf/corner = locate(placement.x - round(width/2), placement.y - round(height/2), placement.z)
		if(corner)
			placement = corner
	return block(placement, locate(placement.x+width-1, placement.y+height-1, placement.z))


//for your ever biggening badminnery kevinz000
//❤ - Cyberboss
/proc/load_new_z_level(var/file, var/name)
	var/datum/map_template/template = new(file, name)
	template.load_new_z()