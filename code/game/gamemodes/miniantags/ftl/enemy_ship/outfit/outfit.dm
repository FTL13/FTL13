/datum/round_event/ghost_role/boarding/proc/manageOutfit(var/mob/living/carbon/human/defender, var/priority, var/crew_type=/datum/outfit/defender/generic, var/captain_type = /datum/outfit/defender/command/generic)
  var/list/outfits = list()
  for(var/outfit in subtypesof(crew_type))
    outfits+=outfit
  if(priority == 1)
    defender.equipOutfit(captain_type)
  else
    defender.equipOutfit(pick(outfits))
  defender.update_icons()

//Parent datums DO NOT EDIT
/datum/outfit/defender
  name = "defender basic gear"
  uniform = /obj/item/clothing/under/syndicate
  shoes = /obj/item/clothing/shoes/combat
  gloves = /obj/item/clothing/gloves/combat
  id = /obj/item/weapon/card/id/syndicate
  l_hand = /obj/item/stack/telecrystal/five
  back = /obj/item/weapon/storage/backpack
  ears = /obj/item/device/radio/headset/syndicate/alt

/datum/outfit/defender/post_equip(mob/living/carbon/human/H)
  var/obj/item/weapon/card/id/I = H.wear_id
  I.update_label("[H.real_name]", "Crewman")
  I.access += access_syndicate
  var/obj/item/device/radio/R = H.ears
  R.set_frequency(SYND_FREQ)
  R.freqlock = 1
  H << announce_to()

/datum/outfit/defender/proc/announce_to()
  var/text = "<B>You survived in a starship's fight!</B>\n"
  text +="<B>Huge blast destroyed our primary systems! Self-destruction mechanism was launched automatically on ship main terminal.</B>\n"
  text +="<B>Defend the ship main terminal for 10 minutes, do not let this bastards take our high-tech staff!\n</B>"
  text +="<B>Your captain responsible for special defence gear distribution, go ask him!</B>"
  return text

/datum/outfit/defender/command
  name = "defender command gear"
  glasses = /obj/item/clothing/glasses/night
  id = /obj/item/weapon/card/id/syndicate_command
  r_pocket = /obj/item/weapon/tank/internals/emergency_oxygen/engi
  l_hand = /obj/item/device/radio/uplink
  belt = /obj/item/weapon/storage/belt/military
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
		/obj/item/weapon/tank/jetpack/oxygen/harness=1,\
		/obj/item/weapon/gun/ballistic/automatic/pistol=1,\
    /obj/item/ammo_box/magazine/m10mm=2)

/datum/outfit/defender/command/announce_to()
  var/text = "<B>You are the captain of this ship!</B>\n"
  text +="<B>Huge blast disrupted our primary systems! Self-destruction mechanism was launched automatically on ship main terminal.</B>\n"
  text +="<B>Defend the ship main terminal for 10 minutes, do not let this bastards take our high-tech staff!\n</B>"
  text +="<B>You responsible for TC distribution of your team! Take their raw telecrystals and order them what they need from Uplink!</B>"
  return text

/datum/outfit/defender/command/post_equip(mob/living/carbon/human/H)
  ..()
  var/obj/item/weapon/card/id/I = H.wear_id
  I.update_label("Captain [H.real_name]", "Officer")
  I.access += access_syndicate_leader
  var/obj/item/device/radio/uplink/U = H.l_hand
  U.hidden_uplink.telecrystals = 10
  U.hidden_uplink.boarding = 1
  U.hidden_uplink.owner = "[H.mind.key]"
