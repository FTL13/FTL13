//Eventualy these should create the docking port in initialize but for now that requires too much work

/obj/effect/landmark/dock_spawn
	var/turf_type = /turf/open/space
	var/baseturf_type = /turf/open/space
	var/area_type = /area/space
	var/allowed_shuttles = 0
	var/keep_hidden = TRUE
	var/distance = 0 // Calculates time based on the difference the two ports distances.-25 = boarding, 0 = space, 25 = station and 100 = planetside
	var/use_dock_distance = TRUE
	var/ftl_ship_main_dock = FALSE

/obj/effect/landmark/dock_spawn/station
	name = "ftldock_trade"
	allowed_shuttles = AER_CARGO + SCARAB_CARGO + AER_FOB + SCARAB_FOB
	keep_hidden = FALSE
	distance = 25

/obj/effect/landmark/dock_spawn/main //unneded?
	name = "ftldock_main"
	ftl_ship_main_dock = TRUE

/obj/effect/landmark/dock_spawn/land
	name = "ftldock_land"
	allowed_shuttles = AER_FOB + SCARAB_FOB
	keep_hidden = FALSE
	distance = 100

/obj/effect/landmark/dock_spawn/board
	name = "ftldock_board"
	allowed_shuttles = AER_FOB + SCARAB_FOB
	keep_hidden = FALSE
	distance = -25
