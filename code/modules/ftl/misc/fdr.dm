/obj/item/device/gps/flightdatarecorder
  name = "flight data recorder" //TODO: Name will display wrong when rebased
  icon_state = "gps-fdr"
  w_class = WEIGHT_CLASS_BULKY
  gpstag = "FDR-Emergency"
  desc = "A Flight Data Recorder, standard issue in any large ship. Stations would likely pay a bounty for the recovery of this."


/datum/export/flightdatarecorder
  cost = 1500 //A decent bounty for recovering the data
  unit_name = "flight data recorder"
  cost_modifiers = list("Salvage")
  export_types = list(/obj/item/device/gps/flightdatarecorder)
