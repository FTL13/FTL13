/datum/star_system
	var/name = ""
	var/x = 0
	var/y = 0
	var/list/planets = list()
	var/datum/planet/navbeacon
	var/z_level_available = 3

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
		P.z_level = z_level_available
		z_level_available++
		P.generate(I)
		if(z_level_available > 11) // We are out of real estate.
			break

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
	var/z_level
	var/list/docks = list()
	var/obj/docking_port/stationary/main_dock
	var/map_prefix = "_maps/ship_encounters/"
	var/map_name = "empty_space.dmm"
	var/spawn_ruins = 1
	var/planet_type = "Planet"

/datum/planet/New(p_system)
	parent_system = p_system
	parent_system.planets += src

/datum/planet/proc/generate(var/index)
	name = "[parent_system.name] [index]"
	if(prob(30))
		planet_type = "Ringed [type]"
		// Rings!
		map_name = "rings.dmm"
		spawn_ruins = 0
		
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

/datum/planet/proc/name_dock(var/obj/docking_port/stationary/D)
	D.name = "[location_description][name]"