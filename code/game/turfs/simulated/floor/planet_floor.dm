/turf/open/floor/plating/asteroid/planet
	icon = 'icons/turf/floors/planet.dmi'
	planetary_atmos = 1
	baseturf = /turf/open/floor/plating/asteroid/planet/sand
	smooth = SMOOTH_TRUE | SMOOTH_CUSTOM
	var/edge_layer = 0
	var/edge_icon
	var/variant_amount = 4
	var/list/type_to_edgeobj = list()

/turf/open/floor/plating/asteroid/planet/New()
	..()
	icon_state = "[environment_type]_[rand(0,variant_amount-1)]"

/turf/open/floor/plating/asteroid/planet/custom_smooth()
	var/new_typelist = list()
	for(var/cdir in alldirs)
		var/turf/open/floor/plating/asteroid/planet/T = get_step(src, cdir)
		if(!istype(T))
			continue
		new_typelist[T.type] = 1
		if(!type_to_edgeobj[T.type] && T.edge_layer > edge_layer)
			var/obj/effect/planet_turf_edge/E = new(src, T.type)
			E.icon = T.edge_icon
			E.layer = (T.edge_layer/100)+TURF_LAYER
			E.color = T.color
			E.name = T.name
			E.desc = T.desc
			type_to_edgeobj += T.type
			type_to_edgeobj[T.type] = E
	
	//var/list/to_remove_list = type_to_edgeobj - new_typelist
	
	for(var/to_remove in type_to_edgeobj)
		if(new_typelist[to_remove])
			continue
		var/obj/O = type_to_edgeobj[to_remove]
		type_to_edgeobj[to_remove] = null
		type_to_edgeobj -= to_remove
		qdel(O)

/turf/open/floor/plating/asteroid/planet/sand
	name = "sand"
	environment_type = "sand"
	icon_state = "sand_0"
	edge_layer = 0

/turf/open/floor/plating/asteroid/planet/grass
	name = "grass"
	environment_type = "grass"
	icon_state = "grass_0"
	edge_layer = 1
	edge_icon = 'icons/turf/floors/planet/grass_edge.dmi'

/turf/open/floor/plating/asteroid/planet/snow
	name = "snow"
	baseturf = /turf/open/floor/plating/asteroid/planet/grass
	environment_type = "snow"
	icon_state = "snow_0"
	edge_layer = 2
	edge_icon = 'icons/turf/floors/planet/snow_edge.dmi'
	variant_amount = 1
/turf/open/floor/plating/asteroid/planet/water
	name = "water"
	environment_type = "water"
	icon_state = "water_0"
	edge_layer = 50
	edge_icon = 'icons/turf/floors/planet/water_edge.dmi'
	variant_amount = 1

/obj/effect/planet_turf_edge
	var/parent_edge_type
	smooth = SMOOTH_TRUE | SMOOTH_CUSTOM
	anchored = 1
	unacidable = 1

/obj/effect/planet_turf_edge/New(var/turf/T, e_t)
	parent_edge_type = e_t
	canSmoothWith = list(e_t)
	..(T)
	return 1

/obj/effect/planet_turf_edge/custom_smooth(adjacencies)
	var/atom/movable/AM
	for(var/direction in list(5,6,9,10))
		AM = find_type_in_direction(src, direction)
		if(AM == NULLTURF_BORDER)
			if((smooth & SMOOTH_BORDER))
				adjacencies |= 1 << direction
		else if((AM && !istype(AM)) || (istype(AM) && AM.anchored) )
			adjacencies |= 1 << direction
	var/dirs = 0
	if(adjacencies & N_NORTH)
		dirs |= NORTH
		adjacencies &= ~(N_NORTHEAST|N_NORTHWEST|N_NORTH)
	if(adjacencies & N_SOUTH)
		dirs |= SOUTH
		adjacencies &= ~(N_SOUTHEAST|N_SOUTHWEST|N_SOUTH)
	if(adjacencies & N_EAST)
		dirs |= EAST
		adjacencies &= ~(N_NORTHEAST|N_SOUTHEAST|N_EAST)
	if(adjacencies & N_WEST)
		dirs |= WEST
		adjacencies &= ~(N_NORTHWEST|N_SOUTHWEST|N_WEST)
	icon_state = "e_[dirs]"
	var/list/new_overlays = list()
	if(adjacencies & N_NORTHWEST)
		new_overlays += "c_1"
	if(adjacencies & N_NORTHEAST)
		new_overlays += "c_2"
	if(adjacencies & N_SOUTHWEST)
		new_overlays += "c_3"
	if(adjacencies & N_SOUTHEAST)
		new_overlays += "c_4"
	overlays = new_overlays