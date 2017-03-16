/datum/outfit/defender/clown
  name = "clown ship artist"
  mask = /obj/item/clothing/mask/gas/clown_hat
  uniform = /obj/item/clothing/under/rank/clown
  shoes = /obj/item/clothing/shoes/clown_shoes
  gloves = /obj/item/clothing/gloves/color/rainbow/clown
  back = /obj/item/weapon/storage/backpack/clown

/datum/outfit/defender/clown/post_equip(mob/living/carbon/human/H)
  ..()
  H.real_name = pick(clown_names)

/datum/outfit/defender/command/clown
  name = "clown ship overlord"
  head = /obj/item/clothing/head/jester
  mask = /obj/item/clothing/mask/gas/sexyclown
  uniform = /obj/item/clothing/under/rank/clown/sexy
  suit = /obj/item/clothing/suit/space/syndicate/orange
  shoes = /obj/item/clothing/shoes/clown_shoes/banana_shoes
  back = /obj/item/weapon/storage/backpack/clown
  suit_store = /obj/item/weapon/gun/energy/shock_revolver
  belt = /obj/item/weapon/bikehorn/airhorn
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
    /obj/item/clothing/head/helmet/space/syndicate/orange=1,\
    /obj/item/weapon/tank/jetpack/oxygen/harness=1,\
    /obj/item/weapon/reagent_containers/food/snacks/grown/banana=3)

/datum/outfit/defender/command/clown/post_equip(mob/living/carbon/human/H)
  var/obj/item/device/radio/R = H.ears
  R.set_frequency(SYND_FREQ)
  R.freqlock = 1
  H.real_name = pick(clown_names)
  var/obj/item/weapon/card/id/I = H.wear_id
  I.registered_name  = "Lord [H.real_name]"
  I.assignment = "Clown Noble"
  var/obj/item/device/radio/uplink/U = H.l_hand
  U.hidden_uplink.telecrystals = 10
  U.hidden_uplink.boarding = 1
  U.hidden_uplink.owner = "[H.mind.key]"
  U.hidden_uplink.name = "Honklink!"
  U.hidden_uplink.style = "clown"

/datum/outfit/defender/clown/knight
  name = "clown ship knight"
  head = /obj/item/clothing/head/helmet/justice/escape
  belt = /obj/item/weapon/gun/projectile/automatic/pistol/luger
  suit = /obj/item/clothing/suit/armor/bulletproof
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
    /obj/item/weapon/storage/box/handcuffs=1,\
    /obj/item/ammo_box/magazine/luger=2)

/datum/outfit/defender/clown/knight/post_equip(mob/living/carbon/human/H)
  ..()
  var/obj/item/weapon/card/id/I = H.wear_id
  I.registered_name  = "Knight [H.real_name]"
  I.assignment = "Clown Vassal"

/datum/outfit/defender/clown/builder
  name = "clown ship builder"
  head = /obj/item/clothing/head/welding
  belt = /obj/item/weapon/storage/belt/utility/full
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
    /obj/item/weapon/storage/box/metalfoam=1)

/datum/outfit/defender/clown/builder/post_equip(mob/living/carbon/human/H)
  ..()
  var/obj/item/weapon/card/id/I = H.wear_id
  I.registered_name  = "[H.real_name] The Builder"
  I.assignment = "Clown Architect"

/datum/outfit/defender/clown/doc
  name = "clown ship doctor"
  head = /obj/item/clothing/head/nursehat
  glasses = /obj/item/clothing/glasses/hud/health
  belt = /obj/item/weapon/storage/belt/medical
  l_hand = /obj/item/weapon/storage/firstaid/regular
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
		/obj/item/weapon/reagent_containers/hypospray/medipen/stimpack/traitor=3)

/datum/outfit/defender/clown/doc/post_equip(mob/living/carbon/human/H)
  ..()
  var/obj/item/weapon/card/id/I = H.wear_id
  I.registered_name  = "Doctor [H.real_name]"
  I.assignment = "Clown Priest"
