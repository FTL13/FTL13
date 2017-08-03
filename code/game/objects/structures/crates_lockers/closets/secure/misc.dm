/obj/structure/closet/secure_closet/ertCom
	name = "commander's closet"
	desc = "Emergency Response Team equipment locker."
	req_access = list(ACCESS_CENT_CAPTAIN)
	icon_state = "cap"

/obj/structure/closet/secure_closet/ertCom/PopulateContents()
	..()
	new /obj/item/weapon/storage/firstaid/regular(src)
	new /obj/item/weapon/storage/box/handcuffs(src)
	new /obj/item/device/aicard(src)
	new /obj/item/device/assembly/flash/handheld(src)
	if(prob(50))
		new /obj/item/ammo_box/magazine/m50(src)
		new /obj/item/ammo_box/magazine/m50(src)
		new /obj/item/weapon/gun/ballistic/automatic/pistol/deagle(src)
	else
		new /obj/item/ammo_box/a357(src)
		new /obj/item/ammo_box/a357(src)
		new /obj/item/weapon/gun/ballistic/revolver/mateba(src)

/obj/structure/closet/secure_closet/ertSec
	name = "security closet"
	desc = "Emergency Response Team equipment locker."
	req_access = list(ACCESS_CENT_SPECOPS)
	icon_state = "hos"

/obj/structure/closet/secure_closet/ertSec/PopulateContents()
	..()
	new /obj/item/weapon/storage/box/flashbangs(src)
	new /obj/item/weapon/storage/box/teargas(src)
	new /obj/item/weapon/storage/box/flashes(src)
	new /obj/item/weapon/storage/box/handcuffs(src)
	new /obj/item/weapon/shield/riot/tele(src)

/obj/structure/closet/secure_closet/ertMed
	name = "medical closet"
	desc = "Emergency Response Team equipment locker."
	req_access = list(ACCESS_CENT_MEDICAL)
	icon_state = "cmo"

/obj/structure/closet/secure_closet/ertMed/PopulateContents()
	..()
	new /obj/item/weapon/storage/firstaid/o2(src)
	new /obj/item/weapon/storage/firstaid/toxin(src)
	new /obj/item/weapon/storage/firstaid/fire(src)
	new /obj/item/weapon/storage/firstaid/brute(src)
	new /obj/item/weapon/storage/firstaid/regular(src)
	new /obj/item/weapon/defibrillator/compact/combat/loaded(src)
	new /mob/living/simple_animal/bot/medbot(src)

/obj/structure/closet/secure_closet/ertEngi
	name = "engineer closet"
	desc = "Emergency Response Team equipment locker."
	req_access = list(ACCESS_CENT_STORAGE)
	icon_state = "ce"

/obj/structure/closet/secure_closet/ertEngi/PopulateContents()
	..()
	new /obj/item/stack/sheet/plasteel(src, 50)
	new /obj/item/stack/sheet/metal(src, 50)
	new /obj/item/stack/sheet/glass(src, 50)
	new /obj/item/stack/sheet/mineral/sandbags(src, 30)
	new /obj/item/clothing/shoes/magboots(src)
	new /obj/item/weapon/storage/box/metalfoam(src)
	for(var/i in 1 to 3)
		new /obj/item/weapon/rcd_ammo/large(src)

/obj/structure/closet/secure_closet/iaa
	name = "iaa's closet"
	desc = "All the stuff you need to scream at people for breaking SoP and DoP!"
	req_access = list(ACCESS_CENT_SPECOPS)
	icon_state = "iaa"

/obj/structure/closet/secure_closet/iaa/PopulateContents()
	..()
	new /obj/item/weapon/melee/classic_baton/telescopic(src)
	new /obj/item/weapon/restraints/handcuffs/cable/zipties(src)
	new /obj/item/clothing/under/lawer/blacksuit/iaa(src)
	new /obj/item/clothing/suit/toggle/lawer/black/iaa(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/weapon/storage/briefcase/lawyer(src)

/obj/structure/closet/secure_closet/rshield
	name = "redshield's closet"
	desc = "Everything you need to be a human shield!"
	req_access = list(ACCESS_CENT_TELEPORTER)
	icon_state = "hos"

/obj/structure/closet/secure_closet/rshield/PopulateContents()
	..()
	new /obj/item/weapon/storage/belt/security/full(src)
	new /obj/item/weapon/storage/firstaid/regular(src)
	new /obj/item/weapon/melee/baton/loaded(src)
	new /obj/item/weapon/kitchen/knife/combat(src)
	new /obj/item/weapon/storage/box/handcuffs(src)
	new /obj/item/clothing/under/trek/engsec(src)
	new /obj/item/clothing/suit/armor/vest(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/glasses/hud/security/sunglasses(src)
	new /obj/item/weapon/gun/energy/e_gun/advtaser(src)
