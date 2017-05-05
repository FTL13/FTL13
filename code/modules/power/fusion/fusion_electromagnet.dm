/obj/machinery/fusion/electromagnet
	name = "Central Electromagnet"
	desc = "A large cylindrical magnet used to generate a magnetic containment field."
	icon = 'icons/obj/fusion_engine/electromagnet.dmi'
	icon_state = "off"
	anchored = 1
	density = 1
	bound_width = 96
	bound_height = 96
	bound_x = -32
	bound_y = -32
	pixel_x = -32
	pixel_y = -32
	
	//Mod vars
	fusion_machine = "electromagnet"
	
	//Upgradeable vars
	var/max_speed = 300
	var/max_torque = 1000
	var/precision = 5 //round to the nearest of this number when the user decides the speed and torque they want
	var/safety = 1 //instability multiplier
	
	//Process vars
	var/speed = 0
	var/torque = 0
	var/stability = 0 //used in determining coherence based on how much you're pushing it
	
	//Linked objects
	var/list/pipes = list()
	
/obj/machinery/fusion/electromagnet/New()
	..()
	var/obj/item/weapon/circuitboard/machine/B = new /obj/item/weapon/circuitboard/machine/electromagnet(null)
	B.apply_default_parts(src)
	
	if(map_ready)
		initialize()
	
/obj/machinery/fusion/electromagnet/initialize()
	for(var/obj/machinery/atmospherics/pipe/containment/P in oview(2,src))
		pipes += P
		P.master += src
		
	..()
		
/obj/machinery/fusion/electromagnet/update_icon()
	if(speed == 0 || !power)
		icon_state = "off"
	else if(speed < 200)
		icon_state = "on"
		dir = SOUTH
	else if(speed < 400)
		dir = NORTH
	else if(speed >= 400)
		dir = EAST
	
/obj/item/weapon/circuitboard/machine/electromagnet
	name = "circuit board (Fusion Engine Electromagnet)"
	build_path = /obj/machinery/fusion/electromagnet
	origin_tech = "magnets=3;programming=3;engineering=2"
	req_components = list(
		/obj/item/weapon/stock_parts/capacitor = 3,
		/obj/item/weapon/stock_parts/scanning_module = 1,
		/obj/item/weapon/stock_parts/manipulator = 3)
	
/obj/machinery/fusion/electromagnet/attackby(obj/item/I, mob/user, params)
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
	..()
	
/obj/machinery/fusion/electromagnet/toggle_power()
	initialize()
	..()
	
/obj/machinery/fusion/electromagnet/proc/set_speed(S)
	if(S <= max_speed)
		speed = round(S,precision)
		calc_stability()
		return 1
	return 0
			
/obj/machinery/fusion/electromagnet/proc/set_torque(T)
	if(T <= max_torque)
		torque = round(T,precision)
		calc_stability()
		return 1
	return 0
	
/obj/machinery/fusion/electromagnet/proc/calc_stability() //Sweet sweet math
	if(speed == 0 || torque == 0)
		stability = 0 //Let's not have division by 0 mkay?
		return
	var/speed_stability = min(max_speed/2/speed,1) //You can go up to half max speed without instability
	var/torque_stability = min(max_torque/2/torque,1) //You can go up to half max torque without instability
	stability = 1-safety*(-speed_stability/2-torque_stability/2+1) //value can be 0 to 1, lower is more instability
	
/obj/machinery/fusion/electromagnet/process()
	update_icon()
	calc_stability()
	..()