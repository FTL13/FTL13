/obj/docking_port/mobile/ftl //Soon I will delet this file
	name = "FTL Ship"
	id = "ftl"
	callTime = 650
	preferred_direction = EAST
	roundstart_move = FALSE //SHIP DELET
	area_type = /area/shuttle/ftl

/obj/docking_port/mobile/ftl/New()
	. = ..()
	dir = SSmapping.config.ftl_ship_dir
	dwidth = SSmapping.config.ftl_ship_dwidth
	dheight = SSmapping.config.ftl_ship_dheight
	width = SSmapping.config.ftl_ship_width
	height = SSmapping.config.ftl_ship_height

/obj/docking_port/mobile/ftl/register()
	. = ..()
	SSshuttle.ftl = src

/obj/docking_port/mobile/ftl/check()
	if(mode == SHUTTLE_TRANSIT) //SSstarmap handles the SHUTTLE_TRANSIT stage of the main ship
		return
	. = ..()

/obj/docking_port/mobile/ftl/timeLeft()
	return 0

/obj/docking_port/stationary/ftl_encounter
	name = "FTL Encounter"
	var/encounter_type = ""
	area_type = /area/shuttle/ftl/space

/obj/docking_port/stationary/ftl_encounter/New()
	. = ..()
	dir = SSmapping.config.fob_shuttle_dir
	dwidth = SSmapping.config.fob_shuttle_dwidth
	dheight = SSmapping.config.fob_shuttle_dheight
	width = SSmapping.config.fob_shuttle_width
	height = SSmapping.config.fob_shuttle_height
