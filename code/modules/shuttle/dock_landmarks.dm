//Eventualy these should create the docking port in initialize but for now that requires too much work

/obj/effect/landmark/dock_spawn
	dir = WEST
	var/turf_type = /turf/open/space
	var/baseturf_type = /turf/open/space
	var/area_type = /area/space
	var/allowed_shuttles = 0
	var/keep_hidden = TRUE
	var/distance = 0 // Calculates time based on the difference the two ports distances.-25 = boarding, 0 = space, 25 = station and 100 = planetside
	var/use_dock_distance = TRUE
	var/ftl_ship_main_dock = FALSE
	var/addon_name = "" //used for things like BOARDING (north)
	var/use_planet_surface = FALSE
	var/dock_type = /obj/docking_port/stationary/fob

/obj/effect/landmark/dock_spawn/proc/load_dock(var/z_level, var/datum/planet/PL, var/params=null)
	var/docking_port_id = "ftl_z[z][copytext(name, 8)]"
	var/obj/docking_port/stationary/fob/D = new dock_type(loc)
	D.encounter_type = copytext(name, 9)
	D.id = docking_port_id + "_[z]_[allowed_shuttles]_[addon_name]" //mostly unique dock names
	if(use_planet_surface)
		D.baseturf_type = PL.surface_turf_type
		D.turf_type = PL.surface_turf_type
	else
		D.baseturf_type = baseturf_type
		D.turf_type = turf_type
	D.area_type = area_type
	D.dir = dir
	D.dock_distance = distance
	D.use_dock_distance = use_dock_distance
	D.dock_do_not_show = keep_hidden
	D.allowed_shuttles = allowed_shuttles
	D.current_planet = PL
	PL.docks |= D
	PL.name_dock(D, D.encounter_type, params)
	if(addon_name)
		D.name +=(" ([addon_name])")


/obj/effect/landmark/dock_spawn/station
	name = "ftldock_trade"
	allowed_shuttles = ALL_FOB
	keep_hidden = FALSE
	distance = 25

/obj/effect/landmark/dock_spawn/station/internal
	turf_type = /turf/open/floor/engine
	baseturf_type = /turf/open/floor/engine
	area_type = /area/no_entry

/obj/effect/landmark/dock_spawn/station/internal/cargo
	allowed_shuttles = ALL_CARGO
	dock_type = /obj/docking_port/stationary/fob/fob_dock/cargo

/obj/effect/landmark/dock_spawn/main
	name = "ftldock_main"
	allowed_shuttles = ALL_SHUTTLES
	keep_hidden = FALSE
	distance = 25

/obj/effect/landmark/dock_spawn/land
	name = "ftldock_land"
	allowed_shuttles = ALL_SHUTTLES //Cargo shuttles are denied later with flavortext
	keep_hidden = FALSE
	distance = 100
	use_planet_surface = TRUE

/obj/effect/landmark/dock_spawn/land/load_dock(z_level, PL, params)
	. = ..()


/obj/effect/landmark/dock_spawn/board
	name = "ftldock_board"
	allowed_shuttles = ALL_SHUTTLES
	keep_hidden = FALSE
	distance = -25
	dir = 8