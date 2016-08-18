/datum/star_system
	var/name = ""
	var/x = 0
	var/y = 0
	var/list/planets = list()
	var/datum/planet/navbeacon
	var/z_level_available = 3
	var/alignment = "unaligned"
	var/visited = 0

	var/list/ships = list()

	var/danger_level = 0
	var/capital_planet = 0

/datum/star_system/proc/generate()
	name = generate_star_name()
	var/valid_coords = 0
	while(!valid_coords)
		generate_coords()
		valid_coords = 1
		for(var/datum/star_system/other in SSstarmap.star_systems)
			if(other == src)
				continue
			if(dist(other) <= 2)
				valid_coords = 0
				break

	// Generate planets
	navbeacon = new(src)
	navbeacon.location_description = "At the "
	navbeacon.goto_action = "Jump to navbeacon"
	navbeacon.name = "nav beacon"
	navbeacon.z_level = 1

	for(var/I in 1 to rand(1, 9))
		var/datum/planet/P = new(src)
		z_level_available++
		P.generate(I)
		if(z_level_available > 11) // We are out of real estate.
			break
	navbeacon.disp_level = planets.len
	for(var/datum/planet/P in planets)
		//P.disp_dist = 0.1 * ((10 ^ (1/planets.len)) ^ P.disp_level)
		P.disp_dist = 0.25 * (4 ** (P.disp_level/planets.len))*1.3333 - 0.3333
		P.disp_x = cos(P.disp_angle) * P.disp_dist
		P.disp_y = sin(P.disp_angle) * P.disp_dist

/datum/star_system/proc/get_planet_for_z(z)
	for(var/datum/planet/P in planets)
		if(P.z_level == z)
			return P

/datum/star_system/proc/generate_coords()
	x = rand(0, 1000) / 10
	y = rand(0, 1000) / 10

/datum/star_system/proc/dist(datum/star_system/other)
	var/dx = other.x - x
	var/dy = other.y - y
	return sqrt((dx * dx) + (dy * dy))

/datum/star_system/proc/lerp_x(datum/star_system/other, t)
	return x + (t * (other.x - x))

/datum/star_system/proc/lerp_y(datum/star_system/other, t)
	return y + (t * (other.y - y))

/datum/planet // Not necessarily a planet. If you don't like that it's called this, FUCK YOU.
	var/name = ""
	var/location_description = "In orbit around "
	var/goto_action = "Enter orbit"
	var/datum/star_system/parent_system
	var/list/rings_composition
	var/z_level = -1
	var/list/docks = list()
	var/obj/docking_port/stationary/main_dock
	var/map_prefix = "_maps/ship_encounters/"
	var/map_name = "empty_space.dmm"
	var/spawn_ruins = 1
	var/planet_type = "Planet"
	var/disp_x = 0
	var/disp_y = 0
	var/disp_angle = 0
	var/disp_level = 0
	var/disp_dist = 0
	var/datum/space_station/station
	var/keep_loaded = 0 // Adminbus var to keep planet loaded

/datum/planet/New(p_system)
	parent_system = p_system
	parent_system.planets += src

/datum/planet/proc/do_unload()
	// Should this planet be unloaded?
	if(keep_loaded)
		return 0

	// Active telecomms relays keep this z-level loaded.
	for(var/obj/machinery/telecomms/relay/R in telecomms_list)
		if(R.z == z_level && R.on)
			return 0
	return 1

/datum/planet/proc/generate(var/index)
	name = "[parent_system.name] [index]"
	disp_level = index
	disp_angle = rand(0, 360)
	if(prob(30))
		planet_type = "Ringed [planet_type]"
		// Rings!
		map_name = "rings.dmm"

		// Composition of rings
		rings_composition = list()
		var/minerals_left = list(
			/turf/closed/mineral/uranium = 5, /turf/closed/mineral/diamond = 1, /turf/closed/mineral/gold = 10,
			/turf/closed/mineral/silver = 12, /turf/closed/mineral/plasma = 20, /turf/closed/mineral/iron = 40,
			/turf/closed/mineral/bscrystal = 1)
		var/chance_left = 100
		var/amount = 0
		while(chance_left > 0)
			amount++
			var/chance
			if(amount > 2 && prob(70))
				chance = chance_left
			else
				chance = rand(1, chance_left)
			chance_left -= chance
			var/mineral = pickweight(minerals_left)
			minerals_left -= mineral
			rings_composition[mineral] = chance
	else if(prob(50))
		station = new(src)
		map_name = "station.dmm"

/datum/planet/proc/name_dock(var/obj/docking_port/stationary/D, var/id)
	if(id == "main")
		D.name = "[location_description][name]"
	else if(id == "trade")
		D.name = "[name] Orbital Platform"

/datum/space_station
	var/list/stock = list()
	var/datum/planet/planet

/datum/space_station/New(var/datum/planet/P)
	planet = P

/datum/space_station/proc/generate()
	// TODO: Implement a more sophisticated way of generating station stocks.
	for(var/I in 1 to rand(5, 15))
		var/datum/supply_pack/P = SSshuttle.supply_packs[pick(SSshuttle.supply_packs)]
		if(P in stock)
			stock[P] += rand(1, 5)
		else
			stock[P] = rand(1, 5)
