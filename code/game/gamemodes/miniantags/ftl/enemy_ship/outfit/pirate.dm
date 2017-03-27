/datum/outfit/defender/pirate
  name = "pirate ship swabbie"
  uniform = /obj/item/clothing/under/pirate
  shoes = /obj/item/clothing/shoes/sneakers/brown
  head = /obj/item/clothing/head/bandana
  back = /obj/item/weapon/storage/backpack/satchel
  glasses = /obj/item/clothing/glasses/eyepatch

/datum/outfit/defender/pirate/announce_to()
  var/text = "<B>YARRRRRRR!</B>\n"
  text +="<B>This bastards want to test themselves in a close combat!</B>\n"
  text +="<B>Defend Self-Destruct device for 10 minutes, take them by surprise and die a glorious death!\n</B>"
  text +="<B>Your Cap'n responsible for special BOOM gear distribution, go bother him!</B>"
  return text

/datum/outfit/defender/command/pirate
  name = "pirate ship captain"
  uniform = /obj/item/clothing/under/pirate
  suit = /obj/item/clothing/suit/space/pirate
  shoes = /obj/item/clothing/shoes/laceup
  head = /obj/item/clothing/head/helmet/space/pirate
  mask = /obj/item/clothing/mask/gas
  back = /obj/item/weapon/storage/backpack/satchel
  suit_store = /obj/item/weapon/gun/energy/laser/retro
  glasses = /obj/item/clothing/glasses/thermal/eyepatch
  belt = /obj/item/weapon/nullrod/claymore/saber/pirate
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
    /obj/item/weapon/tank/jetpack/oxygen/harness=1,\
    /obj/item/ammo_box/n762=1)

/datum/outfit/defender/command/pirate/post_equip(mob/living/carbon/human/H)
  ..()
  var/obj/item/device/radio/uplink/U = H.l_hand
  var/obj/item/weapon/card/id/I = H.wear_id
  I.update_label("Cap'n [H.real_name]", "Pirate Leader")
  U.hidden_uplink.name = "Pirate Freedom Network"
  U.hidden_uplink.style = "pirate"

/datum/outfit/defender/command/pirate/announce_to()
  var/text = "<B>YARR! You are the captain of this ship!</B>\n"
  text +="<B>Huge blast disrupted our primary systems! Self-destruction mechanism was launched automatically on ship main terminal.</B>\n"
  text +="<B>Defend the Self-destruction mechanism for 10 minutes, do not let this bastards take our treasures!\n</B>"
  text +="<B>You responsible for TC distribution of your team! Take their raw telecrystals and order them what they need from Uplink!</B>"
  return text


/datum/outfit/defender/pirate/gunner
  name = "pirate ship gunner"
  belt = /obj/item/weapon/gun/projectile/revolver/nagant
  suit = /obj/item/clothing/suit/armor/bulletproof
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
    /obj/item/weapon/storage/box/handcuffs=1,\
    /obj/item/ammo_box/n762=1)

/datum/outfit/defender/pirate/gunner/post_equip(mob/living/carbon/human/H)
  ..()
  var/obj/item/weapon/card/id/I = H.wear_id
  I.update_label("1st Mate [H.real_name]", "Pirate Gunner")

/datum/outfit/defender/pirate/carpenter
  name = "pirate ship carpenter"
  head = /obj/item/clothing/head/welding
  belt = /obj/item/weapon/storage/belt/utility/full
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
    /obj/item/weapon/storage/box/metalfoam=1)

/datum/outfit/defender/pirate/carpenter/post_equip(mob/living/carbon/human/H)
  ..()
  var/obj/item/weapon/card/id/I = H.wear_id
  I.update_label("2nd Mate [H.real_name]", "Pirate Carpenter")

/datum/outfit/defender/pirate/surgeon
  name = "pirate ship surgeon"
  head = /obj/item/clothing/head/plaguedoctorhat
  glasses = /obj/item/clothing/glasses/hud/health
  belt = /obj/item/weapon/storage/belt/medical
  l_hand = /obj/item/weapon/storage/firstaid/regular
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
		/obj/item/weapon/reagent_containers/hypospray/medipen/stimpack/traitor=3)

/datum/outfit/defender/pirate/surgeon/post_equip(mob/living/carbon/human/H)
  ..()
  var/obj/item/weapon/card/id/I = H.wear_id
  I.update_label("3rd Mate [H.real_name]", "Pirate Sawbones")
