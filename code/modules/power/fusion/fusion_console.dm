/obj/machinery/computer/fusion_console
	name = "Reaction Control Console"
	desc = "Legend says if a non-engineer touches this they'll be found in maintenence with toolbox shaped bruises and memory loss"
	
	circuit = /obj/item/weapon/circuitboard/computer/fusion_console
	
	var/list/control //Linked electromagnet(s)
	var/list/input //Linked injector(s)
	
/obj/machinery/computer/fusion_console/New()
	..()

/obj/machinery/computer/fusion_console/attackby(obj/item/weapon/I, mob/user, params)
	if(istype(I, /obj/item/device/multitool)) //Add injectors or electromagnet to the list of managed devices via multitool
		var/obj/item/device/multitool/M = I
		if(M.buffer && istype(M.buffer, /obj/machinery/injector))
			input += M.buffer
		else if(M.buffer && istype(M.buffer, /obj/machinery/electromagnet))
			control += M.buffer
		M.buffer = null
		usr << "<span class='caution'>You upload the data from the [M.name]'s buffer.</span>"
		
	else
		return ..()