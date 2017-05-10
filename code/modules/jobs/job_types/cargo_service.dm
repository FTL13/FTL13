/*
Quartermaster
*/
/datum/job/qm
	title = "Quartermaster"
	flag = QUARTERMASTER
	department_head = list("Executive Officer")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the executive officer"
	selection_color = "#d7b088"

	outfit = /datum/outfit/job/quartermaster

	access = list(access_maint_tunnels, access_cargo, access_mining, access_waste, access_external_airlocks)
	minimal_access = list(access_maint_tunnels, access_cargo, access_mining, access_waste, access_external_airlocks)

/datum/outfit/job/quartermaster
	name = "Quartermaster"

	belt = /obj/item/device/pda/quartermaster
	ears = /obj/item/device/radio/headset/headset_cargo
	uniform = /obj/item/clothing/under/rank/cargo
	shoes = /obj/item/clothing/shoes/sneakers/brown
	glasses = /obj/item/clothing/glasses/sunglasses
	l_hand = /obj/item/weapon/clipboard
	suit = /obj/item/clothing/suit/toggle/service/cargo

/*
Munitions Officer
*/
/datum/job/munitions_officer
	title = "Munitions Officer"
	flag = MUNITIONS
	department_head = list("Executive Officer")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the weapons officer, the executive officer"
	selection_color = "#e49f58"
	minimal_player_age = 10

	outfit = /datum/outfit/job/munitions_officer

	access = list(access_cargo, access_munitions, access_moffice, access_sec_doors, access_heads, access_helm, access_external_airlocks)
	minimal_access = list(access_cargo, access_munitions, access_moffice, access_sec_doors, access_heads, access_helm, access_external_airlocks)

/datum/outfit/job/munitions_officer
	name = "Munitions Officer"

	belt = /obj/item/device/pda
	ears = /obj/item/device/radio/headset/heads/xo // for communicating with WO, will make new subtype just for him later
	uniform = /obj/item/clothing/under/rank/mofficer
	shoes = /obj/item/clothing/shoes/workboots
	head = /obj/item/clothing/head/helmet/mofficer
	gloves = /obj/item/clothing/gloves/color/light_brown
	suit = /obj/item/clothing/suit/toggle/service/munitions

/*
Cargo Technician
*/
/datum/job/cargo_tech
	title = "Cargo Technician"
	flag = CARGOTECH
	department_head = list("Executive Officer")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 3
	spawn_positions = 2
	supervisors = "the quartermaster and the executive officer"
	selection_color = "#dcba97"
	alt_titles = list("Supply Technician","Production Technician")

	outfit = /datum/outfit/job/cargo_tech

	access = list(access_maint_tunnels, access_cargo, access_mining, access_waste, access_external_airlocks)
	minimal_access = list(access_maint_tunnels, access_cargo, access_waste, access_external_airlocks)

/datum/outfit/job/cargo_tech
	name = "Cargo Technician"

	belt = /obj/item/device/pda/cargo
	ears = /obj/item/device/radio/headset/headset_cargo
	uniform = /obj/item/clothing/under/rank/cargotech
	suit = /obj/item/clothing/suit/toggle/service/cargo


/*
Shaft Miner
*/
/datum/job/mining
	title = "Shaft Miner"
	flag = MINER
	department_head = list("Executive Officer")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the quartermaster and the executive officer"
	selection_color = "#dcba97"
	alt_titles = list("Salvager", "Explorer")

	outfit = /datum/outfit/job/miner

	access = list(access_maint_tunnels, access_cargo, access_mining, access_external_airlocks)
	minimal_access = list(access_mining, access_external_airlocks)

/datum/outfit/job/miner
	name = "Shaft Miner"

	belt = /obj/item/device/pda/shaftminer
	ears = /obj/item/device/radio/headset/headset_cargo/mining
	shoes = /obj/item/clothing/shoes/workboots/mining
	gloves = /obj/item/clothing/gloves/color/black
	uniform = /obj/item/clothing/under/rank/miner/lavaland
	l_pocket = /obj/item/weapon/reagent_containers/hypospray/medipen/survival
	r_pocket = /obj/item/device/flashlight/seclite
	backpack_contents = list(
		/obj/item/weapon/storage/bag/ore=1,\
		/obj/item/weapon/kitchen/knife/combat/survival=1,\
		/obj/item/weapon/mining_voucher=1)

	backpack = /obj/item/weapon/storage/backpack/explorer
	satchel = /obj/item/weapon/storage/backpack/satchel_explorer
	dufflebag = /obj/item/weapon/storage/backpack/dufflebag
	box = /obj/item/weapon/storage/box/survival_mining
	suit = /obj/item/clothing/suit/toggle/service/cargo

/*
Bartender
*/
/datum/job/bartender
	title = "Bartender"
	flag = BARTENDER
	department_head = list("Executive Officer")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the executive officer"
	selection_color = "#bbe291"

	outfit = /datum/outfit/job/bartender

	access = list(access_hydroponics, access_bar, access_kitchen, access_morgue)
	minimal_access = list(access_bar)


/datum/outfit/job/bartender
	name = "Bartender"

	glasses = /obj/item/clothing/glasses/sunglasses/reagent
	belt = /obj/item/device/pda/bar
	ears = /obj/item/device/radio/headset/headset_srv
	uniform = /obj/item/clothing/under/rank/bartender
	suit = /obj/item/clothing/suit/armor/vest
	backpack_contents = list(/obj/item/weapon/storage/box/beanbag=1)
	shoes = /obj/item/clothing/shoes/laceup

/*
Cook
*/
/datum/job/cook
	title = "Cook"
	flag = COOK
	department_head = list("Executive Officer")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 1
	supervisors = "the executive officer"
	selection_color = "#bbe291"
	alt_titles = list("Chef","Sous-chef")
	var/cooks = 0 //Counts cooks amount

	outfit = /datum/outfit/job/cook

	access = list(access_hydroponics, access_bar, access_kitchen, access_morgue)
	minimal_access = list(access_kitchen, access_morgue)

/datum/outfit/job/cook
	name = "Cook"

	belt = /obj/item/device/pda/cook
	ears = /obj/item/device/radio/headset/headset_srv
	uniform = /obj/item/clothing/under/rank/chef
	suit = /obj/item/clothing/suit/toggle/chef
	head = /obj/item/clothing/head/chefhat

/datum/outfit/job/cook/pre_equip(mob/living/carbon/human/H)
	..()
	var/datum/job/cook/J = SSjob.GetJob(H.job)
	if(J) // Fix for runtime caused by invalid job being passed
		J.cooks++
		if(J.cooks>1)//Cooks
			suit = /obj/item/clothing/suit/apron/chef
			head = /obj/item/clothing/head/soft/mime

/datum/outfit/job/cook/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
    ..()
    var/list/possible_boxes = subtypesof(/obj/item/weapon/storage/box/ingredients)
    var/chosen_box = pick(possible_boxes)
    var/obj/item/weapon/storage/box/I = new chosen_box(src)
    H.equip_to_slot_or_del(I,slot_in_backpack)

/*
Botanist
*/
/datum/job/hydro
	title = "Botanist"
	flag = BOTANIST
	department_head = list("Executive Officer")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 3
	spawn_positions = 2
	supervisors = "the executive officer"
	selection_color = "#bbe291"

	outfit = /datum/outfit/job/botanist

	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_hydroponics)

/datum/outfit/job/botanist
	name = "Botanist"

	belt = /obj/item/device/pda/botanist
	ears = /obj/item/device/radio/headset/headset_srv
	uniform = /obj/item/clothing/under/rank/hydroponics
	suit = /obj/item/clothing/suit/toggle/service/civilian
	gloves  =/obj/item/clothing/gloves/botanic_leather
	suit_store = /obj/item/device/plant_analyzer

	backpack = /obj/item/weapon/storage/backpack/botany
	satchel = /obj/item/weapon/storage/backpack/satchel_hyd


/*
Janitor
*/
/datum/job/janitor
	title = "Janitor"
	flag = JANITOR
	department_head = list("Executive Officer")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 1
	supervisors = "the executive officer"
	selection_color = "#bbe291"
	alt_titles = list("Sanitation Technician", "Maid")
	var/global/janitors = 0

	outfit = /datum/outfit/job/janitor

	access = list(access_maint_tunnels, access_janitor, access_waste)
	minimal_access = list(access_maint_tunnels, access_janitor, access_waste)

/datum/outfit/job/janitor
	name = "Janitor"

	belt = /obj/item/device/pda/janitor
	ears = /obj/item/device/radio/headset/headset_srv
	uniform = /obj/item/clothing/under/rank/janitor
	suit = /obj/item/clothing/suit/toggle/service/civilian