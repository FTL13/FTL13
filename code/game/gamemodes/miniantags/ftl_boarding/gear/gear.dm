/datum/uplink_item/defender
  boarding_mode = TRUE
  surplus = 0

/datum/uplink_item/defender/main
	category = "Defence Gear"

/datum/uplink_item/defender/main/sandbag
  name = "Sandbags"
  desc = "Ten bags of sand. Useful for building barriers."
  cost = 2
  item = /obj/item/stack/sheet/mineral/sandbags/ten

//Survival stuff
/datum/uplink_item/defender/emergency
  category = "Emergency Gear"

// Defence Stuff (Special Offers)
/datum/uplink_item/defender/traps
	category = "Trapping Gear"

/datum/uplink_item/defender/traps/beartrap
  name = "Box of Beartraps"
  desc = "Cheap and cruel solution for building defence \
   against carbon creatures. Comes with 6 beartraps."
  cost = 5
  item = /obj/item/weapon/storage/box/beartraps

/datum/uplink_item/defender/traps/landmine
  name = "Military-grade landmine"
  desc = "Explosive type mine. Activates on drop.\
   Triggers on step. No IFF system included."
  cost = 5
  item = /obj/item/mine/explosive

/datum/uplink_item/defender/traps/stunmine
  name = "Stun mine"
  desc = "Very effective stun mechanism. Activates on drop.\
   Triggers on step. No IFF system included."
  cost = 5
  item = /obj/item/mine/stun

/datum/uplink_item/defender/traps/n2o
  name = "Sleep mine"
  desc = "360 moles of N2O. Activates on drop.\
   Triggers on step. No IFF system included."
  cost = 5
  item = /obj/item/mine/gas/n2o

/datum/uplink_item/defender/traps/sound
  name = "Sound mine"
  desc = "Useful for signaling. Activates on drop.\
   Triggers on step. No IFF system included."
  cost = 2
  item = /obj/item/mine/sound
