//Civilian Cryo Pod purchasable at stations.
/obj/effect/mob_spawn/human/purchasable/civilian
	name = "Civilian Cryopod"
	desc = "An NT Crew Pod allowing off-duty crewmembers to rest in cryosleep awaiting a new assignment."
	flavour_text = "<font size=3><b>W</b></font><b>You awake from deep cryosleep. It seems NT has a ship for you to crew, about time. You see the faces of your new crewmates and feel an urge to help them succeed in their mission </b>"
	anchored = 0
	death = FALSE
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "oldpod"
	uniform = /obj/item/clothing/under/color/darkblue
	shoes = /obj/item/clothing/shoes/sneakers/black
	belt = /obj/item/weapon/storage/belt/utility
	mask = /obj/item/clothing/mask/gas
	radio = /obj/item/device/radio/headset
	has_id = 1
	id_job = "Civilian"
	id_access = "Assistant"

/obj/effect/mob_spawn/human/purchasable/civilian/New()
	..()
	var/area/A = get_area(src)
	if(A)
		notify_ghosts("A new Assistant is ready for hire! \the [A.name].", source = src, action=NOTIFY_ATTACK)
	mob_name = random_unique_name()


//Engineer Cryo Pod purchasable at stations.
/obj/effect/mob_spawn/human/purchasable/engineer
	name = "Engineering Cryopod"
	desc = "An NT Crew Pod allowing off-duty crewmembers to rest in cryosleep awaiting a new assignment."
	flavour_text = "<font size=3><b>W</b></font><b>You awake from deep cryosleep. It seems NT has a ship for you to crew, about time. You see the faces of your new crewmates and feel an urge to help them succeed in their mission </b>"
	anchored = 0
	death = FALSE
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "oldpod"
	uniform = /obj/item/clothing/under/rank/engineer
	shoes = /obj/item/clothing/shoes/workboots
	belt = /obj/item/weapon/storage/belt/utility/full
	helmet = /obj/item/clothing/head/hardhat
	pocket1 = /obj/item/device/pda/engineering
	pocket2 = /obj/item/device/t_scanner
	back = /obj/item/weapon/storage/backpack/industrial
	radio = /obj/item/device/radio/headset/headset_eng
	has_id = 1
	id_job = "Engineer"
	id_access = "Station Engineer"

/obj/effect/mob_spawn/human/purchasable/engineer/New()
	..()
	var/area/A = get_area(src)
	if(A)
		notify_ghosts("A new Engineer is ready for hire! \the [A.name].", source = src, action=NOTIFY_ATTACK)
	mob_name = random_unique_name()


//Security Cryo Pod purchasable at stations.
/obj/effect/mob_spawn/human/purchasable/security
	name = "Security Cryopod"
	desc = "An NT Crew Pod allowing off-duty crewmembers to rest in cryosleep awaiting a new assignment."
	flavour_text = "<font size=3><b>W</b></font><b>You awake from deep cryosleep. It seems NT has a ship for you to crew, about time. You see the faces of your new crewmates and feel an urge to help them succeed in their mission </b>"
	anchored = 0
	death = FALSE
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "oldpod"
	uniform = /obj/item/clothing/under/rank/security
	suit = /obj/item/clothing/suit/armor/vest/alt
	shoes = /obj/item/clothing/shoes/jackboots
	belt = /obj/item/weapon/gun/projectile/automatic/pistol
	helmet = /obj/item/clothing/head/helmet/sec
	pocket1 = /obj/item/weapon/restraints/handcuffs
	pocket2 = /obj/item/device/assembly/flash/handheld
	back = /obj/item/weapon/storage/backpack/security
	radio = /obj/item/device/radio/headset/headset_sec/alt
	has_id = 1
	id_job = "Security Officer"
	id_access = "Security Officer"


/obj/effect/mob_spawn/human/purchasable/security/New()
	..()
	var/area/A = get_area(src)
	if(A)
		notify_ghosts("A new Security Officer is ready for hire! \the [A.name].", source = src, action=NOTIFY_ATTACK)
	mob_name = random_unique_name()


//Medical Cryo Pod purchasable at stations.
/obj/effect/mob_spawn/human/purchasable/medical
	name = "Medical Cryopod"
	desc = "An NT Crew Pod allowing off-duty crewmembers to rest in cryosleep awaiting a new assignment."
	flavour_text = "<font size=3><b>W</b></font><b>You awake from deep cryosleep. It seems NT has a ship for you to crew, about time. You see the faces of your new crewmates and feel an urge to help them succeed in their mission </b>"
	anchored = 0
	death = FALSE
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "oldpod"
	uniform = /obj/item/clothing/under/rank/medical
	suit =  /obj/item/clothing/suit/toggle/labcoat
	shoes = /obj/item/clothing/shoes/sneakers/white
	belt = /obj/item/device/pda/medical
	back = /obj/item/weapon/storage/backpack/medic
	radio = /obj/item/device/radio/headset/headset_med
	has_id = 1
	id_job = "Medical Doctor"
	id_access = "Medical Doctor"

/obj/effect/mob_spawn/human/purchasable/medical/New()
	..()
	var/area/A = get_area(src)
	if(A)
		notify_ghosts("A new Medical Doctor is ready for hire! \the [A.name].", source = src, action=NOTIFY_ATTACK)
	mob_name = random_unique_name()