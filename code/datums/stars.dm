/datum/star_system
	var/name = ""
	var/x = 0
	var/y = 0
	var/list/planets = list()
	var/alignment = "unaligned"
	var/visited = 0

	var/list/ships = list()

	var/danger_level = 0
	var/capital_planet = 0

	var/PathNode/PNode = null //for pathfinding

	var/datum/space_station/primary_station = null

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

	for(var/I in 1 to rand(1, 9))
		var/datum/planet/P = new(src)
		P.generate(I)

	for(var/datum/planet/P in planets)
		//P.disp_dist = 0.1 * ((10 ^ (1/planets.len)) ^ P.disp_level)
		P.disp_dist = 0.25 * (4 ** (P.disp_level/planets.len))*1.3333 - 0.3333
		P.disp_x = cos(P.disp_angle) * P.disp_dist
		P.disp_y = sin(P.disp_angle) * P.disp_dist

/datum/star_system/proc/get_planet_for_z(z)
	for(var/datum/planet/P in planets)
		if(z in P.z_levels)
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
	var/list/z_levels = list()
	var/list/docks = list()
	var/list/icon_layers = list()
	var/obj/docking_port/stationary/main_dock
	var/list/map_names = list("empty_space.dmm")
	var/spawn_ruins = 1
	var/planet_type = "Planet"
	var/disp_x = 0
	var/disp_y = 0
	var/disp_angle = 0
	var/disp_level = 0
	var/disp_dist = 0
	var/ringed = 0
	var/datum/space_station/station
	var/datum/board_ship/board
	var/keep_loaded = 0 // Adminbus var to keep planet loaded
	var/surface_area_type
	var/surface_turf_type
	var/resource_type
	var/nav_icon_name = "gas"
	var/no_unload_reason = ""

/datum/planet/New(p_system)
	parent_system = p_system
	parent_system.planets += src

/datum/planet/proc/do_unload()
	if(!main_dock)
		no_unload_reason = ""
		return 1

	// Active telecomms relays keep this z-level loaded.
	for(var/obj/machinery/telecomms/relay/R in telecomms_list)
		if(!istype(R.loc.loc, /area/shuttle/ftl) && (R.z in z_levels) && R.on)
			no_unload_reason = "RELAY"
			return 0

	if(keep_loaded)
		no_unload_reason = ""
		return 0

	no_unload_reason = ""
	return 1

/datum/planet/proc/generate(var/index, var/list/predefs)
	if(!predefs)
		predefs = list()
	name = "[parent_system.name] [index]"
	disp_level = index
	disp_angle = rand(0, 360)
	map_names = list()
	if(!predefs["norings"] && (prob(30) || predefs["rings"]))
		ringed = 1
		// Rings!
		map_names += "rings.dmm"
		icon_layers += "p_rings_under"

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
	else if(!predefs["nostation"] && (prob(50) || predefs["station"]))
		station = new(src)
		map_names += pick("station.dmm", "station2.dmm")
	else
		map_names += "empty_space.dmm"


	if(!predefs["nosurface"] && (prob(50) || predefs["surface"]))
		switch(predefs["surface"] ? predefs["surface"] : rand(1, 130))
			if(1 to 50)
				var/datum/planet_loader/loader = new /datum/planet_loader("lavaland.dmm")
				loader.ruins_args = list(config.lavaland_budget, /area/lavaland/surface/outdoors, lava_ruins_templates)
				map_names += loader
				planet_type = "Lava Planet"
				surface_turf_type = /turf/open/floor/plating/asteroid/basalt/lava_land_surface
				surface_area_type = /area/lavaland/surface/outdoors
				resource_type = "iron"
				nav_icon_name = "lava"
				icon_layers += "p_lava"

			if(51 to 100)
				var/datum/planet_loader/loader = new /datum/planet_loader("icy_planet.dmm")
				map_names += loader
				planet_type = "Icy Planet"
				surface_turf_type = /turf/open/floor/plating/asteroid/snow/surface
				surface_area_type = /area/space
				resource_type = "silicon"
				nav_icon_name = "icy"
				icon_layers += "p_icy"

			if(101 to 130)
				var/datum/planet_loader/loader = new /datum/planet_loader/earthlike("earthlike.dmm")
				map_names += loader
				planet_type = "Habitable Exoplanet"
				surface_turf_type = /turf/open/floor/plating/asteroid/planet/sand
				surface_area_type = /area/space
				resource_type = "hyper"
				nav_icon_name = "habitable"
				icon_layers += "p_earthlike"
				icon_layers += "p_earthlike_overlay"
				icon_layers["p_earthlike_overlay"] = loader.plant_color
	else
		planet_type = "Gas Giant"
		icon_layers += "p_gas"

	if(ringed)
		planet_type = "Ringed [planet_type]"
		icon_layers += "p_rings_over"

/datum/planet/proc/name_dock(var/obj/docking_port/stationary/D, var/id, var/params = null)
	if(id == "main")
		D.name = "[location_description][name]"
	else if(id == "trade")
		D.name = "[name] Orbital Platform"
	else if(id == "land")
		D.name = "Surface of [name]"
		D.turf_type = surface_turf_type
		D.area_type = surface_area_type
	else if(id == "board")
		D.name = "Ship Wreckage"

/datum/board_ship
	var/datum/planet/planet

/datum/board_ship/New(var/datum/planet/P)
	planet = P
	SSstarmap.wreckages += src

/datum/space_station
	var/list/stock = list()
	var/datum/planet/planet

	var/list/resources = list()
	var/list/prices = list()

	var/list/reserved_resources = list()

	var/primary_resource
	var/is_primary = 0


/datum/space_station/New(var/datum/planet/P)
	planet = P
	SSstarmap.stations += src

/datum/space_station/proc/generate()
	// TODO: Implement a more sophisticated way of generating station stocks.

	stock[SSshuttle.supply_packs[/datum/supply_pack/munitions/he]] = rand(1,10)
	if(prob(33))
		stock[SSshuttle.supply_packs[/datum/supply_pack/munitions/sp]] = rand(1,10)
	else if(prob(50))
		stock[SSshuttle.supply_packs[/datum/supply_pack/munitions/sh]] = rand(1,10)

	stock[SSshuttle.supply_packs[/datum/supply_pack/gas/o2]] = rand(1,8)
	stock[SSshuttle.supply_packs[/datum/supply_pack/gas/n2]] = rand(1,2)
	stock[SSshuttle.supply_packs[/datum/supply_pack/gas/plasma]] = rand(1,5)
	stock[SSshuttle.supply_packs[/datum/supply_pack/misc/space_yellow_pages]] = rand(1,5)

	for(var/I in 1 to rand(5, 15))
		var/datum/supply_pack/P = SSshuttle.supply_packs[pick(SSshuttle.supply_packs)]
		if(P in stock)
			stock[P] += rand(1, 5)
		else
			stock[P] = rand(1, 5)

/datum/star_system/capital
	danger_level = 8
	capital_planet = 1

/datum/star_system/capital/nanotrasen
	x = 25
	y = 40
	alignment = "nanotrasen"

/datum/star_system/capital/solgov
	name = "Sol"
	x = 70
	y = 45
	alignment = "solgov"

/datum/star_system/capital/syndicate
	name = "Dolos"
	x = 28
	y = 70
	alignment = "syndicate"

/datum/star_system/capital/generate()
	if(!name)
		name = generate_star_name()
	for(var/I in 1 to rand(1, 9))
		var/datum/planet/P = new(src)
		var/list/predefs = list()
		if(I == 1)
			predefs["surface"] = 101
			predefs["norings"] = 1
			predefs["station"] = 1
		P.generate(I, predefs)
	for(var/datum/planet/P in planets)
		//P.disp_dist = 0.1 * ((10 ^ (1/planets.len)) ^ P.disp_level)
		P.disp_dist = 0.25 * (4 ** (P.disp_level/planets.len))*1.3333 - 0.3333
		P.disp_x = cos(P.disp_angle) * P.disp_dist
		P.disp_y = sin(P.disp_angle) * P.disp_dist
