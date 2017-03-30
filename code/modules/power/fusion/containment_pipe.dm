/obj/machinery/atmospherics/pipe/containment_pipe
	name = "Fusion Plasma Containment Pipe"
	desc = "A pipe with coiling to shape a magnetic field."
	icon = 'icons/obj/fusion_engine/containment_pipe.dmi'
	//icon_state = 'pipe_straight'
	density = 1
	
	//Balancing vars
	var/radiation_multiplier = 1
	var/thermal_multiplier = 1
	
	//Upgradeable vars
	var/max_durability = 0
	var/max_capacity = 0 //Calculated based on speed of internal plasma and upgrades
	var/internal_hr = 0 //How hot the fusion plasma can be before damage, hr = heat resistance
	var/external_hr = 0 //How hot the containment room can be before damage

	//Process vars
	var/durability = 0
	var/speed = 0
	var/used_capacity = 0
	var/radiation_output = 0 //How much radiation is being created
	var/thermal_output = 0 //How much heat is being created