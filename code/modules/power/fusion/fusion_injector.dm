/obj/machinery/atmospherics/pipe/containment_pipe/injector //The injector is must be constructed as part of the containment pipe loop
	name = "Fusion Plasma Injector"
	desc = "A block of machinery used in heating elements to form a plasma."
	//icon = icons/obj/fusion_engine/injector.dmi
	//icon_state
	
	//Upgradeable vars
	var/fuel_efficiency = 0 //How much fusion plasma can be made from one unit of fuel
	var/yield = 0 //How much fusion plasma can be made in one unit of time
	
	//Process vars
	var/remaining = 0 //How much fusion plasma remains to be made from this unit of fuel
	var/channel = "DEFAULT"
	
/obj/machinery/atmospherics/pipe/containment_pipe/injector/New()
	..()
	
/obj/machinery/atmospherics/pipe/containment_pipe/injector/attackby(obj/item/I, mob/user, params)
	//if(default_deconstruction_screwdriver(user, 'stage1', 'stage2', I))
	//	return
	//if(default_deconstruction_crowbar(I))
	//	return
		
	if(panel_open)
		if(istype(I, /obj/item/device/multitool))
			var/obj/item/device/multitool/M = I
			M.buffer = src
			user << "<span class='caution'>You save the data in the [I.name]'s buffer.</span>"
			return 1
			
	else
		return ..()