/mob/camera/aiEye/remote/fusion_console
	visible_icon = 1
	icon = 'icons/obj/abductor.dmi'
	icon_state = "camera_target"
	
/mob/camera/aiEye/remote/fusion_console/setLoc(var/T)
	var/area/new_area = get_area(T)
	if(new_area && new_area.name == "Engineering")
		return ..()
	else
		return

/obj/machinery/computer/camera_advanced/fusion_console
	name = "Reaction Control Console"
	desc = "Legend says if a non-engineer touches this they'll be found in maintenence with toolbox shaped bruises and memory loss"
	
	//Camera vars
	networks = list("SS13")
	off_action = new/datum/action/innate/camera_off/fusion_console_off
	var/datum/action/innate/link_component/link_component_action = new
	
	circuit = /obj/item/weapon/circuitboard/computer/fusion_console
	
	var/screen = 1.0
	
	var/obj/item/device/radio/radio
	
	var/list/control = list() //Linked electromagnet(s)
	var/list/input = list() //Linked injector(s)
	var/list/pipes = list() //Linked pipes
	var/list/linked_devices = list() //All linked devices
	var/linked = 0
	
/obj/machinery/computer/camera_advanced/fusion_console/New()
	radio = new(src)
	radio.listening = 0
	..()
	
/obj/machinery/computer/camera_advanced/fusion_console/CreateEye()
	eyeobj = new /mob/camera/aiEye/remote/fusion_console()
	eyeobj.loc = get_turf(src)
	eyeobj.origin = src
	
/obj/machinery/computer/camera_advanced/fusion_console/GrantActions(mob/living/carbon/user)
	off_action.target = user
	off_action.Grant(user)
	
	link_component_action.target = user
	link_component_action.Grant(user)
	
/obj/machinery/computer/camera_advanced/fusion_console/deconstruction()
	unlink()
	..()

/obj/machinery/computer/camera_advanced/fusion_console/attackby(obj/item/weapon/I, mob/user, params)
	if(istype(I, /obj/item/device/multitool)) //Add injectors or electromagnet to the list of managed devices via multitool
		structure_link(I)
		usr << "<span class='caution'>You upload the data from the [I.name]'s buffer.</span>"
		return
	..()
	
/*		
/////////////I'll get this code working later
/obj/machinery/computer/camera_advanced/fusion_console/proc/structure_link(var/obj/item/device/multitool/I) //Recursive loops yay
	var/obj/item/device/multitool/M = I
	var/list/unscanned_devices
	var/list/discovery
	if(istype(M.buffer, /obj/machinery/fusion/injector) && !linked)
		unscanned_devices += M.buffer
		while(unscanned_devices) //Keep looping until all fusion engine devices near to eachother are linked
			for(var/obj/machinery/D in unscanned_devices) //Go through all the devices found last cycle
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
			if(discovery)
				unscanned_devices = discovery.Cut()
	linked = 1
*/

/obj/machinery/computer/camera_advanced/fusion_console/proc/structure_link(var/obj/item/device/multitool/I)
	//var/obj/item/device/multitool/M = I
	return
	
/obj/machinery/computer/camera_advanced/fusion_console/proc/unlink()
	control = list()
	input = list()
	pipes = list()
	linked = 0
	return
	
/obj/machinery/computer/camera_advanced/fusion_console/proc/control_camera(mob/user)
	if(current_user)
		return
	var/mob/living/carbon/L = user
	
	if(!eyeobj)
		CreateEye()
		
	if(!eyeobj.initialized)
		var/camera_location
		for(var/obj/machinery/camera/C in cameranet.cameras)
			if(!C.can_use())
				continue
			if(C.network&networks)
				camera_location = get_turf(C)
				break
		if(camera_location)
			eyeobj.initialized = 1
			give_eye_control(L)
			eyeobj.setLoc(camera_location)
		else
			user.unset_machine()
	else
		give_eye_control(L)
		eyeobj.setLoc(eyeobj.loc)
	return
	
/obj/machinery/computer/camera_advanced/fusion_console/Topic(href, href_list)
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
		screen = 0.2
		unlink()
		screen = 1.5
		
	else if(href_list["power_toggle"]) //Should be a button they press to toggle power on the component similar to air alarms
		var/obj/machinery/fusion/M
		var/temp_index = text2num(href_list["index"])
		switch(href_list["power_toggle"])
			if("injector")
				M = input[temp_index]
			if("electromagnet")
				M = control[temp_index]
		M.toggle_power()

	else if(href_list["set_speed"]) //Let the user input whatever, incorect entries are handled in electromagnet code
		var/temp_index = text2num(href_list["index"])
		var/obj/machinery/fusion/electromagnet/M = control[temp_index]
		var/new_speed = input("Please input desired speed", name, M.speed) as num
		if(..())
			return
		M.set_speed(new_speed)
		
	else if(href_list["set_torque"]) //Let the user input whatever, incorect entries are handled in electromagnet code
		var/temp_index = text2num(href_list["index"])
		var/obj/machinery/fusion/electromagnet/M = control[temp_index]
		var/new_torque = input("Please input desired torque", name, M.torque) as num
		if(..())
			return
		M.set_torque(new_torque)
		
	else if(href_list["set_output"]) //Should be a number between 0 and 100 representing a percentage, incorect entries are handled in injector code
		var/temp_index = text2num(href_list["index"])
		var/obj/machinery/fusion/injector/M = input[temp_index]
		var/new_output = input("Please set the injector throttle as a number from 0 to 100", name, M.output_multiplier) as num
		if(..())
			return
		M.set_output(new_output)
		
	updateUsrDialog()
	return
		
/obj/machinery/computer/camera_advanced/fusion_console/attack_hand(mob/user)
	interact(user)
	
/obj/machinery/computer/camera_advanced/fusion_console/interact(mob/user)
	user.set_machine(src)
	
	var/dat = ""
	
	switch(screen)
		if(0.0) dat += "<div class='statusDisplay'>BLANK</div>"
		
		if(0.1) //Locked
			dat += "<div class='statusDisplay'>SYSTEM LOCKED</div>"
			dat += "<A href='?src=\ref[src];unlock=1.0'>Unlock</A>"
			
		if(0.2) //Unlinking progress
			dat += "<div class='statusDisplay'>Unlinking all connected components...</div>"
			
		if(1.0) //Main menu
			dat += "<div class='statusDisplay'>"
			dat += "<h3>Main menu</h3><BR>"
			dat += "There are [pipes.len ? pipes.len : "no"] pipes linked to this console.<BR>"
			if(pipes.len > 0)
				var/lowest_integrity = 1
				var/integrity_percent
				for(var/obj/machinery/atmospherics/pipe/containment/P in pipes)
					integrity_percent = P.durability / P.max_durability
					if(integrity_percent < lowest_integrity)
						lowest_integrity = integrity_percent
				lowest_integrity *= 100
				dat += "The most damaged pipe is at [lowest_integrity]% integrity.<BR>"
			dat += "There are [control.len ? control.len : "no"] electromagnets linked to this console.<BR>"
			dat += "There are [input.len ? input.len : "no"] injectors linked to this console.<BR>"
			dat += "<A href='?src=\ref[src];menu=1.1'>Engine manipulator</A><BR>"
			if(control.len > 0)
				dat += "<A href='?src=\ref[src];menu=1.2'>Electromagnet control</A><BR>"
			else
				dat += "<span class='linkOff'>Electromagnet control</span><BR>"
			if(input.len > 0)
				dat += "<A href='?src=\ref[src];menu=1.3'>Injector control</A><BR>"
			else
				dat += "<span class='linkOff'>Injector control</span><BR>"
			if(pipes.len > 0)
				dat += "<A href='?src=\ref[src];menu=1.4'>Pipes control</A><BR>"
			else
				dat += "<span class='linkOff'>Pipes control</span><BR>"
			dat += "<A href='?src=\ref[src];menu=1.5'>Settings</A>"
			dat += "</div>"
			
		if(1.1) //Camera mode
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A><div class='statusDisplay'>"
			dat += "<h3>Camera in use</h3>"
			dat += "</div>"
			control_camera(user)
			
		if(1.2) //Electromagnet control
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A><div class='statusDisplay'>"
			var/i = 1
			var/component = "electromagnet"
			for(var/obj/machinery/fusion/electromagnet/M in control)
				dat += "Electromagnet #[i]<BR>"
				dat += "Speed: [M.speed]<BR>"
				dat += "Torque: [M.torque]<BR>"
				dat += "Stability: [M.stability]<BR>"
				dat += "<A href='?src=\ref[src];index=[i];power_toggle=[component]'>Power toggle</A>"
				if(M.power)
					dat += " Online<BR>"
				else
					dat += " Offline<BR>"
				dat += "<A href='?src=\ref[src];index=[i];set_speed=1.0'>Set speed</A><BR>"
				dat += "<A href='?src=\ref[src];index=[i];set_torque=1.0'>Set torque</A><BR>"
				i++
			dat += "</div>"
			
		if(1.3) //Injector control
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A><div class='statusDisplay'>"
			var/i = 1
			var/component = "injector"
			for(var/obj/machinery/fusion/injector/M in input)
				dat += "Injector #[i]<BR>"
				dat += "Remaining fuel: [M.remaining]<BR>"
				dat += "Remaining energy: [M.energy]<BR>"
				dat += "Output throttle: [M.output_multiplier*100]%<BR>"
				dat += "<A href='?src=\ref[src];index=[i];power_toggle=[component]'>Power toggle</A>"
				if(M.power)
					dat += " Online<BR>"
				else
					dat += " Offline<BR>"
				dat += "<A href='?src=\ref[src];index=[i];set_output=1.0'>Set output throttle</A><BR>"
				i++
			dat += "</div>"
			
		if(1.4) //Pipes control
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A><div class='statusDisplay'>"
			var/i = 1
			var/obj/machinery/atmospherics/pipe/containment/temp_pipe = pipes[1]
			var/datum/gas_mixture/pipe_air = temp_pipe.return_air()
			if(!pipe_air) //No one likes runtimes
				return
			var/pressure = pipe_air.return_pressure()
			//var/list/cached_gases = pipe_air.gases
			dat += "Pipeline info<BR>"
			dat += "Pressure: [pressure]kpa<BR>"
			dat += "Gas temperature: [pipe_air.temperature]K<BR>"
			for(var/obj/machinery/atmospherics/pipe/containment/M in pipes)
				dat += "Pipe #[i]<BR>"
				dat += "Integrity: [(M.durability/M.max_durability)*100]%<BR>"
				dat += "External temperature: [M.external_temperature ? M.external_temperature : "0"]<BR>"
				dat += "Max pressure: [M.max_pressure]<BR>"
				dat += "Internal heat resist: [M.internal_hr]<BR>"
				dat += "External heat resist: [M.external_hr]<BR>"
				i++
			dat += "</div>"
		
		if(1.5) //Settings
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A><div class='statusDisplay'>"
			dat += "<h3>Reaction Control Console Setting:</h3><BR>"
			dat += "<A href='?src=\ref[src];unlink=1.0'>Unlink components</A><BR>"
			dat += "<A href='?src=\ref[src];lock=0.1'>Lock</A><BR>"
	
	var/datum/browser/popup = new(user, "fusionconsole", name, 460, 550)
	popup.set_content(dat)
	popup.open()
	return
	
/datum/action/innate/camera_off/fusion_console_off/Activate()
	if(!target || !ishuman(target))
		return
	var/mob/living/carbon/human/C = target
	var/mob/camera/aiEye/remote/fusion_console/remote_eye = C.remote_control
	var/obj/machinery/computer/camera_advanced/fusion_console/origin = remote_eye.origin
	origin.current_user = null
	origin.link_component_action.Remove(C)
	
	remote_eye.eye_user = null
	C.reset_perspective(null)
	if(C.client)
		C.client.images -= remote_eye.user_image
		for(var/datum/camerachunk/chunk in remote_eye.visibleCameraChunks)
			C.client.images -= chunk.obscured
	C.remote_control = null
	C.unset_machine()
	src.Remove(C)
	
/datum/action/innate/link_component
	name = "Link component"
	button_icon_state = "knock"
	
/datum/action/innate/link_component/Activate()
	if(!target || !ishuman(owner))
		return
	var/mob/living/carbon/human/C = owner
	var/mob/camera/aiEye/remote/fusion_console/remote_eye = C.remote_control
	var/obj/machinery/computer/camera_advanced/fusion_console/origin = remote_eye.origin
	
	if(cameranet.checkTurfVis(remote_eye.loc))
		for(var/obj/machinery/I in remote_eye.loc)
			if(I in origin.linked_devices)
				continue
			else if(istype(I, /obj/machinery/fusion/injector)) //Sorting
				var/obj/machinery/fusion/injector/M = I
				origin.input += M
				M.master = src
			else if(istype(I, /obj/machinery/fusion/electromagnet))
				var/obj/machinery/fusion/electromagnet/M = I
				origin.control += M
				M.master = src
			else if(istype(I, /obj/machinery/atmospherics/pipe/containment))
				var/obj/machinery/atmospherics/pipe/containment/M = I
				origin.pipes += M
			origin.linked_devices += I
	else
		owner << "<span class='notice'>Target is not near a camera. Cannot proceed.</span>"