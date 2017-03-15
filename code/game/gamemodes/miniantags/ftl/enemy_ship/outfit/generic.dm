/datum/outfit/defender/command/generic
  name = "enemy ship's captain"

/datum/outfit/defender/generic/security
  name = "enemy ship's security officer"
  mask = /obj/item/clothing/mask/gas
  belt = /obj/item/weapon/gun/projectile/automatic/pistol
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
		/obj/item/weapon/storage/box/handcuffs=1)

/datum/outfit/defender/generic/engineer
  name = "enemy ship's engineering officer"
  head = /obj/item/clothing/head/hardhat/red
  belt = /obj/item/weapon/storage/belt/utility/full
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
		/obj/item/weapon/storage/box/metalfoam=1)

/datum/outfit/defender/generic/medic
  name = "enemy ship's medical officer"
  glasses = /obj/item/clothing/glasses/hud/health
  back = /obj/item/weapon/storage/backpack/medic
  belt = /obj/item/weapon/storage/belt/medical
  r_hand = /obj/item/weapon/storage/firstaid/regular
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
		/obj/item/weapon/reagent_containers/hypospray/medipen/stimpack/traitor=3)
