#define CONSTRUCTION_STATE1 0
#define CONSTRUCTION_STATE2 1
#define CONSTRUCTION_STATE3 2
#define CONSTRUCTION_STATE4 3
#define CONSTRUCTION_COMPLETED 4

/obj/machinery/power/shipweapon //PHYSICAL WEAPON
	name = "phase cannon"
	desc = "A powerful weapon designed to take down shields.\n<span class='notice'>Alt-click to rotate it clockwise.</span>"
	icon = 'icons/obj/96x96.dmi'
	icon_state = "phase_cannon"
	pixel_x = -32
	pixel_y = -23
	anchored = TRUE
	density = TRUE
	var/state = CONSTRUCTION_COMPLETED

	var/charge_rate = 200
	var/current_charge = 0

	use_power = ACTIVE_POWER_USE
	idle_power_usage = 1000
	active_power_usage = 20000

	var/obj/item/weapon_chip/chip

/obj/machinery/power/shipweapon/process()
	if(stat & (BROKEN|MAINT))
		return
	if(!chip)
		current_charge = 0
		return
	if(!active_power_usage || avail(active_power_usage)) //Is there enough power available
		var/load = min((chip.charge_to_fire - current_charge), charge_rate)		// charge at set rate, limited to spare capacity
		add_load(load) // add the load to the terminal side network
		current_charge = max(current_charge + load, chip.charge_to_fire)

	if(can_fire()) //Load goes down if we can fire
		use_power = IDLE_POWER_USE
	else
		use_power = ACTIVE_POWER_USE

/obj/machinery/power/shipweapon/proc/can_fire()
	if(state < construction_completed)
		return FALSE
	return current_charge >= chip.charge_to_fire && chip

/obj/machinery/power/shipweapon/proc/attempt_fire(var/datum/ship_component/target_component,var/shooter)
	if(!can_fire())
		return FALSE
	current_charge = 0
	for(var/i in 1 to chip.attack_data.shots_fired) //Fire for the amount of time
		addtimer(CALLBACK(src, .proc/spawn_projectile, target_component, shooter), 10)

	update_icon()

	return TRUE

/obj/machinery/power/shipweapon/proc/spawn_projectile(var/datum/ship_component/target_component, var/shooter)
	var/obj/item/projectile/ship_projectile/A = new chip.projectile_type(src.loc)

	A.setDir(EAST)
	A.pixel_x = 32
	A.shooter = shooter
	A.yo = 0
	A.xo = 20
	A.attack_data = chip.attack_data //Actual info of weapon
	A.starting = loc
	A.fire()
	A.target = target_component

	playsound(loc, chip.fire_sound, 50, 1)

	for(var/obj/machinery/computer/ftl_weapons/C in world) //this is disgusting monster
		if(!istype(get_area(C), /area/shuttle/ftl))
			continue
		if(!(src in C.laser_weapons))
			continue
		playsound(C, chip.fire_sound, 50, 1)

	if(prob(35)) //Random chance to spark
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(5, 1, src)
		s.start()

/obj/machinery/power/shipweapon/attackby(obj/item/W, mob/user, params) //someone add this thanks
	switch(state)
		if(CONSTRUCTION_STATE1)
		if(CONSTRUCTION_STATE2)
		if(CONSTRUCTION_STATE3)
		if(CONSTRUCTION_STATE4)
		if(CONSTRUCTION_COMPLETED)
			if(chip)
				if(istype(W, /obj/item/weapon/screwdriver))
					W.loc = src.loc
					chip = null
					current_charge = 0
			else if(istype(W, /obj/item/weapon_chip))
				W.loc = src
				chip = W
	update_icon()

/obj/machinery/power/shipweapon/update_icon()
	switch(state)
		if(CONSTRUCTION_STATE1)
		if(CONSTRUCTION_STATE2)
		if(CONSTRUCTION_STATE3)
		if(CONSTRUCTION_STATE4)
		if(CONSTRUCTION_COMPLETED)
			if(can_fire())
				icon_state = "[chip.weapon_name]_fire"
			else
				icon_state = "[chip.weapon_name]"


#undef CONSTRUCTION_STATE1
#undef CONSTRUCTION_STATE2
#undef CONSTRUCTION_STATE3
#undef CONSTRUCTION_STATE4
#undef CONSTRUCTION_COMPLETED
