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

/obj/machinery/atmospherics/components/unary/terminal/process_atmos()
	..()
	if(master)
		master:terminal_process_atmos(src)