/datum/outfit/defender/command/generic
  name = "sindicate ship captain"
  mask = /obj/item/clothing/mask/gas/syndicate
  suit = /obj/item/clothing/suit/space/syndicate/black/red
  suit_store = /obj/item/weapon/gun/energy/laser/retro
  belt =/obj/item/weapon/katana/ceremonial
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
    /obj/item/weapon/tank/jetpack/oxygen/harness=1,\
    /obj/item/clothing/head/helmet/space/syndicate/black/red=1)

/datum/outfit/defender/generic/security
  name = "sindicate ship security officer"
  suit = /obj/item/clothing/suit/armor/bulletproof
  belt = /obj/item/weapon/gun/ballistic/automatic/pistol
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
		/obj/item/weapon/storage/box/handcuffs=1,\
    /obj/item/ammo_box/magazine/m10mm=2)

/datum/outfit/defender/generic/security/post_equip(mob/living/carbon/human/H)
  ..()
  var/obj/item/weapon/card/id/I = H.wear_id
  I.update_label("Sergeant [H.real_name]", "Syndicate Agent")

/datum/outfit/defender/generic/engineer
  name = "sindicate ship engineering officer"
  head = /obj/item/clothing/head/welding
  belt = /obj/item/weapon/storage/belt/utility/full
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
		/obj/item/weapon/storage/box/metalfoam=1)

/datum/outfit/defender/generic/engineer/post_equip(mob/living/carbon/human/H)
  ..()
  var/obj/item/weapon/card/id/I = H.wear_id
  I.update_label("Pioneer [H.real_name]", "Syndicate Maintainer")

/datum/outfit/defender/generic/medic
  name = "sindicate ship medical officer"
  glasses = /obj/item/clothing/glasses/hud/health
  back = /obj/item/weapon/storage/backpack/medic
  belt = /obj/item/weapon/storage/belt/medical
  l_hand = /obj/item/weapon/storage/firstaid/regular
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
		/obj/item/weapon/reagent_containers/hypospray/medipen/stimpack/traitor=3)

/datum/outfit/defender/generic/medic/post_equip(mob/living/carbon/human/H)
  ..()
  var/obj/item/weapon/card/id/I = H.wear_id
  I.update_label("Doc [H.real_name]", "Syndicate Medic")
