////////////////////////////////////////////
// POWERNET DATUM
// each contiguous network of cables & nodes
/////////////////////////////////////
/datum/powernet
	var/number					// unique id
	var/list/cables = list()	// all cables & junctions
	var/list/nodes = list()		// all connected machines
	var/list/power_groups = list()

	var/avail = 0				//...the current available power in the powernet
	var/lastavail = 0;
	var/viewavail = 0			// the available power as it appears on the power console (gradually updated)
	var/viewpowergen = 0
	var/load = 0
	var/viewload = 0
	var/surplus = 0				// How much extra load can we add before we have..... problems?

/datum/powernet/New()
	// Initialize the array of arrays
	power_groups.len = NUM_POWER_GROUPS
	for(var/i in 1 to NUM_POWER_GROUPS)
		power_groups[i] = list()
	START_PROCESSING(SSpower, src)

/datum/powernet/Destroy()
	//Go away references, you suck!
	for(var/obj/structure/cable/C in cables)
		cables -= C
		C.powernet = null
	for(var/obj/machinery/power/M in nodes)
		nodes -= M
		M.powernet = null

	STOP_PROCESSING(SSpower, src)
	return ..()

/datum/powernet/proc/is_empty()
	return !cables.len && !nodes.len

//remove a cable from the current powernet
//if the powernet is then empty, delete it
//Warning : this proc DOESN'T check if the cable exists
/datum/powernet/proc/remove_cable(obj/structure/cable/C)
	cables -= C
	C.powernet = null
	if(is_empty())//the powernet is now empty...
		qdel(src)///... delete it

//add a cable to the current powernet
//Warning : this proc DOESN'T check if the cable exists
/datum/powernet/proc/add_cable(obj/structure/cable/C)
	if(C.powernet)// if C already has a powernet...
		if(C.powernet == src)
			return
		else
			C.powernet.remove_cable(C) //..remove it
	C.powernet = src
	cables += C

//remove a power machine from the current powernet
//if the powernet is then empty, delete it
//Warning : this proc DOESN'T check if the machine exists
/datum/powernet/proc/remove_machine(obj/machinery/power/M)
	nodes -= M
	M.powernet = null
	power_groups[M.power_group] -= M
	if(is_empty())//the powernet is now empty...
		qdel(src)///... delete it


//add a power machine to the current powernet
//Warning : this proc DOESN'T check if the machine exists
/datum/powernet/proc/add_machine(obj/machinery/power/M)
	if(M.powernet)// if M already has a powernet...
		if(M.powernet == src)
			return
		else
			M.disconnect_from_network()//..remove it
	power_groups[M.power_group] |= M
	M.powernet = src
	nodes[M] = M

//handles the power changes in the powernet
/datum/powernet/process()
	viewpowergen = round(0.8 * viewpowergen + 0.2 * avail)
	SSpower.total_gen_power += viewpowergen
	var/total_smespower = 0
	// How much total can the SMES units output
	for(var/obj/machinery/power/smes/S in nodes)
		if(S.charge > 0 && S.outputting)
			total_smespower += min(S.charge/SMESRATE, S.output_level)
	
	// Yes, I'm delivering the power *before* taking the power from the SMES units, now shut up you angry dutch person.
	var/delivered = deliverpower(avail+total_smespower) // Deliver with the avail factored in
	load = delivered
	surplus = avail+total_smespower-delivered
	// Now remove the avail to see what we need to take from the SMES units
	delivered = max(0, delivered-avail)
	avail += total_smespower
	
	// What percent of the SMES' available output to take?
	var/take_percent = total_smespower != 0 ? min(delivered/total_smespower, 1) : 0
	// And take them
	if(take_percent > 0)
		for(var/obj/machinery/power/smes/S in nodes)
			if(S.charge > 0 && S.outputting)
				var/tosend = min(S.charge/SMESRATE, S.output_level) * take_percent
				S.send_power(tosend)
				S.charge -= tosend*SMESRATE
				S.output_used = tosend
			else
				break

	// update power consoles
	viewavail = round(0.8 * viewavail + 0.2 * avail)
	viewload = round(0.8 * viewload + 0.2 * load)
	// update old
	lastavail = avail
	// reset avail
	avail = 0

/datum/powernet/proc/get_electrocute_damage()
	if(avail >= 1000)
		return Clamp(round(avail/10000), 10, 90) + rand(-5,5)
	else
		return 0

/datum/powernet/proc/deliverpower(realavail, testmode)
	var/delivered = 0
	//Reset the received power of nodes.
	if(!testmode)
		for(var/obj/machinery/power/P in nodes)
			P.last_power_received = 0
			P.last_power_requested = P.power_requested
		for(var/obj/machinery/power/terminal/T in nodes)
			var/obj/machinery/power/apc/A = T.master
			if(istype(A))
				A.last_power_received = 0
				A.last_power_requested = A.power_requested
	
	//we can now distribute power to nodes, priority first
	if(realavail > 0 || testmode)
		for(var/power_group in 1 to NUM_POWER_GROUPS)
			if(power_group == POWER_GROUP_APC || power_group == POWER_GROUP_APC_PRIORITY)
				for(var/obj/machinery/power/terminal/T in power_groups[power_group])
					if(!T.master)
						continue
					var/obj/machinery/power/apc/A = T.master
					if(istype(A))
						if(A.operating)
							if(realavail >= A.power_requested)
								if(!testmode)
									A.last_power_received += A.power_requested
								delivered += A.power_requested
								realavail -= A.power_requested
							else
								break
			if(power_group == POWER_GROUP_HIGHPOWER)
				for(var/obj/machinery/power/P in power_groups[power_group])
					if(realavail >= P.power_requested)
						if(!testmode)
							P.last_power_received += P.power_requested
						delivered += P.power_requested
						realavail -= P.power_requested
					else
						break
			if(power_group == POWER_GROUP_PARTIALPOWER || power_group == POWER_GROUP_SMES_INPUT)
				// This group splits the power between all the partial-power machines if there isn't enough power
				var/total_requested_power = 0
				for(var/obj/machinery/power/P in power_groups[power_group])
					total_requested_power += P.power_requested

				var/percentage = total_requested_power != 0 ? min(realavail / total_requested_power, 1) : 0
				for(var/obj/machinery/power/P in power_groups[power_group])
					if(!testmode)
						P.last_power_received += P.power_requested * percentage
					delivered += P.power_requested * percentage
					realavail -= P.power_requested * percentage

	return delivered
