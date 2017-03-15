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

/datum/uplink_item/defender/main/barrier_grenade
  name = "Barrier grenade"
  desc = "Grenade inflates security barrier providing good cover.\
        Different inflating modes included!"
  cost = 2
  item = /obj/item/weapon/grenade/barrier

/datum/uplink_item/defender/main/at_field
  name = "Anti-Grenade field generator"
  desc = "Disables incoming grenades in a range of 7 tiles.\
    Wrench to floor to make it work."
  cost = 7
  item = /obj/machinery/at_field
//Survival stuff
/datum/uplink_item/defender/emergency
  category = "Emergency Gear"

// Defence Stuff (Special Offers)
/datum/uplink_item/defender/traps
	category = "Trapping Gear"

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
  cost = 3
  item = /obj/item/mine/stun

/datum/uplink_item/defender/traps/n2o
  name = "Sleep mine"
  desc = "360 moles of N2O. Activates on drop.\
   Triggers on step. No IFF system included."
  cost = 3
  item = /obj/item/mine/gas/n2o

/datum/uplink_item/defender/traps/sound
  name = "Sound mine"
  desc = "Useful for signaling. Activates on drop.\
   Triggers on step. No IFF system included."
  cost = 1
  item = /obj/item/mine/sound

/datum/uplink_item/defender/traps/beartrap
  name = "Box of Beartraps"
  desc = "Cheap and cruel solution for building defence \
   against carbon creatures. Comes with 6 beartraps."
  cost = 3
  item = /obj/item/weapon/storage/box/beartraps

/datum/uplink_item/stealthy_tools/chameleon_proj/def
  cost = 10
  boarding_mode = TRUE
