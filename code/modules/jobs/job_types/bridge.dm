/*
Bridge Officer
*/
/datum/job/bofficer
	title = "Bridge Officer"
	flag = BOFFICER
	department_head = list("Captain", "Executive Officer")
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the captain, the executive officer"
	selection_color = "#6ca2e2"
	req_admin_notify = 1
	minimal_player_age = 14

	outfit = /datum/outfit/job/bofficer

	access = list(access_heads, access_helm, access_maint_tunnels)
	minimal_access = list(access_heads, access_helm, access_maint_tunnels)

var/list/posts = list("weapons", "helms")

/datum/outfit/job/bofficer //utilizes HoP for now
  name = "Bridge Officer"

  belt = /obj/item/device/pda
  glasses = /obj/item/clothing/glasses/sunglasses
  ears = /obj/item/device/radio/headset/heads/hop
  uniform =  /obj/item/clothing/under/rank/head_of_personnel
  shoes = /obj/item/clothing/shoes/sneakers/brown
  head = /obj/item/clothing/head/hopcap

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

  var/turf/T
  if(spawn_point)
    T = get_turf(spawn_point)
    H.Move(T)

  if(post)
    H << "<b>You have been assigned to [post], and only [post]. Do not try to take over other consoles, unless authorized by the captain or XO.</b>"

  announce_head(H, list("Command"))
