/datum/outfit/defender/solgov
  name = "SolGov ship passengeer"
  uniform = /obj/item/clothing/under/suit_jacket
  shoes = /obj/item/clothing/shoes/jackboots
  head = /obj/item/clothing/head/bandana
  back = /obj/item/weapon/storage/backpack/satchel
  glasses = /obj/item/clothing/glasses/eyepatch

/datum/outfit/defender/solgov/post_equip(mob/living/carbon/human/H)
  ..()
  var/obj/item/device/radio/R = H.ears
  R.set_frequency(CENTCOM_FREQ)
  R.freqlock = 1

/datum/outfit/defender/command/solgov
  name = "SolGov ship captain"
  uniform = /obj/item/clothing/under/space
  suit = /obj/item/clothing/suit/space/nasavoid/defender
  shoes = /obj/item/clothing/shoes/laceup
  mask = /obj/item/clothing/mask/gas/sechailer
  back = /obj/item/weapon/storage/backpack/satchel
  suit_store = /obj/item/weapon/gun/energy/disabler
  glasses = /obj/item/clothing/glasses/hud/security/night
  belt = /obj/item/weapon/melee/rapier
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
    /obj/item/weapon/tank/jetpack/oxygen/harness=1,\
    /obj/item/clothing/head/helmet/space/nasavoid=1)

/datum/outfit/defender/command/solgov/post_equip(mob/living/carbon/human/H)
  ..()
  var/obj/item/weapon/card/id/I = H.wear_id
  I.registered_name  = "Cpt. [H.real_name]"
  I.assignment = "Executive Officer"
  var/obj/item/device/radio/R = H.ears
  R.set_frequency(CENTCOM_FREQ)
  R.freqlock = 1
  var/obj/item/device/radio/uplink/U = H.l_hand
  U.hidden_uplink.name = "Earth Emergency Network"
  U.hidden_uplink.style = "solgov"

/datum/outfit/defender/solgov/peacekeeper
  name = "SolGov ship peacekeeper"
  head = /obj/item/clothing/head/helmet/swat/nanotrasen
  belt = /obj/item/weapon/gun/energy/gun/advtaser
  suit = /obj/item/clothing/suit/armor/bulletproof
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
    /obj/item/weapon/storage/box/handcuffs=1,\
    /obj/item/ammo_box/magazine/m45=2)

/datum/outfit/defender/solgov/marine/post_equip(mob/living/carbon/human/H)
  ..()
  var/obj/item/weapon/card/id/I = H.wear_id
  I.registered_name  = "Lt. [H.real_name]"
  I.assignment = "Peacekeeper"

/datum/outfit/defender/solgov/engineer
  name = "SolGov ship engineer"
  head = /obj/item/clothing/head/welding
  belt = /obj/item/weapon/storage/belt/utility/full
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
    /obj/item/weapon/storage/box/metalfoam=1)

/datum/outfit/defender/solgov/engineer/post_equip(mob/living/carbon/human/H)
  ..()
  var/obj/item/weapon/card/id/I = H.wear_id
  I.registered_name  = "Sgt. [H.real_name]"
  I.assignment = "Engineering Officer"

/datum/outfit/defender/solgov/medic
  name = "SolGov ship medic"
  glasses = /obj/item/clothing/glasses/hud/health
  belt = /obj/item/weapon/storage/belt/medical
  l_hand = /obj/item/weapon/storage/firstaid/regular
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
		/obj/item/weapon/reagent_containers/hypospray/medipen/stimpack/traitor=3)

/datum/outfit/defender/solgov/medic/post_equip(mob/living/carbon/human/H)
  ..()
  var/obj/item/weapon/card/id/I = H.wear_id
  I.registered_name  = "Cpl. [H.real_name]"
  I.assignment = "Medic Officer"
