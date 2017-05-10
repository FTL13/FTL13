/datum/outfit/defender/nanotrasen
  name = "NT ship employee"
  uniform = /obj/item/clothing/under/rank/centcom_officer
  shoes = /obj/item/clothing/shoes/laceup
  head = /obj/item/clothing/head/bandana
  back = /obj/item/weapon/storage/backpack/satchel
  glasses = /obj/item/clothing/glasses/eyepatch

/datum/outfit/defender/nanotrasen/post_equip(mob/living/carbon/human/H)
  ..()
  var/obj/item/device/radio/R = H.ears
  R.set_frequency(CENTCOM_FREQ)
  R.freqlock = 1

/datum/outfit/defender/nanotrasen/announce_to()
  var/text = "<B>You need to protect NT property!</B>\n"
  text +="<B>Shameless traitors approaching our ship! They think they can loot us...</B>\n"
  text +="<B>Defend Self-Destruct device for 10 minutes, do not let traitors take our high-tech devices and valuable recources!\n</B>"
  text +="<B>Your Commander is responsible for special defence gear distribution, ask him NOW!</B>"
  return text

/datum/outfit/defender/command/nanotrasen
  name = "NT ship captain"
  uniform = /obj/item/clothing/under/rank/centcom_commander
  suit = /obj/item/clothing/suit/space/syndicate/green
  shoes = /obj/item/clothing/shoes/laceup
  mask = /obj/item/clothing/mask/gas/sechailer/swat
  back = /obj/item/weapon/storage/backpack/satchel
  suit_store = /obj/item/weapon/gun/energy/laser/retro
  glasses = /obj/item/clothing/glasses/hud/security/night
  belt = /obj/item/weapon/melee/rapier
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
    /obj/item/weapon/tank/jetpack/oxygen/harness=1,\
    /obj/item/clothing/head/helmet/space/syndicate/green=1)

/datum/outfit/defender/command/nanotrasen/post_equip(mob/living/carbon/human/H)
  ..()
  var/obj/item/weapon/card/id/I = H.wear_id
  I.update_label("Cpt. [H.real_name]", "NT Ship Commander")
  var/obj/item/device/radio/R = H.ears
  R.set_frequency(CENTCOM_FREQ)
  R.freqlock = 1
  var/obj/item/device/radio/uplink/U = H.l_hand
  U.hidden_uplink.name = "Centcomm TCNet"
  U.hidden_uplink.style = "nanotrasen"

/datum/outfit/defender/command/nanotrasen/announce_to()
  var/text = "<B>You are Commander of this ship!</B>\n"
  text +="<B>Huge blast disrupted our primary systems! Self-destruction mechanism was launched automatically on ship main terminal.</B>\n"
  text +="<B>Defend the ship main terminal for 10 minutes, do not let this traitors take our high-tech devices and valuable recources!\n</B>"
  text +="<B>You responsible for TC distribution of your team! Take their raw telecrystals and order them what they need from Uplink!</B>"
  return text

/datum/outfit/defender/nanotrasen/marine
  name = "NT ship marine"
  head = /obj/item/clothing/head/helmet/swat/nanotrasen
  belt = /obj/item/weapon/gun/projectile/automatic/pistol/m1911
  suit = /obj/item/clothing/suit/armor/bulletproof
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
    /obj/item/weapon/storage/box/handcuffs=1,\
    /obj/item/ammo_box/magazine/m45=2)

/datum/outfit/defender/nanotrasen/marine/post_equip(mob/living/carbon/human/H)
  ..()
  var/obj/item/weapon/card/id/I = H.wear_id
  I.update_label("Lt. [H.real_name]", "NT Ship Marine")

/datum/outfit/defender/nanotrasen/engineer
  name = "NT ship engineer"
  head = /obj/item/clothing/head/welding
  belt = /obj/item/weapon/storage/belt/utility/full
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
    /obj/item/weapon/storage/box/metalfoam=1)

/datum/outfit/defender/nanotrasen/engineer/post_equip(mob/living/carbon/human/H)
  ..()
  var/obj/item/weapon/card/id/I = H.wear_id
  I.update_label("Sgt. [H.real_name]", "NT Ship Engineering Officer")

/datum/outfit/defender/nanotrasen/medic
  name = "NT ship medic"
  glasses = /obj/item/clothing/glasses/hud/health
  belt = /obj/item/weapon/storage/belt/medical
  l_hand = /obj/item/weapon/storage/firstaid/regular
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
		/obj/item/weapon/reagent_containers/hypospray/medipen/stimpack/traitor=3)

/datum/outfit/defender/nanotrasen/medic/post_equip(mob/living/carbon/human/H)
  ..()
  var/obj/item/weapon/card/id/I = H.wear_id
  I.update_label("Cpl. [H.real_name]", "NT Ship Medical Officer")
