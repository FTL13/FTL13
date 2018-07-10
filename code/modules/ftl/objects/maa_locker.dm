/obj/structure/closet/secure_closet/masteratarms
	name = "\proper master at arms's locker"
	req_access = list(ACCESS_ARMORY)
	icon_state = "masteratarms"

/obj/structure/closet/secure_closet/masteratarms/PopulateContents()
	..()
	new /obj/item/device/radio/headset/headset_sec(src)
	new /obj/item/clothing/suit/armor/vest/masteratarms(src)
	new /obj/item/clothing/head/masteratarms(src)
	new /obj/item/clothing/head/beret/sec/navymasteratarms(src)
	new /obj/item/clothing/suit/armor/vest/masteratarms/alt(src)
	new /obj/item/clothing/under/rank/masteratarms/navyblue(src)
	new /obj/item/clothing/glasses/hud/security/sunglasses(src)
	new /obj/item/weapon/holosign_creator/security(src)
	new /obj/item/clothing/mask/gas/sechailer(src)
	new /obj/item/weapon/storage/box/zipties(src)
	new /obj/item/weapon/storage/box/flashbangs(src)
	new /obj/item/weapon/storage/belt/security/full(src)
	new /obj/item/device/flashlight/seclite(src)
	new /obj/item/clothing/gloves/krav_maga/sec(src)
	new /obj/item/weapon/door_remote/head_of_security(src)
	new /obj/item/weapon/gun/ballistic/shotgun/automatic/combat/compact(src)
