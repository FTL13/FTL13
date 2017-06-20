/obj/machinery/atmospherics/pipe/containment/simple
	name = "Fusion Plasma Containment Pipe"
	desc = "A pipe with coiling to shape a magnetic field."
	icon_state = "intact"
	
	dir = SOUTH
	initialize_directions = SOUTH|NORTH
	
	device_type = BINARY
	
/obj/machinery/atmospherics/pipe/containment/simple/SetInitDirections()
	if(dir in diagonals)
		initialize_directions = dir
	switch(dir)
		if(NORTH,SOUTH)
			initialize_directions = SOUTH|NORTH
		if(EAST,WEST)
			initialize_directions = WEST|EAST
			
/obj/machinery/atmospherics/pipe/containment/simple/proc/normalize_dir()
	if(dir==SOUTH)
		setDir(NORTH)
	else if(dir==WEST)
		setDir(EAST)
		
/obj/machinery/atmospherics/pipe/containment/simple/atmosinit()
	normalize_dir()
	..()
	
/obj/machinery/atmospherics/pipe/containment/simple/update_icon()
	normalize_dir()
	..()