/datum/star_resource
	var/name = "fire the coders"
	var/cname = "resource"

	var/scale_price = 100000
	var/scale_weight = 500


/datum/star_resource/iron
	name = "iron ore"
	cname = "iron"

	scale_price = 40000
	scale_weight = 2000

/datum/star_resource/hyperlite
	name = "hyperlite crystals"
	cname = "hyper"

	scale_price = 200000
	scale_weight = 150

/datum/star_resource/silicon
	name = "silicate ore"
	cname = "silicon"

	scale_price = 60000
	scale_weight = 1000

/datum/controller/subsystem/starmap/proc/cname2resource(var/cname)
	for(var/datum/star_resource/resource in star_resources)
		if(resource.cname == cname)
			return resource

/datum/controller/subsystem/starmap/proc/generate_galactic_prices()
	var/list/galactic_supply = list()
	var/list/galactic_producers = list()
	for(var/datum/star_system/system in star_systems)
		if(!system.primary_station)
			continue
		for(var/resource in system.primary_station.resources)
			if(galactic_supply.Find(resource))
				galactic_supply[resource] += system.primary_station.resources[resource]
				galactic_producers[resource] += 1
			else
				galactic_supply[resource] = system.primary_station.resources[resource]
				galactic_producers[resource] = 1

	for(var/datum/star_resource/R in star_resources)
		var/supply = galactic_supply[R.cname]
		var/producers = galactic_producers[R.cname]

		if(!supply || !producers)
			galactic_prices[R.cname] = "ERROR"
			continue

		galactic_prices[R.cname] = round(R.scale_price / (supply / producers),0.01) //cents only yo


/datum/controller/subsystem/starmap/proc/generate_system_prices(var/datum/star_system/system)
	if(!system.primary_station)
		return
	for(var/resource in system.primary_station.resources)
		var/datum/star_resource/R = cname2resource(resource)
		if(!R)
			continue
		if(resource == system.primary_station.primary_resource)
			system.primary_station.prices[resource] = round(min(PRICE_CAP,(R.scale_price / system.primary_station.resources[resource])),0.01)
		else
			system.primary_station.prices[resource] = round(min(PRICE_CAP,((R.scale_price / system.primary_station.resources[resource] + galactic_prices[resource]) / 2)),0.01)

/datum/controller/subsystem/starmap/proc/generate_faction_prices(var/datum/star_faction/faction)
	for(var/resource in faction.resources)
		var/datum/star_resource/R = cname2resource(resource)
		if(!R)
			continue

		faction.prices[resource] = round(min(PRICE_CAP,(R.scale_price / faction.resources[resource])),0.01)



var/last_economy_tick = -18000

/datum/controller/subsystem/starmap/proc/process_economy()
	if(world.time > last_economy_tick +18000)
		do_economy_tick()
		last_economy_tick = world.time

	if(!initial_report)
		initial_report = 1

		news_network.SubmitArticle(get_economy_news(),"Galactic News Agency","Galactic News Network")


	generate_galactic_prices()
	for(var/datum/star_faction/faction in SSship.star_factions)
		if(faction.no_economy)
			continue

		if(!faction.ship_to_build)
			var/list/f_list = SSship.faction2list(faction.cname)
			while(!faction.ship_to_build) //this really needs to be its own proc
				faction.ship_to_build = pick(f_list)
				if(faction.ship_to_build.operations_type)
					faction.ship_to_build = null
				if(!prob(f_list[faction.ship_to_build]))
					faction.ship_to_build = null

		attempt_to_build(faction)
		if(faction.money < faction.spend_limit)
			continue

		var/list/freighters = list()

		for(var/datum/starship/S in faction.ships)
			if(S.operations_type && S.mission_ai.cname == "MISSION_IDLE")
				freighters += S

		while(faction.money > faction.spend_limit)
			if(!freighters.len)
				break

			var/datum/starship/active_freighter = pick(freighters)

			var/resource_to_find = get_scarce_resource(faction)

			var/datum/space_station/target_station = get_cheapest_station(faction,resource_to_find)

			if(!target_station)
				break

			var/spend_amount = active_freighter.cargo_limit * target_station.prices[resource_to_find]
			if(faction.money - spend_amount < faction.credit_limit)
				break
			faction.b_money += spend_amount
			faction.money -= spend_amount

			if(!target_station.reserved_resources.Find(resource_to_find)) //for simplicity we'll go a few hundred past what the station actually has and not deal with dividing by 0
				target_station.reserved_resources[resource_to_find] = active_freighter.cargo_limit
			else
				target_station.reserved_resources[resource_to_find] += active_freighter.cargo_limit

			if(!faction.incoming_resources.Find(resource_to_find)) //for simplicity we'll go a few hundred past what the station actually has and not deal with dividing by 0
				faction.incoming_resources[resource_to_find] = active_freighter.cargo_limit
			else
				faction.incoming_resources[resource_to_find] += active_freighter.cargo_limit

			target_station.resources[resource_to_find] = max(1,target_station.resources[resource_to_find] - active_freighter.cargo_limit) //max(1,...) because fuck dividing by 0
			generate_system_prices(target_station.planet.parent_system)

			active_freighter.mission_ai = new /datum/ship_ai/trade
			active_freighter.mission_ai:resource = resource_to_find
			active_freighter.mission_ai:exchange_amount = spend_amount
			active_freighter.mission_ai:sell_faction = faction
			active_freighter.mission_ai:buy_station = target_station

			freighters -= active_freighter


	var/list/sell_freighters = list()

	for(var/datum/starship/ship in SSship.ships) //this needs to be separate because the list needs to be randomized
		if(ship.operations_type && ship.mission_ai.cname == "MISSION_IDLE")
			var/datum/star_faction/faction = SSship.cname2faction(ship.faction)
			if(faction.money > faction.spend_limit)
				continue
			sell_freighters += ship

	if(!sell_freighters.len)
		return

	sell_freighters = shuffle(sell_freighters)

	for(var/datum/starship/sell_freighter in sell_freighters)
		var/datum/star_resource/sell_resource = pick(star_resources) //Finding the cheapest resource will spam factions with lowgrade shit, and going through their needs is a bit pricey

		var/datum/space_station/target_station = get_cheapest_station(SSship.cname2faction(sell_freighter.faction),sell_resource.cname)
		var/datum/star_faction/ship_faction = SSship.cname2faction(sell_freighter.faction)
		var/datum/star_faction/faction = get_best_faction(ship_faction,sell_resource.cname)

		if(faction.money < faction.spend_limit)
			faction = null //if the faction can't afford your cash grab, move on
			continue

		if(!target_station || !faction)
			continue

		var/spend_amount = sell_freighter.cargo_limit * target_station.prices[sell_resource]
		ship_faction.b_money += spend_amount
		ship_faction.money -= spend_amount

		faction.s_money += spend_amount
		faction.money -= spend_amount

		if(!target_station.reserved_resources.Find(sell_resource)) //for simplicity we'll go a few hundred past what the station actually has and not deal with dividing by 0
			target_station.reserved_resources[sell_resource] = sell_freighter.cargo_limit
		else
			target_station.reserved_resources[sell_resource] += sell_freighter.cargo_limit

		if(!faction.incoming_resources.Find(sell_resource)) //for simplicity we'll go a few hundred past what the station actually has and not deal with dividing by 0
			faction.incoming_resources[sell_resource] = sell_freighter.cargo_limit
		else
			faction.incoming_resources[sell_resource] += sell_freighter.cargo_limit


		target_station.resources[sell_resource] = max(1,target_station.resources[sell_resource] - sell_freighter.cargo_limit) //max(1,...) because fuck dividing by 0
		generate_system_prices(target_station.planet.parent_system)

		sell_freighter.mission_ai = new /datum/ship_ai/trade
		sell_freighter.mission_ai:resource = sell_resource
		sell_freighter.mission_ai:exchange_amount = spend_amount
		sell_freighter.mission_ai:sell_faction = faction
		sell_freighter.mission_ai:buy_station = target_station


/datum/controller/subsystem/starmap/proc/attempt_to_build(var/datum/star_faction/faction)
	if(!(world.time > faction.next_build_time))
		return

	if(faction.money < SHIP_BUILD_PRICE)
		return

	for(var/resource in faction.ship_to_build.build_resources) //make sure we can build the thing
		if(!faction.resources.Find(resource))
			return
		if(faction.resources[resource] < faction.ship_to_build.build_resources[resource])
			return

		faction.resources[resource] = max(1,faction.resources[resource] - faction.ship_to_build.build_resources[resource])


	SSship.create_ship(faction.ship_to_build,faction.cname,faction.capital)

	faction.ship_to_build = null

	faction.money -= SHIP_BUILD_PRICE

	generate_faction_prices(faction)

	faction.next_build_time = world.time + FACTION_BUILD_DELAY
	faction.building_fee += SHIP_BUILD_PRICE

/datum/controller/subsystem/starmap/proc/do_economy_tick()
	news_network.SubmitArticle(get_economy_news(),"Galactic News Agency","Galactic News Network")

	for(var/datum/star_faction/faction in SSship.star_factions)
		for(var/system in faction.systems)
			var/income = rand(500,1000)
			faction.money += income //would just do systems.len * rand(500,1000) but that'd be too much variation
			faction.tax_income += income




/datum/controller/subsystem/starmap/proc/get_economy_news()
	var/text

	text = "Galactic News Network Quarterly Economic Review:"
	text += "<BR><BR>Market Prices:"
	for(var/datum/star_resource/resource in star_resources)
		var/price = galactic_prices[resource.cname]
		text += "<BR>([resource.cname]) [price]k Cr / ton"

	text += "<BR><BR>Cheapest Mineral Suppliers:"
	for(var/datum/star_resource/resource in star_resources)
		var/datum/space_station/station = get_cheapest_station(SSship.cname2faction("solgov"),resource.cname)
		if(!station)
			continue
		var/datum/planet/planet = station.planet
		text += "<BR>Cheapest Supplier ([resource.cname]): [planet]"

	return text


/datum/controller/subsystem/starmap/proc/get_scarce_resource(var/datum/star_faction/faction)
	var/highest_weight
	var/weight = 0

	for(var/resource in faction.resources)
		var/datum/star_resource/stock = cname2resource(resource)

		if(!stock)
			continue

		if(!highest_weight)
			highest_weight = resource
			weight = (faction.resources[resource] + faction.incoming_resources[resource]) / stock.scale_weight

		else if(faction.resources[resource] / stock.scale_weight > weight)
			highest_weight = resource
			weight = (faction.resources[resource] + faction.incoming_resources[resource]) / stock.scale_weight

	return highest_weight

/datum/controller/subsystem/starmap/proc/get_cheapest_station(var/datum/star_faction/faction,var/resource)
	var/datum/space_station/best_deal
	var/price = 0

	if(!faction)
		return
	for(var/datum/space_station/station in stations)
		if(station.planet.parent_system.alignment == "unaligned")
			continue
		if(!SSship.check_hostilities(station.planet.parent_system.alignment,faction.cname) || !station.is_primary)
			continue

		if(!station.resources.Find(resource))
			continue

		if(!best_deal || station.resources[resource] < price)
			best_deal = station
			price = station.resources[resource]

	return best_deal

/datum/controller/subsystem/starmap/proc/get_best_faction(var/datum/star_faction/faction,var/resource)
	var/datum/space_station/best_deal
	var/price = 0

	for(var/datum/star_faction/faction_other in SSship.star_factions)
		if(!SSship.check_hostilities(faction_other.cname,faction.cname))
			continue

		if(!best_deal || faction.prices[resource] > price)
			best_deal = faction
			price = faction.prices[resource]

	return best_deal