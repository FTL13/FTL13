/datum/mapGeneratorModule/bottomLayer/repairFloorPlasteel
	spawnableTurfs = list(/turf/open/floor/plasteel = 100)
	var/ignore_wall = FALSE

/datum/mapGeneratorModule/bottomLayer/repairFloorPlasteel/place(turf/T)
	if(isclosedturf(T))
		return FALSE
	return TRUE

/datum/mapGeneratorModule/bottomLayer/repairFloorPlasteel/flatten
	ignore_wall = TRUE

/datum/mapGeneratorModule/border/normalWalls
	spawnableAtoms = list()
	spawnableTurfs = list(/turf/closed/wall = 100)

/datum/mapGenerator/repair
	modules = list(/datum/mapGeneratorModule/bottomLayer/repairFloorPlasteel,
	/datum/mapGeneratorModule/bottomLayer/repressurize)
	buildmode_name = "Repair: Floor"

/datum/mapGenerator/repair/delete_walls
	modules = list(/datum/mapGeneratorModule/bottomLayer/repairFloorPlasteel/flatten,
	/datum/mapGeneratorModule/bottomLayer/repressurize)
	buildmode_name = "Repair: Floor: Flatten Walls"

/datum/mapGenerator/repair/enclose_room
	modules = list(/datum/mapGeneratorModule/bottomLayer/repairFloorPlasteel/flatten,
	/datum/mapGeneratorModule/border/normalWalls,
	/datum/mapGeneratorModule/bottomLayer/repressurize)
	buildmode_name = "Repair: Generate Aired Room"

/datum/mapGenerator/repair/reload_station_map
	modules = list(/datum/mapGeneratorModule/bottomLayer/massdelete/no_delete_mobs)
	var/x_low = 0
	var/x_high = 0
	var/y_low = 0
	var/y_high = 0
	var/z = 0
	var/cleanload = FALSE
	var/datum/mapGeneratorModule/reload_station_map/loader
	buildmode_name = "Repair: Reload Block \[DO NOT USE\]"

/datum/mapGenerator/repair/reload_station_map/clean
	buildmode_name = "Repair: Reload Block - Mass Delete"
	cleanload = TRUE

/datum/mapGenerator/repair/reload_station_map/clean/in_place
	modules = list(/datum/mapGeneratorModule/bottomLayer/massdelete/regeneration_delete)
	buildmode_name = "Repair: Reload Block - Mass Delete - In Place"

/datum/mapGenerator/repair/reload_station_map/defineRegion(turf/start, turf/end)
	. = ..()
	if(start.z != ZLEVEL_STATION || end.z != ZLEVEL_STATION)
		return
	x_low = min(start.x, end.x)
	y_low = min(start.y, end.y)
	x_high = max(start.x, end.x)
	y_high = max(start.y, end.y)
	z = ZLEVEL_STATION

GLOBAL_VAR_INIT(reloading_map, FALSE)

/datum/mapGenerator/repair/reload_station_map/generate(clean = cleanload)
	if(!loader)
		loader = new
	if(cleanload)
		..()			//Trigger mass deletion.
	modules |= loader
	syncModules()
	loader.generate()
