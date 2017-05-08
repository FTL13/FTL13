/turf/open/space/transit
	icon_state = "mapping_speedspace"
	dir = SOUTH
	baseturf = /turf/open/space/transit
<<<<<<< HEAD
	flags = NOJAUNT //This line goes out to every wizard that ever managed to escape the den. I'm sorry.

/turf/open/space/transit/south
	dir = SOUTH

/turf/open/space/transit/north
	dir = NORTH
=======
	no_shuttle_move = 1
	var/noop = 0

/turf/open/space/transit/reverse
	dir = NORTH
	baseturf = /turf/open/space/transit/reverse
>>>>>>> master

/turf/open/space/transit/horizontal
	dir = WEST
	baseturf = /turf/open/space/transit/horizontal

/turf/open/space/transit/horizontal/reverse
	dir = EAST
	baseturf = /turf/open/space/transit/horizontal/reverse

/turf/open/space/transit/noop
	noop = 1
	baseturf = /turf/open/space/transit/noop

/turf/open/space/transit/horizontal/noop
	noop = 1
	baseturf = /turf/open/space/transit/horizontal/noop

/turf/open/space/transit/west
	dir = WEST

/turf/open/space/transit/east
	dir = EAST

/turf/open/space/transit/Entered(atom/movable/AM, atom/OldLoc)
<<<<<<< HEAD
	throw_atom(AM)

/turf/open/space/transit/proc/throw_atom(atom/movable/AM)
	if(!AM || istype(AM, /obj/docking_port))
=======
	if(noop || !AM)
>>>>>>> master
		return
	var/max = world.maxx-TRANSITIONEDGE
	var/min = 1+TRANSITIONEDGE

	var/list/possible_transtitons = list()
	var/k = 1
	var/list/config_list = SSmapping.config.transition_config
	for(var/a in config_list)
		if(config_list[a] == CROSSLINKED) // Only pick z-levels connected to station space
			possible_transtitons += k
		k++
	if(possible_transtitons.len == 0)
		possible_transtitons += 1
	var/_z = pick(possible_transtitons)

	//now select coordinates for a border turf
	var/_x
	var/_y
	switch(dir)
		if(SOUTH)
			_x = rand(min,max)
			_y = max
		if(WEST)
			_x = max
			_y = rand(min,max)
		if(EAST)
			_x = min
			_y = rand(min,max)
		else
			_x = rand(min,max)
			_y = min

	var/turf/T = locate(_x, _y, _z)
	AM.loc = T
	AM.newtonian_move(dir)

/turf/open/space/transit/CanBuildHere()
	return istype(get_area(src), /area/shuttle)

<<<<<<< HEAD
/turf/open/space/transit/Initialize()
	..()
	update_icon()
	for(var/atom/movable/AM in src)
		throw_atom(AM)
=======


//Overwrite because we dont want people building rods in space.
/turf/open/space/transit/attackby()
	if(noop)
		..() // Allow noop turfs to have shit built on them though.
	else
		return

/turf/open/space/transit/New()
	..()
	update_icon()
>>>>>>> master

/turf/open/space/transit/proc/update_icon()
	var/p = 9
	var/angle = 0
	var/state = 1
	switch(dir)
		if(NORTH)
			angle = 180
			state = ((-p*x+y) % 15) + 1
			if(state < 1)
				state += 15
		if(EAST)
			angle = 90
			state = ((x+p*y) % 15) + 1
		if(WEST)
			angle = -90
			state = ((x-p*y) % 15) + 1
			if(state < 1)
				state += 15
		else
			state =	((p*x+y) % 15) + 1

	icon_state = "speedspace_ns_[state]"
	transform = turn(matrix(), angle)