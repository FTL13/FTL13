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
  R.set_frequency(GLOB.CENTCOM_FREQ)
  R.freqlock = 1

/datum/outfit/defender/solgov/announce_to()
  var/text = "<span class='warning'>-ALERT! This is transmission from Earth Fleet Command!-</span>\n"
  text +="<B>Huge blast destroyed your primary systems! Self-destruction mechanism launched on your ship main terminal.</B>\n"
  text +="<B>Defend the ship main terminal for 10 minutes, we can't let them have this freight!\n</B>"
  text +="<B>Your ship's CEO responsible for special defence gear distribution, ask him immediately!</B>"
  text +="<B>My apologies, but your surviving chance is 0%. Stick with a mission.</B>"
  text +="<span class='warning'>-END OF TRANSMISSION-</span>"
  return text

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
  I.update_label("CEO [H.real_name]", "Executive Officer")
  var/obj/item/device/radio/R = H.ears
  R.set_frequency(GLOB.CENTCOM_FREQ)
  R.freqlock = 1
  var/obj/item/device/radio/uplink/U = H.l_hand
  U.hidden_uplink.name = "Earth Emergency Network"
  U.hidden_uplink.style = "solgov"

/datum/outfit/defender/command/solgov/announce_to()
  var/text = "<span class='warning'>-ALERT! This is transmission from Earth Fleet Command!-</span>\n"
  text += "<B>You are RESPONSIBLE for this ship!</B>\n"
  text +="<B>Huge blast disrupted our primary systems! Self-destruction mechanism was launched automatically on ship main terminal.</B>\n"
  text +="<B>Defend the ship main terminal for 10 minutes, do not let them take our freight!\n</B>"
  text +="<B>You responsible for TC distribution of your team! Take their raw telecrystals and order them what they need from Uplink!</B>"
  text +="<span class='warning'>-END OF TRANSMISSION-</span>"
  return text

/datum/outfit/defender/solgov/peacekeeper
  name = "SolGov ship peacekeeper"
  head = /obj/item/clothing/head/helmet/swat/nanotrasen
  belt = /obj/item/weapon/gun/energy/e_gun/advtaser
  suit = /obj/item/clothing/suit/armor/bulletproof
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
    /obj/item/weapon/storage/box/handcuffs=1,\
    /obj/item/ammo_box/magazine/m45=2)

/datum/outfit/defender/solgov/marine/post_equip(mob/living/carbon/human/H)
  ..()
  var/obj/item/weapon/card/id/I = H.wear_id
  I.update_label("Cpt. [H.real_name]", "Peacekeeper")

/datum/outfit/defender/solgov/engineer
  name = "SolGov ship engineer"
  head = /obj/item/clothing/head/welding
  belt = /obj/item/weapon/storage/belt/utility/full
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
    /obj/item/weapon/storage/box/metalfoam=1)

/datum/outfit/defender/solgov/engineer/post_equip(mob/living/carbon/human/H)
  ..()
  var/obj/item/weapon/card/id/I = H.wear_id
  I.update_label("Lt. [H.real_name]", "Engineering Worker")

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
  I.update_label("Lt. [H.real_name]", "Medical Worker")
