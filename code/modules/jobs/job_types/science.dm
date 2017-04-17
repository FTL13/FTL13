/*
Research Director
*/
/datum/job/rd
	title = "Research Director"
	flag = RD
	department_head = list("Captain")
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ffddff"
	req_admin_notify = 1
	minimal_player_age = 7

	outfit = /datum/outfit/job/rd

	access = list(access_rd, access_heads, access_morgue, access_sec_doors, access_research, access_robotics,
							access_xenobiology, access_RC_announce, access_maint_tunnels, access_helm, access_ai_chamber)
	minimal_access = list(access_rd, access_heads, access_morgue, access_sec_doors, access_research, access_robotics,
							access_xenobiology,access_RC_announce, access_maint_tunnels, access_helm, access_ai_chamber)

/datum/outfit/job/rd
	name = "Research Director"

	id = /obj/item/weapon/card/id/silver
	belt = /obj/item/device/pda/heads/rd
	ears = /obj/item/device/radio/headset/heads/rd
	uniform = /obj/item/clothing/under/rank/research_director
	shoes = /obj/item/clothing/shoes/sneakers/brown
	suit = /obj/item/clothing/suit/toggle/service/rd
	l_hand = /obj/item/weapon/clipboard
	l_pocket = /obj/item/device/laser_pointer
	backpack_contents = list(/obj/item/weapon/melee/classic_baton/telescopic=1)

	backpack = /obj/item/weapon/storage/backpack/science
	satchel = /obj/item/weapon/storage/backpack/satchel_tox

/datum/outfit/job/rd/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	announce_head(H, list("Science")) //tell underlings (science radio) they have a head

/*
Scientist
*/
/datum/job/scientist
	title = "Scientist"
	flag = SCIENTIST
	department_head = list("Research Director")
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 5
	spawn_positions = 3
	supervisors = "the research director"
	selection_color = "#ffeeff"
	alt_titles = list("Xenobiologist", "Researcher")

	outfit = /datum/outfit/job/scientist

	access = list(access_robotics, access_research, access_xenobiology)
	minimal_access = list(access_research, access_xenobiology)

/datum/outfit/job/scientist
	name = "Scientist"

	belt = /obj/item/device/pda/toxins
	ears = /obj/item/device/radio/headset/headset_sci
	uniform = /obj/item/clothing/under/rank/scientist
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit = /obj/item/clothing/suit/toggle/service/science

	backpack = /obj/item/weapon/storage/backpack/science
	satchel = /obj/item/weapon/storage/backpack/satchel_tox

/*
Roboticist
*/
/datum/job/roboticist
	title = "Roboticist"
	flag = ROBOTICIST
	department_head = list("Research Director")
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "research director"
	selection_color = "#ffeeff"
	alt_titles = list("Mechanic")

	outfit = /datum/outfit/job/roboticist

	access = list(access_robotics, access_morgue, access_research, access_xenobiology)
	minimal_access = list(access_robotics, access_morgue)

/datum/outfit/job/roboticist
	name = "Roboticist"

	belt = /obj/item/weapon/storage/belt/utility/full
	l_pocket = /obj/item/device/pda/roboticist
	ears = /obj/item/device/radio/headset/headset_sci
	uniform = /obj/item/clothing/under/rank/roboticist
	suit = /obj/item/clothing/suit/toggle/labcoat

	backpack = /obj/item/weapon/storage/backpack/science
	satchel = /obj/item/weapon/storage/backpack/satchel_tox

	pda_slot = slot_l_store
