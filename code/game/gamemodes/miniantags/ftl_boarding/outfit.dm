/datum/round_event/ghost_role/boarding/proc/manageOutfit(var/mob/living/carbon/human/defender, var/priority)
  var/list/outfits = list(/datum/outfit/defender,
                        /datum/outfit/defender/security,
                        /datum/outfit/defender/engineer,
                        /datum/outfit/defender/medic)  //TODO: TEST
  if(priority == 1)
    defender.equipOutfit(/datum/outfit/defender/command)
    var/obj/item/device/radio/uplink/U = defender.l_hand
    U.hidden_uplink.telecrystals = 10
    U.boarding = 1
  else
    defender.equipOutfit(pick(outfits))

  defender.faction |= "syndicate"
  defender.update_icons()

/datum/outfit/defender
  name = "Enemy ship's crewman"
  uniform = /obj/item/clothing/under/syndicate
  shoes = /obj/item/clothing/shoes/combat
  gloves = /obj/item/clothing/gloves/combat
  id = /obj/item/weapon/card/id/syndicate
  l_hand = /obj/item/stack/telecrystal/five
  back = /obj/item/weapon/storage/backpack
  ears = /obj/item/device/radio/headset/syndicate/alt

/datum/outfit/defender/post_equip(mob/living/carbon/human/H)
  var/obj/item/weapon/card/id/I = H.wear_id
  I.registered_name  = "Agent [H.real_name]"
  var/obj/item/device/radio/R = H.ears
  R.set_frequency(SYND_FREQ)
  R.freqlock = 1

/datum/outfit/defender/command
  name = "Enemy ship's captain"
  glasses = /obj/item/clothing/glasses/night
  mask = /obj/item/clothing/mask/gas/syndicate
  suit = /obj/item/clothing/suit/armor/bulletproof
  id = /obj/item/weapon/card/id/syndicate_command
  r_pocket = /obj/item/weapon/tank/internals/emergency_oxygen/engi
  l_hand = /obj/item/device/radio/uplink
  belt = /obj/item/weapon/storage/belt/military
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
		/obj/item/weapon/tank/jetpack/oxygen/harness=1,\
		/obj/item/weapon/gun/projectile/automatic/pistol=1)

/datum/outfit/defender/command/post_equip(mob/living/carbon/human/H)
  ..()
  var/obj/item/weapon/card/id/I = H.wear_id
  I.registered_name  = "Captain [H.real_name]"
  var/obj/item/device/radio/uplink/U = H.l_hand
  U.hidden_uplink.owner = "[H.mind.key]"
  U.hidden_uplink.boarding = TRUE

/datum/outfit/defender/security
  name = "Enemy ship's security officer"
  mask = /obj/item/clothing/mask/gas
  belt = /obj/item/weapon/gun/projectile/automatic/pistol
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
		/obj/item/weapon/storage/box/handcuffs=1)

/datum/outfit/defender/engineer
  name = "Enemy ship's engineering officer"
  head = /obj/item/clothing/head/hardhat/red
  belt = /obj/item/weapon/storage/belt/utility/full
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
		/obj/item/weapon/storage/box/metalfoam=1)

/datum/outfit/defender/medic
  name = "Enemy ship's medical officer"
  glasses = /obj/item/clothing/glasses/hud/health
  back = /obj/item/weapon/storage/backpack/medic
  belt = /obj/item/weapon/storage/belt/medical
  r_hand = /obj/item/weapon/storage/firstaid/regular
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
		/obj/item/weapon/reagent_containers/hypospray/medipen/stimpack/traitor=3)
