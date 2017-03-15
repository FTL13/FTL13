/datum/outfit/defender/command/generic
  name = "enemy ship's captain"
  suit = /obj/item/clothing/suit/space/syndicate/black/red

/datum/outfit/defender/generic/security
  name = "enemy ship's security officer"
  mask = /obj/item/clothing/mask/gas
  suit = /obj/item/clothing/suit/armor/bulletproof
  belt = /obj/item/weapon/gun/projectile/automatic/pistol
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
		/obj/item/weapon/storage/box/handcuffs=1,\
    /obj/item/ammo_box/magazine/m10mm=1)

/datum/outfit/defender/generic/security/post_equip(mob/living/carbon/human/H)
  ..()
  var/obj/item/weapon/card/id/I = H.wear_id
  I.registered_name  = "Sergeant [H.real_name]"

/datum/outfit/defender/generic/engineer
  name = "enemy ship's engineering officer"
  head = /obj/item/clothing/head/welding
  belt = /obj/item/weapon/storage/belt/utility/full
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
		/obj/item/weapon/storage/box/metalfoam=1)

/datum/outfit/defender/generic/engineer/post_equip(mob/living/carbon/human/H)
  ..()
  var/obj/item/weapon/card/id/I = H.wear_id
  I.registered_name  = "Pioneer [H.real_name]"

/datum/outfit/defender/generic/medic
  name = "enemy ship's medical officer"
  glasses = /obj/item/clothing/glasses/hud/health
  back = /obj/item/weapon/storage/backpack/medic
  belt = /obj/item/weapon/storage/belt/medical
  l_hand = /obj/item/weapon/storage/firstaid/regular
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
		/obj/item/weapon/reagent_containers/hypospray/medipen/stimpack/traitor=3)

/datum/outfit/defender/generic/medic/post_equip(mob/living/carbon/human/H)
  ..()
  var/obj/item/weapon/card/id/I = H.wear_id
  I.registered_name  = "Doc [H.real_name]"
