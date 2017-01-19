//Assistant Cryo Pod purchasable at stations.
/obj/effect/mob_spawn/human/purchasable/assistant
	name = "Assistant Cryopod"
	desc = "An NT Crew Pod allowing off-duty crewmembers to rest in cryosleep awaiting a new assignment."
	mob_name = "a hired assistant"
	flavour_text = "<font size=3><b>W</b></font><b>You awake from deep cryosleep. It seems NT has a ship for you to crew, about time. You see the faces of your new crewmates and feel an urge to help them succeed in their mission </b>"
	anchored = 0
	death = FALSE
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "oldpod"
	uniform = /obj/item/clothing/under/color/darkblue
	shoes = /obj/item/clothing/shoes/sneakers/black
	belt = /obj/item/weapon/storage/belt/utility
	mask = /obj/item/clothing/mask/gas

/obj/effect/mob_spawn/human/purchasable/assistant/New()
	..()
	var/area/A = get_area(src)
	if(A)
		notify_ghosts("A new assistant is ready for hire! \the [A.name].", source = src, action=NOTIFY_ATTACK)

//Engineer Cryo Pod purchasable at stations.
/obj/effect/mob_spawn/human/purchasable/engineer
	name = "Engineering Cryopod"
	desc = "An NT Crew Pod allowing off-duty crewmembers to rest in cryosleep awaiting a new assignment."
	mob_name = "a hired engineer"
	flavour_text = "<font size=3><b>W</b></font><b>You awake from deep cryosleep. It seems NT has a ship for you to crew, about time. You see the faces of your new crewmates and feel an urge to help them succeed in their mission </b>"
	anchored = 0
	death = FALSE
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "oldpod"
	uniform = /obj/item/clothing/under/rank/engineer
	shoes = /obj/item/clothing/shoes/workboots
	belt = /obj/item/weapon/storage/belt/utility/full
	helmet = /obj/item/clothing/head/hardhat
	l_pocket = /obj/item/device/pda/engineering
	r_pocket = /obj/item/device/t_scanner
	back = /obj/item/weapon/storage/backpack/industrial
	ears = /obj/item/device/radio/headset/headset_eng


/obj/effect/mob_spawn/human/purchasable/engineer/New()
	..()
	var/area/A = get_area(src)
	if(A)
		notify_ghosts("A new engineer is ready for hire! \the [A.name].", source = src, action=NOTIFY_ATTACK)