/datum/outfit/defender/pirate
  name = "pirate ship swabbie"
  uniform = /obj/item/clothing/under/pirate
  shoes = /obj/item/clothing/shoes/sneakers/brown
  head = /obj/item/clothing/head/bandana
  back = /obj/item/weapon/storage/backpack/satchel
  glasses = /obj/item/clothing/glasses/eyepatch

/datum/outfit/defender/command/pirate
  name = "pirate ship captain"
  uniform = /obj/item/clothing/under/pirate
  suit = /obj/item/clothing/suit/space/pirate
  shoes = /obj/item/clothing/shoes/sneakers/brown
  head = /obj/item/clothing/head/helmet/space/pirate
  back = /obj/item/weapon/storage/backpack/satchel
  suit_store = /obj/item/weapon/gun/projectile/revolver/nagant
  glasses = /obj/item/clothing/glasses/thermal/eyepatch
  belt = /obj/item/weapon/nullrod/claymore/saber/pirate
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
    /obj/item/weapon/tank/jetpack/oxygen/harness=1,\
    /obj/item/ammo_box/n762=1)

/datum/outfit/defender/command/pirate/post_equip(mob/living/carbon/human/H)
  var/obj/item/device/radio/R = H.ears
  R.set_frequency(SYND_FREQ)
  R.freqlock = 1
  var/obj/item/device/radio/uplink/U = H.l_hand
  U.hidden_uplink.telecrystals = 10
  U.hidden_uplink.boarding = 1
  U.hidden_uplink.owner = "[H.mind.key]"
  U.hidden_uplink.name = "Pirate Freedom Network"
  U.hidden_uplink.style = "pirate"

/datum/outfit/defender/pirate/gunner
  name = "pirate ship gunner"
  belt = /obj/item/weapon/gun/projectile/revolver/nagant
  suit = /obj/item/clothing/suit/armor/bulletproof
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
    /obj/item/weapon/storage/box/handcuffs=1,\
    /obj/item/ammo_box/n762=1)

/datum/outfit/defender/pirate/gunner/post_equip(mob/living/carbon/human/H)
  ..()
  var/obj/item/weapon/card/id/I = H.wear_id
  I.registered_name  = "Gunner [H.real_name]"
  I.assignment = "First Mate"

/datum/outfit/defender/pirate/carpenter
  name = "pirate ship carpenter"
  head = /obj/item/clothing/head/welding
  belt = /obj/item/weapon/storage/belt/utility/full
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
    /obj/item/weapon/storage/box/metalfoam=1)

/datum/outfit/defender/pirate/carpenter/post_equip(mob/living/carbon/human/H)
  ..()
  var/obj/item/weapon/card/id/I = H.wear_id
  I.registered_name  = "Carpenter [H.real_name]"
  I.assignment = "Second Mate"

/datum/outfit/defender/pirate/surgeon
  name = "pirate ship surgeon"
  head = /obj/item/clothing/head/plaguedoctorhat
  glasses = /obj/item/clothing/glasses/hud/health
  belt = /obj/item/weapon/storage/belt/medical
  l_hand = /obj/item/weapon/storage/firstaid/regular
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
		/obj/item/weapon/reagent_containers/hypospray/medipen/stimpack/traitor=3)

/datum/outfit/defender/pirate/surgeon/post_equip(mob/living/carbon/human/H)
  ..()
  var/obj/item/weapon/card/id/I = H.wear_id
  I.registered_name  = "Sawbones [H.real_name]"
  I.assignment = "Third Mate"
