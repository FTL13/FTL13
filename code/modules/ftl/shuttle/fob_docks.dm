/obj/docking_port/mobile/fob
	name = "FTL FOB"
	id = "fob"
	callTime = 650
	default_call_time = 650
	preferred_direction = EAST
	area_type = /area/shuttle/ftl/cargo/mining
	var/previous_dock
	var/max_distance = 101 //Defines the max distance the shuttle can go to.
	var/unload_marker = "FOB SHUTTLE"

/obj/docking_port/mobile/fob/Initialize(mapload)
	dir = SSmapping.config.fob_shuttle_dir
	dwidth = SSmapping.config.fob_shuttle_dwidth
	dheight = SSmapping.config.fob_shuttle_dheight
	width = SSmapping.config.fob_shuttle_width
	height = SSmapping.config.fob_shuttle_height
	. = ..()

/obj/docking_port/mobile/fob/cargo
	name = "FTL Cargo"
	id = "cargo"
	callTime = 400
	default_call_time = 400
	area_type = /area/shuttle/ftl/cargo/shuttle
	max_distance = 50 //Cannot land on planets
	unload_marker = "CARGO SHUTTLE"

/obj/docking_port/mobile/fob/cargo/Initialize(mapload)
	. = ..()
	dir = SSmapping.config.cargo_shuttle_dir
	dwidth = SSmapping.config.cargo_shuttle_dwidth
	dheight = SSmapping.config.cargo_shuttle_dheight
	width = SSmapping.config.cargo_shuttle_width
	height = SSmapping.config.cargo_shuttle_height

/obj/docking_port/stationary/fob
	var/encounter_type = ""
	var/datum/planet/current_planet

/obj/docking_port/stationary/fob/Initialize()
	dir = SSmapping.config.fob_shuttle_dir
	dwidth = SSmapping.config.fob_shuttle_dwidth
	dheight = SSmapping.config.fob_shuttle_dheight
	width = SSmapping.config.fob_shuttle_width
	height = SSmapping.config.fob_shuttle_height
	. = ..()

/obj/docking_port/stationary/fob/fob_dock //The dock at the main ship
	name = "FOB Dock"
	id = "fob_dock"
	area_type = /area/shuttle/ftl/space

	allowed_shuttles = ALL_FOB //Only one of these will exist anyway
	dock_do_not_show = FALSE
	use_dock_distance = TRUE

/obj/docking_port/stationary/fob/fob_dock/cargo
	name = "Cargo Dock"
	id = "cargo_dock"

	allowed_shuttles = ALL_CARGO

/obj/docking_port/stationary/fob/fob_dock/cargo/Initialize()
	dir = SSmapping.config.cargo_shuttle_dir
	dwidth = SSmapping.config.cargo_shuttle_dwidth
	dheight = SSmapping.config.cargo_shuttle_dheight
	width = SSmapping.config.cargo_shuttle_width
	height = SSmapping.config.cargo_shuttle_height
	. = ..()

/obj/docking_port/stationary/fob/fob_land
	name = "FOB Landing Zone"
	id = "fob_land"
	area_type = /area/lavaland/surface/outdoors/unexplored
	planet_dock = TRUE
	encounter_type = "land"

	allowed_shuttles = ALL_FOB
	dock_do_not_show = FALSE
	use_dock_distance = TRUE
	dock_distance = 100

/obj/machinery/computer/shuttle/fob
	name = "FOB shuttle console"
	desc = "Used to call and send the FOB shuttle."
	shuttleId = "fob"
	possible_destinations = "fob_dock;fob_land"
	no_destination_swap = 1
	can_move_if_ship_moving = FALSE
