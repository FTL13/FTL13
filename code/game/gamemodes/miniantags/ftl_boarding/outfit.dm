/datum/round_event/ghost_role/boarding/proc/manageOutfit(var/mob/living/carbon/human/defender, var/priority, var/tc)
  var/list/outfits = list(/datum/outfit/defender/security)  //TODO: TEST
  if(priority == 1)
    defender.equipOutfit(/datum/outfit/defender/command)
    var/obj/item/device/radio/uplink/U = new(defender)
    U.hidden_uplink.owner = "[defender.key]"
    U.hidden_uplink.telecrystals = tc
    U.hidden_uplink.boarding = TRUE
    defender.equip_to_slot_or_del(U, slot_in_backpack)
  else
    defender.equipOutfit(pick(outfits))

  var/obj/item/device/radio/R = defender.ears
  R.set_frequency(SYND_FREQ)
  R.freqlock = 1
  defender.faction |= "syndicate"
  defender.update_icons()

/datum/outfit/defender/command
  name = "Enemy ship's captain"
  uniform = /obj/item/clothing/under/syndicate
  shoes = /obj/item/clothing/shoes/combat
  gloves = /obj/item/clothing/gloves/combat
  back = /obj/item/weapon/storage/backpack
  glasses = /obj/item/clothing/glasses/night
  mask = /obj/item/clothing/mask/gas/syndicate
  suit = /obj/item/clothing/suit/space/hardsuit/syndi
  r_pocket = /obj/item/weapon/tank/internals/emergency_oxygen/engi
  belt = /obj/item/weapon/storage/belt/military
  r_hand = /obj/item/weapon/gun/projectile/automatic/shotgun/bulldog
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
		/obj/item/weapon/tank/jetpack/oxygen/harness=1,\
		/obj/item/weapon/gun/projectile/automatic/pistol=1)

/datum/outfit/defender/security
  name = "Enemy ship's security officer"

  uniform = /obj/item/clothing/under/syndicate
  shoes = /obj/item/clothing/shoes/combat
  gloves = /obj/item/clothing/gloves/combat
  back = /obj/item/weapon/storage/backpack
  ears = /obj/item/device/radio/headset/syndicate/alt
  id = /obj/item/weapon/card/id/syndicate
  belt = /obj/item/weapon/gun/projectile/automatic/pistol
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1)
