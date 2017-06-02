//used for holding information about unique properties of maps
//feed it json files that match the datum layout
//defaults to box
//  -Cyberboss

/datum/map_config
	var/config_filename = "_maps/aetherwhisp.json"
	var/map_name = "Aetherwhisp"
	var/map_path = "map_files/Aetherwhisp"
	var/map_file = "aetherwhisp.dmm"

	var/minetype = "lavaland"

	var/list/transition_config = list(MAIN_STATION = CROSSLINKED,
									CENTCOMM = SELFLOOPING,
									EMPTY_AREA_1 = CROSSLINKED,
									EMPTY_AREA_2 = CROSSLINKED,
									MINING = SELFLOOPING,
									EMPTY_AREA_3 = CROSSLINKED,
									EMPTY_AREA_4 = CROSSLINKED,
									EMPTY_AREA_5 = CROSSLINKED,
									EMPTY_AREA_6 = CROSSLINKED,
									EMPTY_AREA_7 = CROSSLINKED,
									EMPTY_AREA_8 = CROSSLINKED)
	var/defaulted = TRUE	//if New failed

	var/ftl_ship_dir = WEST
	var/ftl_ship_dwidth = 67
	var/ftl_ship_dheight = 62
	var/ftl_ship_width = 73
	var/ftl_ship_height = 113
	var/config_max_users = 0
	var/config_min_users = 0
	var/voteweight = 1

/datum/map_config/New(filename = "data/next_map.json", default_to_box, delete_after)
	if(default_to_box)
		return
	LoadConfig(filename)
	if(delete_after)
		fdel(filename)

/datum/map_config/proc/LoadConfig(filename)
	if(!fexists(filename))
		log_world("map_config not found: [filename]")
		return

	var/json = file(filename)
	if(!json)
		log_world("Could not open map_config: [filename]")
		return
	
	json = file2text(json)
	if(!json)
		log_world("map_config is not text: [filename]")
		return
	
	json = json_decode(json)
	if(!json)
		log_world("map_config is not json: [filename]")
		return

	if(!ValidateJSON(json))
		log_world("map_config failed to validate for above reason: [filename]")
		return
	
	config_filename = filename

	map_name = json["map_name"]
	map_path = json["map_path"]
	map_file = json["map_file"]
	minetype = json["minetype"]
	
	ftl_ship_dir = text2dir(json["ftl_ship_dir"])
	ftl_ship_dwidth = text2num(json["ftl_ship_dwidth"])
	ftl_ship_dheight = text2num(json["ftl_ship_dheight"])
	ftl_ship_width = text2num(json["ftl_ship_width"])
	ftl_ship_height = text2num(json["ftl_ship_height"])

	var/list/jtcl = json["transition_config"]

	if(jtcl != "default")
		transition_config.Cut()

		for(var/I in jtcl)
			transition_config[TransitionStringToEnum(I)] = TransitionStringToEnum(jtcl[I])
		
	defaulted = FALSE

#define CHECK_EXISTS(X) if(!istext(json[X])) { log_world(X + "missing from json!"); return; }
/datum/map_config/proc/ValidateJSON(list/json)
	CHECK_EXISTS("map_name")
	CHECK_EXISTS("map_path")
	CHECK_EXISTS("map_file")
	CHECK_EXISTS("minetype")
	CHECK_EXISTS("transition_config")
	CHECK_EXISTS("ftl_ship_dir")
	CHECK_EXISTS("ftl_ship_dwidth")
	CHECK_EXISTS("ftl_ship_dheight")
	CHECK_EXISTS("ftl_ship_width")
	CHECK_EXISTS("ftl_ship_height")

	var/path = GetFullMapPath(json["map_path"], json["map_file"])
	if(!fexists(path))
		log_world("Map file ([path]) does not exist!")
		return

	if(json["transition_config"] != "default")
		if(!islist(json["transition_config"]))
			log_world("transition_config is not a list!") 
			return

		var/list/jtcl = json["transition_config"]
		for(var/I in jtcl)
			if(isnull(TransitionStringToEnum(I)))
				log_world("Invalid transition_config option: [I]!")
			if(isnull(TransitionStringToEnum(jtcl[I])))
				log_world("Invalid transition_config option: [I]!")

	return TRUE
#undef CHECK_EXISTS

/datum/map_config/proc/TransitionStringToEnum(string)
	switch(string)
		if("CROSSLINKED")
			return CROSSLINKED
		if("SELFLOOPING")
			return SELFLOOPING
		if("UNAFFECTED")
			return UNAFFECTED
		if("MAIN_STATION")
			return MAIN_STATION
		if("CENTCOMM")
			return CENTCOMM
		if("MINING")
			return MINING
		if("EMPTY_AREA_1")
			return EMPTY_AREA_1
		if("EMPTY_AREA_2")
			return EMPTY_AREA_2
		if("EMPTY_AREA_3")
			return EMPTY_AREA_3
		if("EMPTY_AREA_4")
			return EMPTY_AREA_4
		if("EMPTY_AREA_5")
			return EMPTY_AREA_5
		if("EMPTY_AREA_6")
			return EMPTY_AREA_6
		if("EMPTY_AREA_7")
			return EMPTY_AREA_7
		if("EMPTY_AREA_8")
			return EMPTY_AREA_8

/datum/map_config/proc/GetFullMapPath(mp = map_path, mf = map_file)
	return "_maps/[mp]/[mf]"

/datum/map_config/proc/MakeNextMap()
	return config_filename == "data/next_map.json" || fcopy(config_filename, "data/next_map.json")
