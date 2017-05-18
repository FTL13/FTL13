/datum/outfit/defender/clown
  name = "clown ship artist"
  mask = /obj/item/clothing/mask/gas/clown_hat
  uniform = /obj/item/clothing/under/rank/clown
  shoes = /obj/item/clothing/shoes/clown_shoes
  gloves = /obj/item/clothing/gloves/color/rainbow/clown
  back = /obj/item/weapon/storage/backpack/clown

/datum/outfit/defender/clown/post_equip(mob/living/carbon/human/H)
  ..()
  H.real_name = pick(GLOB.clown_names)
  var/obj/item/weapon/implant/sad_trombone/S = new/obj/item/weapon/implant/sad_trombone(H)
  S.imp_in = H
  H.dna.add_mutation(CLOWNMUT)
  H.rename_self("clown")

/datum/outfit/defender/clown/announce_to()
  var/text = "<B>UH OH!</B>\n"
  text +="<B>something something bad happens! bad guys approaching our circus!</B>\n"
  text +="<B>Defend Self-HONKstruct device for 10 minutes, do not let normies take our !FUN! stuff!\n</B>"
  text +="<B>Your Noble responsible for special PRANK gear distribution, go bother him!</B>"
  return text

/datum/outfit/defender/command/clown
  name = "clown ship overlord"
  head = /obj/item/clothing/head/jester
  mask = /obj/item/clothing/mask/gas/sexyclown
  uniform = /obj/item/clothing/under/rank/clown/sexy
  suit = /obj/item/clothing/suit/space/syndicate/orange
  shoes = /obj/item/clothing/shoes/clown_shoes/banana_shoes
  back = /obj/item/weapon/storage/backpack/clown
  suit_store = /obj/item/weapon/gun/energy/tesla_revolver
  belt = /obj/item/weapon/bikehorn/airhorn
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
    /obj/item/clothing/head/helmet/space/syndicate/orange=1,\
    /obj/item/weapon/tank/jetpack/oxygen/harness=1,\
    /obj/item/device/firing_pin/clown/ultra=1,\
    /obj/item/weapon/reagent_containers/food/snacks/grown/banana=1)

/datum/outfit/defender/command/clown/post_equip(mob/living/carbon/human/H)
  ..()
  H.real_name = pick(GLOB.clown_names)
  var/obj/item/weapon/card/id/I = H.wear_id
  I.update_label("Lord [H.real_name]", "Clown Noble")
  var/obj/item/device/radio/uplink/U = H.get_item_by_slot(l_hand)
  U.hidden_uplink.name = "Honklink!"
  U.hidden_uplink.style = "clown"
  var/obj/item/weapon/implant/sad_trombone/S = new/obj/item/weapon/implant/sad_trombone(H)
  S.imp_in = H
  H.dna.add_mutation(CLOWNMUT)
  H.rename_self("clown")

/datum/outfit/defender/command/clown/announce_to()
  var/text = "<B>You are the Noble of this HONK ship!</B>\n"
  text +="<B>Huge blast disrupted our prank systems! Self-HONKstruction mechanism was launched automatically.</B>\n"
  text +="<B>Defend Self-HONKstruction terminal for 10 minutes, do not let this bastards take our !FUN! stuff!\n</B>"
  text +="<B>You responsible for TC distribution of your team! Take their raw telecrystals and order them what they need from Uplink!</B>"
  return text

/datum/outfit/defender/clown/knight
  name = "clown ship knight"
  head = /obj/item/clothing/head/helmet/justice/escape
  belt = /obj/item/weapon/gun/ballistic/automatic/pistol/luger
  suit = /obj/item/clothing/suit/armor/bulletproof
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
    /obj/item/weapon/storage/box/handcuffs=1,\
    /obj/item/device/firing_pin/clown/ultra=1,\
    /obj/item/ammo_box/magazine/luger=2)

/datum/outfit/defender/clown/knight/post_equip(mob/living/carbon/human/H)
  ..()
  var/obj/item/weapon/card/id/I = H.wear_id
  I.update_label("Knight [H.real_name]", "Clown Vassal")

/datum/outfit/defender/clown/builder
  name = "clown ship builder"
  head = /obj/item/clothing/head/welding
  belt = /obj/item/weapon/storage/belt/utility/full
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
    /obj/item/device/firing_pin/clown/ultra=1,\
    /obj/item/weapon/storage/box/metalfoam=1)

/datum/outfit/defender/clown/builder/post_equip(mob/living/carbon/human/H)
  ..()
  var/obj/item/weapon/card/id/I = H.wear_id
  I.update_label("[H.real_name] The Builder", "Clown Architect")

/datum/outfit/defender/clown/doc
  name = "clown ship doctor"
  head = /obj/item/clothing/head/nursehat
  glasses = /obj/item/clothing/glasses/hud/health
  belt = /obj/item/weapon/storage/belt/medical
  l_hand = /obj/item/weapon/storage/firstaid/regular
  backpack_contents = list(/obj/item/weapon/storage/box/syndie=1,\
    /obj/item/device/firing_pin/clown/ultra=1,\
		/obj/item/weapon/reagent_containers/hypospray/medipen/stimpack/traitor=3)

/datum/outfit/defender/clown/doc/post_equip(mob/living/carbon/human/H)
  ..()
  var/obj/item/weapon/card/id/I = H.wear_id
  I.update_label("Doctor [H.real_name]", "Clown Priest")
