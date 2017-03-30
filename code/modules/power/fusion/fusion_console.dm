/obj/machinery/computer/fusion_console
	name = "Reaction Control Console"
	desc = "Legend says if a non-engineer touches this they'll be found in maintenence with toolbox shaped bruises and memory loss"
	
	//circuit = /obj/item/weapon/circuitboard/computer/fusion_console
	
	var/obj/machinery/list/electromagnet = list() //Linked electromagnet(s)
	var/obj/machinery/containment_pipe/list/injector = list() //Linked injector(s)
	
/obj/machinery/computer/fusion_console/New()
	..()

/*	
/obj/machinery/computer/fusion_console/attackby(obj/item/weapon/I, mob/user, params)
	if(istype(I, /obj/item/device/multitool)) //Add injectors or electromagnet to the list of managed devices via multitool
		var/obj/item/device/multitool/M = I
		if(M.buffer && istype(m.buffer, /obj/machinery/atmospherics/pipe/containment_pipe/injector))
			injector.add(M.buffer)
		else if(M.buffer && istype(m.buffer, /obj/machinery/electromagnet))
			electromagnet.add(M.buffer)
		M.buffer = null
		user << "<span class='caution'>You upload the data from the [W.name]'s buffer.</span>"
		
	else
		return ..()
*/