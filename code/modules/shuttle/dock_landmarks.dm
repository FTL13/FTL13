//Eventualy these should create the docking port in initialize but for now that requires too much work

/obj/effect/landmark/dock_spawn
	var/turf_type = /turf/open/space
	var/baseturf_type = /turf/open/space
	var/area_type = /area/space

/obj/effect/landmark/dock_spawn/station
	name = "ftldock_trade"

/obj/effect/landmark/dock_spawn/main
	name = "ftldock_main"

/obj/effect/landmark/dock_spawn/land
	name = "ftldock_land"

/obj/effect/landmark/dock_spawn/board
	name = "ftldock_board"