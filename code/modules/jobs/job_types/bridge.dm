/*
Bridge Officer
*/
/datum/job/bofficer
	title = "Bridge Officer"
	flag = BOFFICER
	department_head = list("Captain")
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the captain and the executive officer"
	selection_color = "#ddddff"
	req_admin_notify = 1
	minimal_player_age = 10

	outfit = /datum/outfit/job/bofficer

	access = list(access_heads, access_helm, access_maint_tunnels)
	minimal_access = list(access_heads, access_helm, access_maint_tunnels)

var/list/posts = list("weapons", "helms")

/datum/outfit/job/bofficer //utilizes HoP headset for now
	name = "Bridge Officer"

	belt = /obj/item/device/pda //if you ever change this, remove the part that references it below
	glasses = /obj/item/clothing/glasses/sunglasses
	ears = /obj/item/device/radio/headset/heads/hop
	uniform =  /obj/item/clothing/under/rank/bofficer
	shoes = /obj/item/clothing/shoes/laceup
	head = /obj/item/clothing/head/bofficer
	gloves = /obj/item/clothing/gloves/color/grey/hop

	var/post = null
	var/list/post_access = null //so we don't have people fighting over posts
	var/spawn_point = null

/datum/outfit/job/bofficer/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
  ..()

  if(posts.len)
    post = pick(posts)
    if(!visualsOnly)
      posts -= post
    switch(post)
      if("weapons")
        post_access = list(access_weapons_console)
        spawn_point = locate(/obj/effect/landmark/start/bo/weapons) in department_command_spawns
      if("helms")
        post_access = list(access_helms_console)
        spawn_point = locate(/obj/effect/landmark/start/bo/helms) in department_command_spawns

/datum/outfit/job/bofficer/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	var/obj/item/weapon/implant/mindshield/L = new/obj/item/weapon/implant/mindshield(H)
	L.imp_in = H
	L.implanted = 1
	H.sec_hud_set_implants()

	var/obj/item/weapon/card/id/W = H.wear_id
	W.access |= post_access

	if(access_weapons_console in W.access) //I'm sorry
		H.job = "Weapons Officer"
	if(access_helms_console in W.access)
		H.job = "Helms Officer"

	W.assignment = H.job
	W.update_label(newjob=W.assignment)
	data_core.manifest_modify(W.registered_name, W.assignment)

	var/obj/item/device/pda/P = H.belt
	if(istype(P))
		P.ownjob = W.assignment
		P.update_label() //grrr

	var/turf/T
	if(spawn_point)
		T = get_turf(spawn_point)
		H.Move(T)

	if(post)
		H << "<span class='alert'><b>You have been assigned to [post], and only [post]. Do not try to take over other consoles, unless authorized by the captain or XO.</b></span>"

	announce_officer(H) //the smell of a new proc...AH
