/obj/machinery/computer/cargo
	name = "supply console"
	desc = "Used to order supplies, approve requests, and control the shuttle."
	icon_screen = "supply"
	circuit = /obj/item/weapon/circuitboard/computer/cargo
	var/requestonly = FALSE
	var/contraband = FALSE
	var/safety_warning = "For safety reasons the automated supply shuttle \
		cannot transport live organisms, classified nuclear weaponry or \
		homing beacons."

	light_color = "#E2853D"//orange

/obj/machinery/computer/cargo/request
	name = "supply request console"
	desc = "Used to request supplies from cargo."
	icon_screen = "request"
	circuit = /obj/item/weapon/circuitboard/computer/cargo/request
	requestonly = TRUE

/obj/machinery/computer/cargo/New()
	..()
	var/obj/item/weapon/circuitboard/computer/cargo/board = circuit
	contraband = board.contraband
	emagged = board.emagged

/obj/machinery/computer/cargo/proc/check_sensitivity(var/datum/supply_pack/P) // Return true if item is too sensitive for system
	var/datum/planet/PL = SSstarmap.current_system.get_planet_for_z(z)
	if(!PL)
		return 0
	var/datum/star_system/S = PL.parent_system
	var/H = SSship.check_hostilities(S.alignment,"ship")
	if(H == 1)
		return 0
	else if(H == 0 && P.sensitivity >= 1)
		return 1
	else if(P.sensitivity >= 2)
		return 1

proc/get_cost_multiplier(var/datum/planet/PL)
	if(!PL)
		PL = SSstarmap.current_planet
	if(!PL)
		return 0
	var/datum/star_system/S = PL.parent_system
	var/H = SSship.check_hostilities(S.alignment,"ship")

	switch(H)
		if(1)
			return 1
		if(-1)
			return 1.5
		if(0)
			return 5 // Buying things from the syndicate is quite expensive if you're a nanotrasen vessel

/obj/machinery/computer/cargo/emag_act(mob/living/user)
	if(emagged)
		return
	user.visible_message("<span class='warning'>[user] swipes a suspicious card through [src]!",
	"<span class='notice'>You adjust [src]'s routing and receiver spectrum, unlocking special supplies and contraband.</span>")

	emagged = TRUE
	contraband = TRUE

	// This also permamently sets this on the circuit board
	var/obj/item/weapon/circuitboard/computer/cargo/board = circuit
	board.contraband = TRUE
	board.emagged = TRUE

/obj/machinery/computer/cargo/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, \
											datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "cargo", name, 1000, 800, master_ui, state)
		ui.open()

/obj/machinery/computer/cargo/ui_data()
	var/datum/planet/PL = SSstarmap.current_planet
	if(!PL)
		return list()
	var/datum/space_station/station = PL.station
	var/list/data = list()
	data["station_name"] = station.module.name

	data["requestonly"] = requestonly
	data["points"] = SSshuttle.points

	if(station)
		data["at_station"] = 1
	else
		data["at_station"] = 0

	if(station)
		data["supplies"] = list()
		for(var/thing in station.stock)
			var/datum/supply_pack/P = SSshuttle.supply_packs[thing]
			if(!data["supplies"][P.group])
				data["supplies"][P.group] = list(
					"name" = P.group,
					"packs" = list()
				)
			if((P.hidden && !emagged) || (P.contraband && !contraband) || (check_sensitivity(P)))
				continue
			data["supplies"][P.group]["packs"] += list(list(
				"name" = P.name,
				"cost" = P.cost,
				"id" = P.type,
				"stock" = station.stock[thing]
			))

	data["cart"] = list()
	for(var/datum/supply_order/SO in SSshuttle.shoppinglist)
		data["cart"] += list(list(
			"object" = SO.pack.name,
			"cost" = SO.pack.cost,
			"id" = SO.id
		))

	data["requests"] = list()
	for(var/datum/supply_order/SO in SSshuttle.requestlist)
		data["requests"] += list(list(
			"object" = SO.pack.name,
			"cost" = SO.pack.cost,
			"orderer" = SO.orderer,
			"reason" = SO.reason,
			"id" = SO.id
		))

	if(station)
		var/turf/sell_turf
		for(var/obj/effect/landmark/L in GLOB.landmarks_list)
			if(L.name == "ftltrade_sell" && L.z == z)
				sell_turf = get_turf(L)
				break
		if(sell_turf)
			data["sell"] = list()
			for(var/obj/O in sell_turf.contents)
				if(O.invisibility >= INVISIBILITY_ABSTRACT || O.anchored)
					continue
				var/price = export_item_and_contents(O, contraband, emagged, dry_run=TRUE)
				if(!price)
					continue
				if(price == UNSELLABLE_ITEM) //Are we trying to sell a blacklisted item?
					data["sell"] += list(list(
						"name" = O.name+" - Unable to sell due to trade restrictions. Please check item/contents and try again",
						"cost" = "Unable to sell for",
						"id" = ""
						))
				else
					data["sell"] += list(list(
						"name" = O.name,
						"cost" = price,// / cost_mult,
						"id" = "\ref[O]"
					))

	return data

/obj/machinery/computer/cargo/ui_act(action, params, datum/tgui/ui)
	if(..())
		return
	if(action != "add" && requestonly)
		return
	switch(action)
		if("send")
			buy()
			. = TRUE
		if("sell")
			var/obj/O = locate(params["id"])
			if(!istype(O))
				return
			if(O.invisibility >= INVISIBILITY_ABSTRACT || O.anchored)
				return
			sell(O)
			. = TRUE
		if("add")
			var/id = text2path(params["id"])
			var/datum/supply_pack/pack = SSshuttle.supply_packs[id]
			if(!istype(pack))
				return
			if((pack.hidden && !emagged) || (pack.contraband && !contraband))
				return

			var/name = "*None Provided*"
			var/rank = "*None Provided*"
			var/ckey = usr.ckey
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				name = H.get_authentification_name()
				rank = H.get_assignment()
			else if(issilicon(usr))
				name = usr.real_name
				rank = "Silicon"

			var/reason = ""
			if(requestonly)
				reason = input("Reason:", name, "") as text|null
				if(isnull(reason) || ..())
					return

			var/turf/T = get_turf(src)
			var/datum/supply_order/SO = new(pack, name, rank, ckey, reason)
			SO.generateRequisition(T)
			if(requestonly)
				SSshuttle.requestlist += SO
			else
				SSshuttle.shoppinglist += SO
			. = TRUE
		if("remove")
			var/id = text2num(params["id"])
			for(var/datum/supply_order/SO in SSshuttle.shoppinglist)
				if(SO.id == id)
					SSshuttle.shoppinglist -= SO
					. = TRUE
					break
		if("clear")
			SSshuttle.shoppinglist.Cut()
			. = TRUE
		if("approve")
			var/id = text2num(params["id"])
			for(var/datum/supply_order/SO in SSshuttle.requestlist)
				if(SO.id == id)
					SSshuttle.requestlist -= SO
					SSshuttle.shoppinglist += SO
					. = TRUE
					break
		if("deny")
			var/id = text2num(params["id"])
			for(var/datum/supply_order/SO in SSshuttle.requestlist)
				if(SO.id == id)
					SSshuttle.requestlist -= SO
					. = TRUE
					break
		if("denyall")
			SSshuttle.requestlist.Cut()
			. = TRUE
	if(.)
		post_signal("supply")

/obj/machinery/computer/cargo/proc/buy()
	var/datum/space_station/station = SSstarmap.current_planet.station
	if(!station)
		return

	if(!SSshuttle.shoppinglist.len)
		return
	var/turf/buy_turf
	for(var/obj/effect/landmark/L in GLOB.landmarks_list)
		if(L.name == "ftltrade_buy" && L.z == z)
			buy_turf = get_turf(L)
			break
	if(!buy_turf)
		return

	var/value = 0
	var/purchases = 0
	for(var/datum/supply_order/SO in SSshuttle.shoppinglist)
		if(SO.pack.cost > SSshuttle.points)
			continue
		var/path = SO.pack.type
		if(!(path in station.stock) || (station.stock[path] < 1 && station.stock[path] != -1))
			continue

		SSshuttle.points -= SO.pack.cost
		value += SO.pack.cost
		SSshuttle.shoppinglist -= SO
		SSshuttle.orderhistory += SO

		if(station.stock[SO.pack] > 0) //anything above 0
			station.stock[SO.pack]--
		SO.generate(buy_turf)
		SSblackbox.add_details("cargo_imports",
			"[SO.pack.type]|[SO.pack.name]|[SO.pack.cost]")
		investigate_log("Order #[SO.id] ([SO.pack.name], placed by [key_name(SO.orderer_ckey)]) has shipped.", "cargo")
		if(SO.pack.dangerous)
			message_admins("\A [SO.pack.name] ordered by [key_name_admin(SO.orderer_ckey)] has shipped.")
		purchases++

	investigate_log("[purchases] orders in this shipment, worth [value] credits. [SSshuttle.points] credits left.", "cargo")

/obj/machinery/computer/cargo/proc/sell(obj/I)
	export_item_and_contents(I, contraband, emagged, dry_run = FALSE)

	for(var/a in GLOB.exports_list)
		var/datum/export/E = a
		var/export_text = E.total_printout()
		if(!export_text)
			continue

		//msg += export_text + "\n"
		SSshuttle.points += E.total_cost
		E.export_end()

/proc/recalculate_prices(var/datum/space_station/station)
	var/datum/station_module/module = station.module
	var/faction_mult = get_cost_multiplier()

	for(var/thing in SSshuttle.supply_packs)
		var/datum/supply_pack/pack = SSshuttle.supply_packs[thing]
		pack.cost = initial(pack.cost)	//resets the price so you don't get infinitely scaling prices
		for(var/keyword in module.buy_keywords)
			if(pack.cost_modifiers && keyword in pack.cost_modifiers)
				pack.cost *= module.buy_keywords[keyword]
		pack.cost *= faction_mult
		CHECK_TICK

	for(var/thing in GLOB.exports_list)
		var/datum/export/export = thing
		export.cost = initial(export.cost)
		for(var/keyword in module.sell_keywords)
			if(export.cost_modifiers && keyword in export.cost_modifiers)
				export.cost *= module.sell_keywords[keyword]
		CHECK_TICK

		export.cost /= faction_mult  //syndies won't pay much for your shit, though they will still prefer things by module
		export.init_cost = export.cost

	SSshuttle.has_calculated = TRUE

/obj/machinery/computer/cargo/proc/post_signal(command)

	var/datum/radio_frequency/frequency = SSradio.return_frequency(1435)

	if(!frequency)
		return

	var/datum/signal/status_signal = new
	status_signal.source = src
	status_signal.transmission_method = 1
	status_signal.data["command"] = command

	frequency.post_signal(src, status_signal)
