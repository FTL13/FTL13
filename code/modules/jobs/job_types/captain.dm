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
	exp_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/captain

	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()

/datum/job/captain/get_access()
	return get_all_accesses()

/datum/outfit/job/captain
	name = "Captain"

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
	satchel = /obj/item/weapon/storage/backpack/satchel_cap
	dufflebag = /obj/item/weapon/storage/backpack/dufflebag/captain

/datum/outfit/job/captain/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	var/obj/item/clothing/under/U = H.w_uniform
	U.attachTie(new /obj/item/clothing/tie/medal/gold/captain())

	if(visualsOnly)
		return

	var/obj/item/weapon/implant/mindshield/L = new/obj/item/weapon/implant/mindshield(H)
	L.imp_in = H
	L.implanted = 1
	H.sec_hud_set_implants()

	minor_announce("Captain [H.real_name] on deck!")

/*
Executive Officer
*/
/datum/job/xo
	title = "Executive Officer"
	flag = XO
	department_head = list("Captain")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ccccff"
	req_admin_notify = 1
	minimal_player_age = 10
	exp_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/xo

	access = list(access_security, access_sec_doors, access_medical, access_engine, access_literal_engine, access_change_ids, access_heads, access_helm, access_ai_chamber,
			            access_all_personal_lockers, access_maint_tunnels, access_bar, access_morgue, access_kitchen, access_janitor, access_waste, access_moffice,
									access_cargo, access_hydroponics, access_research, access_mining, access_xo, access_RC_announce, access_detective, access_munitions, access_helms_console, access_weapons_console)
	minimal_access = list(access_security, access_sec_doors, access_medical, access_engine, access_literal_engine, access_change_ids, access_heads, access_helm, access_ai_chamber,
			            	access_all_personal_lockers, access_maint_tunnels, access_bar, access_morgue, access_kitchen, access_janitor, access_waste, access_moffice,
										access_cargo, access_hydroponics, access_research, access_mining, access_xo, access_RC_announce, access_detective, access_munitions, access_helms_console, access_weapons_console)


/datum/outfit/job/xo
	name = "Executive Officer"

	id = /obj/item/weapon/card/id/silver
	belt = /obj/item/device/pda/heads/xo
	ears = /obj/item/device/radio/headset/heads/xo
	uniform = /obj/item/clothing/under/rank/executive_officer
	shoes = /obj/item/clothing/shoes/sneakers/brown
	suit = /obj/item/clothing/suit/toggle/service/xo
	head = /obj/item/clothing/head/xocap
	backpack_contents = list(/obj/item/weapon/storage/box/ids=1,\
		/obj/item/weapon/melee/classic_baton/telescopic=1)

/datum/outfit/job/xo/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	announce_head(H, list("Supply", "Service"))
