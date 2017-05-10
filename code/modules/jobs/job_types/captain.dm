/*
Captain
*/
/datum/job/captain
	title = "Captain"
	flag = CAPTAIN
	department_head = list("Centcom")
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "Nanotrasen officials and Space law"
	selection_color = "#6ca2e2"
	req_admin_notify = 1
	minimal_player_age = 14

	outfit = /datum/outfit/job/captain

	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()

/datum/job/captain/get_access()
	return get_all_accesses()

<<<<<<< HEAD
/datum/job/captain/announce(mob/living/carbon/human/H)
	..()
	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, .proc/minor_announce, "Captain [H.real_name] on deck!"))

=======
>>>>>>> master
/datum/outfit/job/captain
	name = "Captain"
	jobtype = /datum/job/captain

	id = /obj/item/weapon/card/id/gold
	belt = /obj/item/device/pda/captain
	glasses = /obj/item/clothing/glasses/sunglasses
	ears = /obj/item/device/radio/headset/heads/captain/alt
	gloves = /obj/item/clothing/gloves/color/captain
	uniform =  /obj/item/clothing/under/rank/captain
	suit = /obj/item/clothing/suit/toggle/service/captain
	shoes = /obj/item/clothing/shoes/sneakers/brown
	head = /obj/item/clothing/head/caphat
	backpack_contents = list(/obj/item/weapon/melee/classic_baton/telescopic=1, /obj/item/station_charter=1,/obj/item/clothing/suit/armor/vest/capcarapace=1)

	backpack = /obj/item/weapon/storage/backpack/captain
	satchel = /obj/item/weapon/storage/backpack/satchel/cap
	dufflebag = /obj/item/weapon/storage/backpack/dufflebag/captain

	implants = list(/obj/item/weapon/implant/mindshield)


/*
Executive Officer
*/
/datum/job/xo
	title = "Executive Officer"
	flag = XO
	department_head = list("Captain")
	department_flag = CIVILIAN
	head_announce = list("Supply", "Service")
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ccccff"
	req_admin_notify = 1
	minimal_player_age = 10

	outfit = /datum/outfit/job/xo

<<<<<<< HEAD
	access = list(GLOB.access_security, GLOB.access_sec_doors, GLOB.access_court, GLOB.access_weapons,
			            GLOB.access_medical, GLOB.access_engine, GLOB.access_change_ids, GLOB.access_ai_upload, GLOB.access_eva, GLOB.access_heads,
			            GLOB.access_all_personal_lockers, GLOB.access_maint_tunnels, GLOB.access_bar, GLOB.access_janitor, GLOB.access_construction, GLOB.access_morgue,
			            GLOB.access_crematorium, GLOB.access_kitchen, GLOB.access_cargo, GLOB.access_cargo_bot, GLOB.access_mailsorting, GLOB.access_qm, GLOB.access_hydroponics, GLOB.access_lawyer,
			            GLOB.access_theatre, GLOB.access_chapel_office, GLOB.access_library, GLOB.access_research, GLOB.access_mining, GLOB.access_heads_vault, GLOB.access_mining_station,
			            GLOB.access_hop, GLOB.access_RC_announce, GLOB.access_keycard_auth, GLOB.access_gateway, GLOB.access_mineral_storeroom)
	minimal_access = list(GLOB.access_security, GLOB.access_sec_doors, GLOB.access_court, GLOB.access_weapons,
			            GLOB.access_medical, GLOB.access_engine, GLOB.access_change_ids, GLOB.access_ai_upload, GLOB.access_eva, GLOB.access_heads,
			            GLOB.access_all_personal_lockers, GLOB.access_maint_tunnels, GLOB.access_bar, GLOB.access_janitor, GLOB.access_construction, GLOB.access_morgue,
			            GLOB.access_crematorium, GLOB.access_kitchen, GLOB.access_cargo, GLOB.access_cargo_bot, GLOB.access_mailsorting, GLOB.access_qm, GLOB.access_hydroponics, GLOB.access_lawyer,
			            GLOB.access_theatre, GLOB.access_chapel_office, GLOB.access_library, GLOB.access_research, GLOB.access_mining, GLOB.access_heads_vault, GLOB.access_mining_station,
			            GLOB.access_hop, GLOB.access_RC_announce, GLOB.access_keycard_auth, GLOB.access_gateway, GLOB.access_mineral_storeroom)


/datum/outfit/job/hop
	name = "Head of Personnel"
	jobtype = /datum/job/hop
=======
	access = list(access_security, access_sec_doors, access_medical, access_engine, access_literal_engine, access_change_ids, access_heads, access_helm, access_ai_chamber,
			            access_all_personal_lockers, access_maint_tunnels, access_bar, access_morgue, access_kitchen, access_janitor, access_waste, access_moffice,
									access_cargo, access_hydroponics, access_research, access_mining, access_xo, access_RC_announce, access_detective, access_munitions, access_helms_console, access_weapons_console)
	minimal_access = list(access_security, access_sec_doors, access_medical, access_engine, access_literal_engine, access_change_ids, access_heads, access_helm, access_ai_chamber,
			            	access_all_personal_lockers, access_maint_tunnels, access_bar, access_morgue, access_kitchen, access_janitor, access_waste, access_moffice,
										access_cargo, access_hydroponics, access_research, access_mining, access_xo, access_RC_announce, access_detective, access_munitions, access_helms_console, access_weapons_console)


/datum/outfit/job/xo
	name = "Executive Officer"
>>>>>>> master

	id = /obj/item/weapon/card/id/silver
	belt = /obj/item/device/pda/heads/xo
	ears = /obj/item/device/radio/headset/heads/xo
	uniform = /obj/item/clothing/under/rank/executive_officer
	shoes = /obj/item/clothing/shoes/sneakers/brown
	suit = /obj/item/clothing/suit/toggle/service/xo
	head = /obj/item/clothing/head/xocap
	backpack_contents = list(/obj/item/weapon/storage/box/ids=1,\
<<<<<<< HEAD
		/obj/item/weapon/melee/classic_baton/telescopic=1, /obj/item/device/modular_computer/tablet/preset/advanced = 1)
=======
		/obj/item/weapon/melee/classic_baton/telescopic=1)

/datum/outfit/job/xo/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	announce_head(H, list("Supply", "Service"))
>>>>>>> master
