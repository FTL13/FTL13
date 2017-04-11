/obj/machinery/computer/fusion_console
	name = "Reaction Control Console"
	desc = "Legend says if a non-engineer touches this they'll be found in maintenence with toolbox shaped bruises and memory loss"
	
	circuit = /obj/item/weapon/circuitboard/computer/fusion_console
	
	var/screen = 1.0
	
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

/*
Screens:
1.0 Main menu
0.1 Locked
0.0 Blank
*/
	
/obj/machinery/computer/fusion_console/Topic(href, href_list)
	if(..())
		return
		
	add_fingerprint(usr)
	
	usr.set_machine(src)
	
	if(href_list["menu"])
		var/temp_screen = text2num(href_list["menu"])
		screen = temp_screen
		
	else if(href_list["lock"]) //Same as RnD console code
		if(src.allowed(usr))
			screen = 0.1
		else
			usr << "Unauthorized Access."
			
	else if(href_list["unlock"])
		if(src.allowed(usr))
			screen = 1.0
		else
			usr << "Unauthorized Access."
		
	else if(href_list["unlink"])
		screen = 0.0
		unlink()
		
	else if(href_list["power_toggle"]) //Should be a button they press to toggle power on the component similar to air alarms
		var/obj/machinery/fusion/M
		switch(href_list["power_toggle"])
			if("injector")
				M = input[href_list["index"]]
			if("electromagnet")
				M = control[href_list["index"]]
		M.toggle_power()

	else if(href_list["set_speed"]) //Let the user input whatever, incorect entries are handled in electromagnet code
		var/obj/machinery/fusion/electromagnet/M = control[href_list["index"]]
		M.set_speed(href_list["set_speed"])
		
	else if(href_list["set_torque"]) //Let the user input whatever, incorect entries are handled in electromagnet code
		var/obj/machinery/fusion/electromagnet/M = control[href_list["index"]]
		M.set_torque(href_list["set_torque"])
		
	else if(href_list["set_output"]) //Should be a number between 0 and 100 representing a percentage, incorect entries are handled in injector code
		var/obj/machinery/fusion/injector/M = input[href_list["index"]]
		M.set_output(href_list["set_output"])