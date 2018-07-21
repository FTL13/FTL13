/datum/star_system
	var/name = ""
	var/x = 0
	var/y = 0
	var/list/planets = list()
	var/alignment = "unaligned"
	var/visited = 0

	var/list/ships = list()
	var/datum/starship/forced_boarding //Used to force only one ship to be boardable at 100% chance

	var/danger_level = 0
	var/capital_planet = 0
	var/objective = FALSE

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
	var/planet_z_level = 0 //Mapping var for which item in map_names is a planet
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
	var/objective = FALSE


/datum/planet/New(p_system)
	parent_system = p_system
	parent_system.planets += src

/datum/planet/proc/do_unload()
	// Active telecomms relays keep this z-level loaded.
	for(var/obj/machinery/telecomms/relay/R in GLOB.telecomms_list)
		if(!istype(R.loc.loc, /area/shuttle/ftl) && (R.z in z_levels) && R.on && no_unload_reason == "")
			no_unload_reason = "RELAY"
			return 0

	if(keep_loaded)
		no_unload_reason = ""
		return 0

	if(no_unload_reason != "") //Anything in no_unload_reason, keep it loaded
		return 0

	if(!main_dock)
		no_unload_reason = ""
		return 1

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
		map_names += pick("stationnew.dmm")
	else
		map_names += "empty_space.dmm"


	if(!predefs["nosurface"] && (prob(50) || predefs["surface"]))
		switch(predefs["surface"] ? predefs["surface"] : rand(1, 130))
			if(1 to 50)
				var/datum/planet_loader/loader = new /datum/planet_loader("lavaland.dmm")
				loader.has_gravity = 1
				loader.ruins_args = list(config.lavaland_budget, /area/lavaland/surface/outdoors, SSmapping.lava_ruins_templates)
				map_names += loader
				planet_z_level = 2
				planet_type = "Lava Planet"
				surface_turf_type = /turf/open/floor/plating/asteroid/basalt/lava_land_surface
				surface_area_type = /area/lavaland/surface/outdoors
				resource_type = "iron"
				nav_icon_name = "lava"
				icon_layers += "p_lava"

			if(51 to 100)
				var/datum/planet_loader/loader = new /datum/planet_loader("icy_planet.dmm")
				loader.has_gravity = 1
				map_names += loader
				planet_z_level = 2
				planet_type = "Icy Planet"
				surface_turf_type = /turf/open/floor/plating/asteroid/snow/surface
				surface_area_type = /area/space
				resource_type = "silicon"
				nav_icon_name = "icy"
				icon_layers += "p_icy"

			if(101 to 130)
				var/datum/planet_loader/loader = new /datum/planet_loader/earthlike("earthlike.dmm")
				loader.has_gravity = 1
				map_names += loader
				planet_z_level = 2
				planet_type = "Habitable Exoplanet"
				surface_turf_type = /turf/open/floor/plating/asteroid/planet/sand
				surface_area_type = /area/lavaland/surface/outdoors/unexplored
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
		D.name = "[name] Orbital Platform" //Might want to add something here  later on to have (SCARAB FOB) and (AER FOB)
	else if(id == "land")
		D.name = "Surface of [name]"
		D.turf_type = surface_turf_type
		D.area_type = surface_area_type
		D.planet_dock = 1
	else if(id == "board")
		D.name = "Unidentified Wreckage"
		D.boarding = TRUE
		if(params)
			D.name = "Wrecks of [params]"

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

	var/datum/station_module/module
	var/dat

/datum/space_station/New(var/datum/planet/P)
	planet = P
	SSstarmap.stations += src


/datum/space_station/proc/generate(var/list/module_weights)
	// TODO: Implement a more sophisticated way of generating station stocks. // Done. Kill me.
	var/alignment = planet.parent_system.alignment
	for(var/I in SSshuttle.supply_packs)
		var/datum/supply_pack/pack = SSshuttle.supply_packs[I]
		var/probability = pack.base_chance_to_spawn
		for(var/keyword in module.buy_keywords)
			if(pack.chance_modifiers && keyword in pack.chance_modifiers)
				probability = pack.base_chance_to_spawn + pack.chance_modifiers[keyword]
		if(prob(probability))
			if(!pack.hidden)
				dat += "<br><b>[pack.name] ([pack.cost] credits)</b><br>"
			if(pack.min_amount_to_stock != -1 && pack.max_amount_to_stock)
				stock[I] = rand(pack.min_amount_to_stock, pack.max_amount_to_stock)
			else
				stock[I] = pack.min_amount_to_stock

			CHECK_TICK
			//handle the rest of the package information for this crate. god fuck this catalog who even fucking uses it
			if(pack.sensitivity == 2)
				dat += "<i>This crate is only available to [alignment] allies. "
			if(pack.sensitivity == 1)
				dat += "<i>This crate is not available to [alignment] enemies. "
			if(pack.sensitivity != 0)
				dat += "Distribution of this crate to restricted organizations could result in fines or criminal charges</i><br>"
			dat += "Contents: <br>"
			var/list/contents_bynumber = list()
			for(var/path in pack.contains)
				if(path in contents_bynumber)
					contents_bynumber[path] += 1
				else
					contents_bynumber[path] = 1
			for(var/path in contents_bynumber)
				var/atom/path_fuck_byond = path
				dat += "[contents_bynumber[path]]x [initial(path_fuck_byond.name)]"
				if(initial(path_fuck_byond.desc))
					dat += " - <i>[initial(path_fuck_byond.desc)]</i>"
				dat += "<br>"
				dat += "</font>"
		CHECK_TICK

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

/datum/station_module
	var/list/buy_keywords = list()		// Associated list of keywords and price modifiers. Price modifiers are multiplicative.
	var/list/sell_keywords = list()		// As above, but for players selling to the station.
	var/rarity = 50		// weight of a module to get picked.
	var/datum/space_station/station
	var/module_suffix = "Meta-Physical Object That Should Not Exist"		//suffix of a station. Flavortext!
	var/name		//actual constructed name; given as a list if you want a random pre generated name

/datum/station_module/New(var/datum/space_station/S)
	if(S)
		station = S
	if(station)
		buy_keywords[station.planet.parent_system.alignment] = 1 // faction is gotten for chance modifiers; actual faction price adjustment is done in recalculate_prices
	if(islist(name))
		name = pick(name)
	else if(!name)
		name = "[new_station_name()] ([module_suffix])"

/datum/station_module/toys
	buy_keywords = list("Ammo" = 1.25, "Toys" = 0.75, "Security" = 1.5)
	sell_keywords = list()
	module_suffix = "Toy Factory"

/datum/station_module/weaponry
	buy_keywords = list("Ammo"= 0.75, "Security" = 0.75, "Clothing"=  1, "Melee" = 1)
	sell_keywords = list("Security" = 0.5, "Material" = 1.25, "Salvage" = 1.25, "Robotics" = 1.5)
	module_suffix = "Arms Dealer"
	rarity = 30

/datum/station_module/emergency
	buy_keywords = list("Emergency" = 0.5, "Engineering" = 1, "Atmos" = 1)
	sell_keywords = list("Emergency" = 0.5)
	module_suffix = "First Responder Outpost"

/datum/station_module/medical
	buy_keywords = list("Medical" = 0.75, "Food" = 1, "Security" = 1.5)
	sell_keywords = list("Medical" = 0.75)
	module_suffix = "Space Hospital"
	rarity = 30

/datum/station_module/pizza_hut
	name = list("Pizza Mutt", "Father Johnson's", "Pete's Pizza Parlor")
	buy_keywords = list("Pizza"=1, "Food"=0.9)
	rarity = 20

/datum/station_module/food
	buy_keywords = list("Food" = 0.75, "Hydroponics" = 0.75, "Vending" = 0.75)
	sell_keywords = list("Food"=0.5, "Hydroponics" = 1.5)
	module_suffix = "Space Supermarket"

/datum/station_module/engineering
	buy_keywords = list("Engineering" = 0.75, "Supermatter" = 0.75, "Materials" = 1.5)
	sell_keywords = list("Material" = 1.5)
	module_suffix = "Repair station"

/datum/station_module/chop_shop
	buy_keywords = list("Engineering" = 1, "Vehicle" = 1, "Cargo" = 0.75)
	sell_keywords = list("Salvage" = 1.5)
	module_suffix = "Chop Shop"

/datum/station_module/clothes
	buy_keywords = list("Clothes" = 0.9)	//10% off! Come in now for the seasonal sale where we don't just mark things up before putting them on sale...
	module_suffix = "Clothing Store"

/datum/station_module/science
	buy_keywords = list("Science" = 0.75, "Security" = 1, "Weaponry" = 1, "Robotics" = 1)		//Wide selection, most isn't discounted
	sell_keywords = list("Science" = 1, "Material" = 1.5, "Hydroponics" = 1.25, "Robotics" = 0.75)
	module_suffix = "Research Station"

/datum/station_module/chaos
	rarity = 1
	buy_keywords = list("Ammo", "Toys", "Security", "Emergency", "Solgov", "Vehicle", "Clothes", "Science",
											"Atmos", "Robotics", "Supermatter", "Food", "Engineering", "Melee", "Cargo", "Medical",
											"Food", "Pizza", "Hydroponics", "Vending", "Materials")	//update this whenever you add a buy keyword!
	sell_keywords = list("Security", "Science",  "Emergency", "Medical", "Food", "Engineering", "Robotics",
											"Material", "Salvage", "Hydroponics") //update this whenever you add a sell keyword!
	name = "Knockoff Nicks' Knickknacks"

/datum/station_module/chaos/New()
	..()
	for(var/thing in buy_keywords)
		buy_keywords[thing] = rand(0.25, 1.25)
	for(var/thing in sell_keywords)
		sell_keywords[thing] = 0	// stops infinite money at a single station; selling things gives you a whopping 0 points!
