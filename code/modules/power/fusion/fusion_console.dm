/obj/machinery/computer/fusion_console
	name = "Reaction Control Console"
	desc = "Legend says if a non-engineer touches this they'll be found in maintenence with toolbox shaped bruises and memory loss"
	
	circuit = /obj/item/weapon/circuitboard/computer/fusion_console
	
	var/obj/item/device/radio/radio
	
	var/list/control //Linked electromagnet(s)
	var/list/input //Linked injector(s)
	var/list/pipes //Linked pipes
	var/linked = 0
	
/obj/machinery/computer/fusion_console/New()
	..()
	radio = new(src)
	radio.listening = 0
	
/obj/machinery/computer/fusion_console/deconstruction()
	unlink()
	..()

/obj/machinery/computer/fusion_console/attackby(obj/item/weapon/I, mob/user, params)
	if(istype(I, /obj/item/device/multitool)) //Add injectors or electromagnet to the list of managed devices via multitool
		structure_link(I)
		usr << "<span class='caution'>You upload the data from the [I.name]'s buffer.</span>"
	..()
		
/obj/machinery/computer/fusion_console/proc/structure_link(var/obj/item/device/multitool/I) //Recursive loops yay
	var/obj/item/device/multitool/M = I
	var/list/unscanned_devices
	var/list/discovery
	if(M.buffer && istype(M.buffer, /obj/machinery/fusion/injector) && !linked)
		unscanned_devices += M.buffer
		while(unscanned_devices.len > 0) //Keep looping until all fusion engine devices near to eachother are linked
			for(var/obj/machinery/fusion/D in unscanned_devices) //Go through all the devices found last cycle
				if(istype(D, /obj/machinery/fusion/injector)) //Sorting
					input += D
					D.master = src
				else if(istype(D, /obj/machinery/fusion/electromagnet))
					control += D
					D.master = src
				else if(istype(D, /obj/machinery/atmospherics/pipe/containment))
					pipes += D
				for(var/obj/machinery/N in oview(1,D)) //Finding any fusion engine machines near to one found last cycle
					if((istype(N,/obj/machinery/fusion) || istype(N,/obj/machinery/atmospherics/pipe/containment)) && !(N in discovery))
						discovery += N
			unscanned_devices = discovery.Cut()
	linked = 1
	
/obj/machinery/computer/fusion_console/proc/unlink()
	control = list()
	input = list()
	pipes = list()
	linked = 0
					