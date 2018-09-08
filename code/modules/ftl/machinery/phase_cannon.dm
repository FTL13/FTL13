#define CONSTRUCTION_STATE0 -1  //Apply plasteel frame
#define CONSTRUCTION_STATE1 0  //Bolt down
#define CONSTRUCTION_STATE2 1 //Weld to floor
#define CONSTRUCTION_STATE3 2 //Needs diamond
#define CONSTRUCTION_STATE4 3 //No chip
#define CONSTRUCTION_STATE5 4 //close hatch
#define CONSTRUCTION_COMPLETED 5 //Ready

//Cannon build data is located in code/game/objects/items/stacks/sheets/sheet_types.dm in a glob list sue me


/obj/machinery/power/shipweapon //PHYSICAL WEAPON
	name = "phase cannon"
	desc = "yell at someone to fix this."//"\n<span class='notice'>Alt-click to rotate it clockwise.</span>"
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
	var/obj/item/stack/sheet/lens = new /obj/item/stack/sheet/mineral/diamond

/obj/machinery/power/shipweapon/hardpoint
	state = CONSTRUCTION_STATE0
	name = "cannon hardpoint"
	desc = "A hardpoint designed to hold a ship to ship weapon."
	icon_state = "phase_cannon_con0"

	lens = null
	chip = null

/obj/machinery/power/shipweapon/Initialize()
	. = ..()
	if(state == CONSTRUCTION_COMPLETED)
		connect_to_network()
	if(lens) lens.amount = 5
	if(chip)
		name = chip.weapon_name
		desc = chip.weapon_desc


/obj/machinery/power/shipweapon/Destroy(force)
	if(force) //Is an admin actually trying to delete it?
		..()
		. = QDEL_HINT_HARDDEL_NOW
	else if(state != CONSTRUCTION_STATE0) //ELse we just break it to stage 0
		disconnect_from_network()
		state = CONSTRUCTION_STATE0
		name = "cannon hardpoint"
		icon_state = "phase_cannon_con0"
		if(lens)
			lens.loc = src.loc
			lens = null
		if(chip)
			chip.loc = src.loc
			chip = null
	return QDEL_HINT_LETMELIVE


/obj/machinery/power/shipweapon/process()
	if(stat & (BROKEN|MAINT))
		return
	if(!chip)
		current_charge = 0
		return
	if(!active_power_usage || avail(active_power_usage)) //Is there enough power available
		var/load = min((chip.attack_data.charge_to_fire - current_charge), charge_rate)		// charge at set rate, limited to spare capacity
		add_load(load) // add the load to the terminal side network
		current_charge = min(current_charge + load, chip.attack_data.charge_to_fire)

	if(can_fire()) //Load goes down if we can fire
		use_power = IDLE_POWER_USE
		update_icon()
	else
		use_power = ACTIVE_POWER_USE


/obj/machinery/power/shipweapon/proc/can_fire()
	if(state < CONSTRUCTION_COMPLETED)
		return FALSE
	return current_charge >= chip.attack_data.charge_to_fire

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
		if(CONSTRUCTION_STATE0) //Can only add plates
			if(istype(W, /obj/item/stack/sheet/plasteel)) //Fully decon
				var/obj/item/stack/sheet/plasteel/P = W
				if(P.use(25))
					state = CONSTRUCTION_STATE1
					to_chat(user, "<span class='notice'>You add framing onto \the [src].</span>")
				else
					to_chat(user, "<span class='notice'>You need 25 sheets of Plasteel to contruct a cannon on \the [src].</span>")
					return
			else
				to_chat(user, "<span class='notice'>You need 25 sheets of Plasteel to contruct a cannon on \the [src].</span>")
				return


		if(CONSTRUCTION_STATE1) //Weld the cannon in place or decon it
			if(istype(W, /obj/item/weapon/weldingtool)) //Fully decon
				var/obj/item/weapon/weldingtool/WT = W
				if(!WT.remove_fuel(0, user))
					if(!WT.isOn())
						to_chat(user, "<span class='warning'>\The [WT] must be on to complete this task!</span>")
					return
				playsound(src.loc, W.usesound, 50, 1)
				to_chat(user, "<span class='notice'>You start to disassemble the frame from \the [src]...</span>")
				if(do_after(user, 20*W.toolspeed, target = src))
					if(!src || !WT.isOn()) return
					to_chat(user, "<span class='notice'>You disassemble the frame from \the [src].</span>")
					var/obj/item/stack/sheet/plasteel/P = new (loc, 25)
					P.add_fingerprint(user)
					W.add_fingerprint(user)
					state = CONSTRUCTION_STATE0

			if(istype(W, /obj/item/weapon/wrench)) //construct
				playsound(src.loc, W.usesound, 50, 1)
				to_chat(user, "<span class='notice'>You begin to bolt cannon the frame to \the [src]...</span>")
				if(do_after(user, 20*W.toolspeed, target = src))
					if(!src) return
					to_chat(user, "<span class='notice'>You bolt the cannon frame to \the [src].</span>")
					anchored = TRUE
					state = CONSTRUCTION_STATE2
					W.add_fingerprint(user)


		if(CONSTRUCTION_STATE2) //unbolt the cannon or weld it down

			if(istype(W, /obj/item/weapon/wrench)) //decon
				playsound(src.loc, W.usesound, 50, 1)
				to_chat(user, "<span class='notice'>You start to unbolt the frame from \the [src]...</span>")
				if(do_after(user, 20*W.toolspeed, target = src))
					if(!src) return
					to_chat(user, "<span class='notice'>You unbolt the frame from \the [src].</span>")
					state = CONSTRUCTION_STATE1
					W.add_fingerprint(user)

			if(istype(W, /obj/item/weapon/weldingtool)) //Contruct
				var/obj/item/weapon/weldingtool/WT = W
				if(!WT.remove_fuel(0, user))
					if(!WT.isOn())
						to_chat(user, "<span class='warning'>\The [WT] must be on to complete this task!</span>")
					return
				playsound(src.loc, W.usesound, 50, 1)
				to_chat(user, "<span class='notice'>You begin to weld the frame onto \the [src]...</span>")
				if(do_after(user, 20*W.toolspeed, target = src))
					if(!src || !WT.isOn()) return
					to_chat(user, "<span class='notice'>You weld the frame onto \the [src].</span>")
					state = CONSTRUCTION_STATE3
					W.add_fingerprint(user)
					name = "unfinished cannon"


		if(CONSTRUCTION_STATE3) //unweld the cannon or add focusing lenses
			if(istype(W, /obj/item/weapon/weldingtool)) //Decon
				var/obj/item/weapon/weldingtool/WT = W
				if(!WT.remove_fuel(0, user))
					if(!WT.isOn())
						to_chat(user, "<span class='warning'>\The [WT] must be on to complete this task!</span>")
					return
				playsound(src.loc, W.usesound, 50, 1)
				to_chat(user, "<span class='notice'>You start unwelding the frame of \the [src]...</span>")
				if(do_after(user, 20*W.toolspeed, target = src))
					if(!src || !WT.isOn()) return
					to_chat(user, "<span class='notice'>You unweld the frame of \the [src].</span>")
					state = CONSTRUCTION_STATE2
					W.add_fingerprint(user)
					name = "cannon hardpoint"

			if(istype(W, /obj/item/stack/sheet)) //Contruct
				var/obj/item/stack/sheet/S = W
				if(istype(S, /obj/item/stack/sheet/mineral/diamond))
					if(S.use(5)) lens = new /obj/item/stack/sheet/mineral/diamond
					else to_chat(user, "<span class='warning'>You require at least 5 [S] to install lenses for \the [src]!</span>")
				else if(istype(S, /obj/item/stack/sheet/glass))
					if(S.use(5)) lens = new /obj/item/stack/sheet/glass
					else to_chat(user, "<span class='warning'>You require at least 5 [S] to install lenses for \the [src]!</span>")
				else to_chat(user, "<span class='warning'>You require either 5 Glass or Diamond sheets as lenses for \the [src]!</span>")

				lens.amount = 5
				to_chat(user, "<span class='notice'>You install \the [S] as focusing lenses for \the [src].</span>")
				state = CONSTRUCTION_STATE4


		if(CONSTRUCTION_STATE4) //remove lenses or add chip
			if(istype(W, /obj/item/weapon/crowbar)) //Decon
				to_chat(user, "<span class='notice'>You pry \the [lens] focusing lenses out of \the [src].</span>")
				lens.loc = src.loc
				W.add_fingerprint(user)
				lens.add_fingerprint(user)
				lens = null
				state = CONSTRUCTION_STATE3

			if(istype(W, /obj/item/weapon_chip)) //Contruct
				if(!user.drop_item()) return
				playsound(src.loc, 'sound/items/deconstruct.ogg', 50, 1)
				chip = W
				W.loc = src
				W.add_fingerprint(user)
				to_chat(user, "<span class='notice'>You install \the [W] into \the [src].</span>")
				state = CONSTRUCTION_STATE5
				if(istype(lens, /obj/item/stack/sheet/glass)) chip.attack_data.shot_accuracy -= 0.3 //Bad aim for bad lenses


		if(CONSTRUCTION_STATE5) //remove chip or close cover
			if(istype(W, /obj/item/weapon/crowbar)) //Decon
				chip.loc = src.loc
				to_chat(user, "<span class='notice'>You remove \the [chip] out of \the [src].</span>")
				if(istype(lens, /obj/item/stack/sheet/glass)) chip.attack_data.shot_accuracy = initial(chip.attack_data.shot_accuracy) //Undo any bad lens based aim
				chip = null
				state = CONSTRUCTION_STATE4

			if(istype(W, /obj/item/weapon/screwdriver)) //Contruct
				to_chat(user, "<span class='notice'>You close the maintenance hatch of \the [src].</span>")
				name = chip.weapon_name
				desc = chip.weapon_desc
				connect_to_network()
				state = CONSTRUCTION_COMPLETED

		if(CONSTRUCTION_COMPLETED) //open cover

			if(istype(W, /obj/item/weapon/screwdriver)) //Decon
				to_chat(user, "<span class='notice'>You open the maintenance hatch of \the [src].</span>")
				name = "unfinished cannon"
				desc = "A hardpoint designed to hold a ship to ship weapon."
				disconnect_from_network()
				state = CONSTRUCTION_STATE5
				current_charge = 0

	update_icon()








/obj/machinery/power/shipweapon/update_icon()
	switch(state)
		if(CONSTRUCTION_STATE0)
			icon_state = "phase_cannon_con0"
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


#undef CONSTRUCTION_STATE0
#undef CONSTRUCTION_STATE1
#undef CONSTRUCTION_STATE2
#undef CONSTRUCTION_STATE3
#undef CONSTRUCTION_STATE4
#undef CONSTRUCTION_STATE5
#undef CONSTRUCTION_COMPLETED
