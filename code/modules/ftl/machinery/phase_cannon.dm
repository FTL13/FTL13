#define CONSTRUCTION_STATE1 0  //Bolt down
#define CONSTRUCTION_STATE2 1 //Weld to floor
#define CONSTRUCTION_STATE3 2 //Needs diamond
#define CONSTRUCTION_STATE4 3 //No chip
#define CONSTRUCTION_STATE5 4 //close hatch
#define CONSTRUCTION_COMPLETED 5 //Ready

//Cannon build data is located in code/game/objects/items/stacks/sheets/sheet_types.dm in a glob list sue me


/obj/machinery/power/shipweapon //PHYSICAL WEAPON
	name = "phase cannon"
	desc = "A powerful weapon designed to take down shields."//"\n<span class='notice'>Alt-click to rotate it clockwise.</span>"
	icon = 'icons/obj/96x96.dmi'
	icon_state = "phase_cannon"
	dir = EAST
	pixel_x = -32
	pixel_y = -23
	anchored = TRUE
	density = TRUE
	var/state = CONSTRUCTION_COMPLETED

	var/charge_rate = 400 //5 second fire rate with phase cannons
	var/current_charge = 0

	use_power = ACTIVE_POWER_USE
	idle_power_usage = 1000
	active_power_usage = 20000

	var/obj/item/weapon_chip/chip = new /obj/item/weapon_chip

/obj/machinery/power/shipweapon/playermade
	state = CONSTRUCTION_STATE1
	anchored = FALSE
	name = "unfinished cannon"
	icon_state = "phase_cannon_con12"

/obj/machinery/power/shipweapon/Initialize()
	. = ..()
	if(state == CONSTRUCTION_COMPLETED)
		connect_to_network()


/obj/machinery/power/shipweapon/Destroy()
	. = ..()
	disconnect_from_network()

/obj/machinery/power/shipweapon/process()
	if(stat & (BROKEN|MAINT))
		return
	if(!chip)
		current_charge = 0
		return
	if(!active_power_usage || avail(active_power_usage)) //Is there enough power available
		var/load = min((chip.charge_to_fire - current_charge), charge_rate)		// charge at set rate, limited to spare capacity
		add_load(load) // add the load to the terminal side network
		current_charge = min(current_charge + load, chip.charge_to_fire)

	if(can_fire()) //Load goes down if we can fire
		use_power = IDLE_POWER_USE
		update_icon()
	else
		use_power = ACTIVE_POWER_USE


/obj/machinery/power/shipweapon/proc/can_fire()
	if(state < CONSTRUCTION_COMPLETED)
		return FALSE
	return current_charge >= chip.charge_to_fire

/obj/machinery/power/shipweapon/proc/attempt_fire(var/datum/ship_component/target_component,var/shooter)
	if(!can_fire())
		return FALSE
	current_charge = 0
	if(chip.attack_data.fire_delay)
		for(var/i in 1 to chip.attack_data.shots_fired) //Fire for the amount of time
			addtimer(CALLBACK(src, .proc/spawn_projectile, target_component, shooter), chip.attack_data.fire_delay*i)
	else
		spawn_projectile(target_component, shooter)

	update_icon()

	return TRUE

/obj/machinery/power/shipweapon/proc/spawn_projectile(var/datum/ship_component/target_component, var/shooter)
	var/obj/item/projectile/ship_projectile/A = new chip.projectile_type(src.loc)

	A.setDir(EAST)
	A.pixel_x = 32
	A.pixel_y = 12
	A.shooter = shooter
	A.yo = 0
	A.xo = 20
	A.attack_data = chip.attack_data
	A.starting = loc
	A.fire()
	A.target = target_component

	playsound(loc, chip.fire_sound, 50, 1)

	for(var/obj/machinery/computer/ftl_weapons/C in GLOB.ftl_weapons_consoles)
		if(!istype(get_area(C), /area/shuttle/ftl))
			continue
		if(!(src in C.laser_weapons))
			continue
		playsound(C, chip.fire_sound, 50, 1)

	if(prob(35)) //Random chance to spark
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(5, 1, src)
		s.start()

/obj/machinery/power/shipweapon/attackby(obj/item/W, mob/user, params) //someone add this thanks -no
	switch(state)
		if(CONSTRUCTION_STATE1) //Weld the cannon in place or decon it

			if(istype(W, /obj/item/weapon/weldingtool)) //Fully decon
				var/obj/item/weapon/weldingtool/WT = W
				if(!WT.remove_fuel(0, user))
					if(!WT.isOn())
						to_chat(user, "<span class='warning'>\The [WT] must be on to complete this task!</span>")
					return
				playsound(src.loc, W.usesound, 50, 1)
				to_chat(user, "<span class='notice'>You start to disassemble \the [src]...</span>")
				if(do_after(user, 20*W.toolspeed, target = src))
					if(!src || !WT.isOn()) return
					to_chat(user, "<span class='notice'>You disassemble \the [src].</span>")
					var/obj/item/stack/sheet/plasteel/P = new (loc, 25)
					P.add_fingerprint(user)
					W.add_fingerprint(user)
					qdel(src)

			if(istype(W, /obj/item/weapon/wrench)) //construct
				playsound(src.loc, W.usesound, 50, 1)
				to_chat(user, "<span class='notice'>You begin to bolt \the [src] to the floor...</span>")
				if(do_after(user, 20*W.toolspeed, target = src))
					if(!src) return
					to_chat(user, "<span class='notice'>You bolt the cannon to the floor.</span>")
					anchored = TRUE
					state = CONSTRUCTION_STATE2
					W.add_fingerprint(user)


		if(CONSTRUCTION_STATE2) //unbolt the cannon or weld it down

			if(istype(W, /obj/item/weapon/wrench)) //decon
				playsound(src.loc, W.usesound, 50, 1)
				to_chat(user, "<span class='notice'>You start to unbolt \the [src] from the floor...</span>")
				if(do_after(user, 20*W.toolspeed, target = src))
					if(!src) return
					to_chat(user, "<span class='notice'>You unbolt \the [src] from the floor.</span>")
					anchored = FALSE
					state = CONSTRUCTION_STATE1
					W.add_fingerprint(user)

			if(istype(W, /obj/item/weapon/weldingtool)) //Contruct
				var/obj/item/weapon/weldingtool/WT = W
				if(!WT.remove_fuel(0, user))
					if(!WT.isOn())
						to_chat(user, "<span class='warning'>\The [WT] must be on to complete this task!</span>")
					return
				playsound(src.loc, W.usesound, 50, 1)
				to_chat(user, "<span class='notice'>You begin to weld the supports of \the [src] into place...</span>")
				if(do_after(user, 20*W.toolspeed, target = src))
					if(!src || !WT.isOn()) return
					to_chat(user, "<span class='notice'>You weld the supports of \the [src] in place.</span>")
					anchored = TRUE
					state = CONSTRUCTION_STATE3
					W.add_fingerprint(user)

		if(CONSTRUCTION_STATE3) //unweld the cannon or add focusing lenses
			if(istype(W, /obj/item/weapon/weldingtool)) //Decon
				var/obj/item/weapon/weldingtool/WT = W
				if(!WT.remove_fuel(0, user))
					if(!WT.isOn())
						to_chat(user, "<span class='warning'>\The [WT] must be on to complete this task!</span>")
					return
				playsound(src.loc, W.usesound, 50, 1)
				to_chat(user, "<span class='notice'>You start unwelding the cannons supports...</span>")
				if(do_after(user, 20*W.toolspeed, target = src))
					if(!src || !WT.isOn()) return
					to_chat(user, "<span class='notice'>You unweld the supports of \the [src].</span>")
					anchored = FALSE
					state = CONSTRUCTION_STATE2
					W.add_fingerprint(user)

			if(istype(W, /obj/item/stack/sheet/mineral/diamond)) //Contruct
				var/obj/item/stack/sheet/mineral/diamond/D = W
				if(D.use(5))
					to_chat(user, "<span class='notice'>You install \the [D] as focusing lenses for \the [src].</span>")
					state = CONSTRUCTION_STATE4
				else
					to_chat(user, "<span class='warning'>You require at least 5 [D] to install lenses for \the [src]!</span>")

		if(CONSTRUCTION_STATE4) //remove lenses or add chip
			if(istype(W, /obj/item/weapon/crowbar)) //Decon
				to_chat(user, "<span class='notice'>You pry the focusing lenses out of \the [src].</span>")
				var/obj/item/stack/sheet/mineral/diamond/D = new (loc, 5)
				D.add_fingerprint(user)
				state = CONSTRUCTION_STATE3


			if(istype(W, /obj/item/weapon_chip)) //Contruct
				if(!user.drop_item())
					return
				playsound(src.loc, 'sound/items/deconstruct.ogg', 50, 1)
				chip = W
				W.loc = src
				to_chat(user, "<span class='notice'>You install \the [W] into \the [src].</span>")
				state = CONSTRUCTION_STATE5

		if(CONSTRUCTION_STATE5) //remove chip or close cover
			if(istype(W, /obj/item/weapon/crowbar)) //Decon
				chip.loc = src.loc
				to_chat(user, "<span class='notice'>You remove \the [chip] out of \the [src].</span>")
				chip = null
				state = CONSTRUCTION_STATE4

			if(istype(W, /obj/item/weapon/screwdriver)) //Contruct
				to_chat(user, "<span class='notice'>You close the maintenance hatch of \the [src].</span>")
				name = chip.weapon_name
				connect_to_network()
				state = CONSTRUCTION_COMPLETED

		if(CONSTRUCTION_COMPLETED) //open cover

			if(istype(W, /obj/item/weapon/screwdriver)) //Decon
				to_chat(user, "<span class='notice'>You open the maintenance hatch of \the [src].</span>")
				name = "unfinished cannon"
				disconnect_from_network()
				state = CONSTRUCTION_STATE5
				current_charge = 0

	update_icon()








/obj/machinery/power/shipweapon/update_icon()
	switch(state)
		if(CONSTRUCTION_STATE1)
			icon_state = "phase_cannon_con12"
		if(CONSTRUCTION_STATE2)
			icon_state = "phase_cannon_con12"
		if(CONSTRUCTION_STATE3)
			icon_state = "phase_cannon_con3"
		if(CONSTRUCTION_STATE4)
			icon_state = "phase_cannon_con4"
		if(CONSTRUCTION_STATE5)
			icon_state = "phase_cannon_con5"
		if(CONSTRUCTION_COMPLETED)
			if(can_fire())
				icon_state = "[chip.icon_name]_fire"
			else
				icon_state = "[chip.icon_name]"


#undef CONSTRUCTION_STATE1
#undef CONSTRUCTION_STATE2
#undef CONSTRUCTION_STATE3
#undef CONSTRUCTION_STATE4
#undef CONSTRUCTION_STATE5
#undef CONSTRUCTION_COMPLETED
