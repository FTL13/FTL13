//Just some very basic defines

/obj/machinery/electromagnet
	name = "Central Electromagnet"
	desc = "A large cylindrical magnet used to generate a magnetic containment field."
	
	//Upgradeable vars
	var/max_speed = 0
	var/max_torque = 0
	var/precision = 0 //round to the nearest of this number when the user decides the speed and torque they want
	var/stability = 0 //used in determining coherence based on how much you're pushing it
	
	//Process vars
	var/speed = 0
	var/torque = 0
	var/coherence = 0 //the quality of the magnetic field, effects randomness and chance of error
	
/obj/machinery/containment_pipe
	name = "Fusion Plasma Containment Pipe"
	desc = "A pipe with coiling to shape a magnetic field."
	
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
	
	
/obj/machinery/containment_pipe/injector //The injector is must be constructed as part of the containment pipe loop
	name = "Fusion Plasma Injector"
	desc = "A block of machinery used in heating elements to form a plasma."
	
	//Upgradeable vars
	var/fuel_efficiency = 0 //How much fusion plasma can be made from one unit of fuel
	var/yield = 0 //How much fusion plasma can be made in one unit of time
	
	//Process vars
	var/remaining = 0 //How much fusion plasma remains to be made from this unit of fuel