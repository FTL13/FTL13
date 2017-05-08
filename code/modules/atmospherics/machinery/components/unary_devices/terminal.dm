/obj/machinery/atmospherics/components/unary/terminal
	invisibility = INVISIBILITY_ABSTRACT
	unacidable = 1
	var/obj/master
	dir = SOUTH

/obj/machinery/atmospherics/components/unary/terminal/Destroy()
	if(master == null)
		return QDEL_HINT_LETMELIVE
	return ..()

/obj/machinery/atmospherics/components/unary/terminal/singularity_pull()
	return

/obj/machinery/atmospherics/components/unary/terminal/singularity_act()
	return 0
	
/obj/machinery/atmospherics/components/unary/terminal/proc/change_dir(direction)
	dir = direction
	SetInitDirections()
	var/obj/machinery/atmospherics/node = NODE1
	if(node)
		node.disconnect(src)
		NODE1 = null
	nullifyPipenet(PARENT1)
	
	atmosinit()
	node = NODE1
	if(node)
		node.atmosinit()
		node.addMember(src)
	build_network()
	return

/obj/machinery/atmospherics/components/unary/terminal/process_atmos()
	..()
	if(master)
		master:terminal_process_atmos(src)