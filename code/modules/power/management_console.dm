/obj/machinery/computer/pmanagement
  name = "power management console"
  desc = "From this console, you can transfer power from and to areas."
  icon_screen = "power"
  icon_keyboard = "power_key"
  use_power = 2
  idle_power_usage = 20
  active_power_usage = 100
  circuit = /obj/item/weapon/circuitboard/computer/pmanagement
  var/uiscreen = 1
  var/used = 0
  var/obj/structure/cable/attached

/obj/machinery/computer/pmanagement/New()
	..()
	search()

/obj/machinery/computer/pmanagement/process()
  if(!attached)
    use_power = 1
    search()
  else
    use_power = 2

/obj/machinery/computer/pmanagement/proc/search()
	var/turf/T = get_turf(src)
	attached = locate() in T

/obj/machinery/computer/pmanagement/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, \
											datum/tgui/master_ui = null, datum/ui_state/state = default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "power_management", name, 1200, 1000, master_ui, state)
		ui.open()

/obj/machinery/computer/pmanagement/ui_data()
	var/list/data = list()
	if(SSstarmap.ftl_drive)
		data["has_drive"] = 1
		if(SSstarmap.ftl_drive.can_jump())
			data["drive_status"] = "Fully charged, ready for interstellar jump"
			data["drive_class"] = "good"
		else if(SSstarmap.ftl_drive.can_jump_planet() && (SSstarmap.ftl_drive.charging_power || SSstarmap.ftl_drive.charging_plasma))
			data["drive_status"] = "Charging, ready for interplanetary jump"
			data["drive_class"] = "average"
		else if(SSstarmap.ftl_drive.can_jump_planet())
			data["drive_status"] = "Not charging, ready for interplanetary jump"
			data["drive_class"] = "average"
		else if(SSstarmap.ftl_drive.charging_power || SSstarmap.ftl_drive.charging_plasma)
			data["drive_status"] = "Charging, not ready for jump"
			data["drive_class"] = "average"
		else if(SSstarmap.ftl_drive.stat & BROKEN)
			data["drive_status"] = "Broken"
			data["drive_class"] = "bad"
		else
			data["drive_status"] = "Not charging, not ready for jump"
			data["drive_class"] = "bad"
		data["drive_plasma_charge"] = SSstarmap.ftl_drive.plasma_charge
		data["drive_plasma_charge_max"] = SSstarmap.ftl_drive.plasma_charge_max
		data["drive_charging_plasma"] = SSstarmap.ftl_drive.charging_plasma
		data["drive_power_charge"] = SSstarmap.ftl_drive.power_charge
		data["drive_power_charge_max"] = SSstarmap.ftl_drive.power_charge_max
		data["drive_charging_power"] = SSstarmap.ftl_drive.charging_power
		data["drive_charge_rate"] = SSstarmap.ftl_drive.charge_rate
		data["drive_charge_rate"] = SSstarmap.ftl_drive.plasma_charge_rate
	else
		data["has_drive"] = 0
		data["drive_status"] = "Not found"
		data["drive_class"] = "bad"
	if(SSstarmap.ftl_shieldgen)
		data["has_shield"] = 1
		if(SSstarmap.ftl_shieldgen.is_active())
			data["shield_status"] = "Fully charged, shields up"
			data["shield_class"] = "good"
		else if(SSstarmap.ftl_shieldgen.charging_power || SSstarmap.ftl_shieldgen.charging_plasma)
			data["shield_status"] = "Charging, shields down"
			data["shield_class"] = "average"
		else if(SSstarmap.ftl_shieldgen.stat & BROKEN)
			data["shield_status"] = "Broken"
			data["shield_class"] = "bad"
		else
			data["shield_status"] = "Not charging, shields down"
			data["shield_class"] = "bad"
		data["shield_plasma_charge"] = SSstarmap.ftl_shieldgen.plasma_charge
		data["shield_plasma_charge_max"] = SSstarmap.ftl_shieldgen.plasma_charge_max
		data["shield_charging_plasma"] = SSstarmap.ftl_shieldgen.charging_plasma
		data["shield_power_charge"] = SSstarmap.ftl_shieldgen.power_charge
		data["shield_power_charge_max"] = SSstarmap.ftl_shieldgen.power_charge_max
		data["shield_charging_power"] = SSstarmap.ftl_shieldgen.charging_power
		data["shield_on"] = SSstarmap.ftl_shieldgen.on
		data["shield_charge_rate"] = SSstarmap.ftl_shieldgen.charge_rate
		data["shield_charge_rate"] = SSstarmap.ftl_shieldgen.plasma_charge_rate
	else
		data["has_shield"] = 0
		data["shield_status"] = "Not found"
		data["shield_class"] = "bad"
	var/list/shipweapons = list()
	data["shipweapons"] = shipweapons
	for(var/obj/machinery/power/shipweapon/PC in world)
		if(!istype(get_area(PC), /area/shuttle/ftl))
			continue
		var/list/shipweapon = list()
		shipweapon["id"]  = "\ref[PC]"
		shipweapon["name"] = "[PC]"
		if(PC.cell)
			shipweapon["charge"] = PC.cell.charge
			shipweapon["maxcharge"] = PC.cell.maxcharge
		else
			shipweapon["charge"] = 0
			shipweapon["maxcharge"] = 1
		shipweapon["cannon_charge_rate"] = PC.charge_rate
		shipweapons[++shipweapons.len] = shipweapon

	return data

/obj/machinery/computer/pmanagement/ui_act(action, params)
  if(..())
    return
  switch(action)
    if("power_add_sub")
      var/mode = params["mode"]
      var/input = params["input"]
      var/charge_change
      switch(input)
        if("add")
          charge_change = 1000
        if("sub")
          charge_change = -1000
      switch(mode)
        if("drive")
          SSstarmap.ftl_drive.charge_rate += charge_change
          SSstarmap.ftl_drive.plasma_charge_rate += charge_change/1000
        if("shield")
          SSstarmap.ftl_shieldgen.charge_rate += charge_change
          SSstarmap.ftl_shieldgen.plasma_charge_rate += charge_change/1000
        if("cannon")
          var/obj/machinery/power/shipweapon/PC = locate(params["id"])
          PC.charge_rate += charge_change
      . = 1
