//miscellaneous spacesuits
/*
Contains:
 - Captain's spacesuit
 - Death squad's hardsuit
 - SWAT suit
 - Officer's beret/spacesuit
 - NASA Voidsuit
 - Father Christmas' magical clothes
 - Pirate's spacesuit
 - Pirate's Steampunk Spacesuit
 - ERT hardsuit: command, sec, engi, med
 - EVA spacesuit
 - Freedom's spacesuit (freedom from vacuum's oppression)
 - Carp hardsuit
 - EPS
*/

	//Captain's space suit, not hardsuits because no flashlight!
/obj/item/clothing/head/helmet/space/captain
	name = "captain's space helmet"
	icon_state = "capspace"
	item_state = "capspacehelmet"
	desc = "A special helmet designed for only the most fashionable of military figureheads."
	flags_inv = HIDEFACE|HIDEEARS|HIDEHAIR
	permeability_coefficient = 0.01
	armor = list(melee = 40, bullet = 50, laser = 50, energy = 25, bomb = 50, bio = 100, rad = 50)

/obj/item/clothing/suit/space/captain
	name = "captain's space suit"
	desc = "A bulky, heavy-duty piece of exclusive Nanotrasen armor. YOU are in charge!"
	icon_state = "caparmor"
	item_state = "capspacesuit"
	w_class = 4
	allowed = list(/obj/item/weapon/tank/internals, /obj/item/device/flashlight,/obj/item/weapon/gun/energy, /obj/item/weapon/gun/projectile, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/weapon/melee/baton,/obj/item/weapon/restraints/handcuffs)
	armor = list(melee = 40, bullet = 50, laser = 50, energy = 25, bomb = 50, bio = 100, rad = 50)


	//Death squad armored space suits, not hardsuits!
/obj/item/clothing/head/helmet/space/hardsuit/deathsquad
	name = "deathsquad helmet"
	desc = "That's not red paint. That's real blood."
	icon_state = "deathsquad"
	item_state = "deathsquad"
	armor = list(melee = 80, bullet = 80, laser = 50, energy = 50, bomb = 100, bio = 100, rad = 100)
	strip_delay = 130
	max_heat_protection_temperature = FIRE_IMMUNITY_HELM_MAX_TEMP_PROTECT
	unacidable = 1
	actions_types = list()

/obj/item/clothing/head/helmet/space/hardsuit/deathsquad/attack_self(mob/user)
	return

/obj/item/clothing/suit/space/hardsuit/deathsquad
	name = "deathsquad suit"
	desc = "A heavily armored, advanced space suit that protects against most forms of damage."
	icon_state = "deathsquad"
	item_state = "swat_suit"
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/restraints/handcuffs,/obj/item/weapon/tank/internals,/obj/item/weapon/kitchen/knife/combat)
	armor = list(melee = 80, bullet = 80, laser = 50, energy = 50, bomb = 100, bio = 100, rad = 100)
	strip_delay = 130
	max_heat_protection_temperature = FIRE_IMMUNITY_SUIT_MAX_TEMP_PROTECT
	unacidable = 1
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/deathsquad
	dog_fashion = /datum/dog_fashion/back/deathsquad

	//NEW SWAT suit
/obj/item/clothing/suit/space/swat
	name = "SWAT armor"
	desc = "Space-proof tactical SWAT armor."
	icon_state = "heavy"
	item_state = "swat_suit"
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/restraints/handcuffs,/obj/item/weapon/tank/internals,/obj/item/weapon/kitchen/knife/combat)
	armor = list(melee = 40, bullet = 30, laser = 30,energy = 30, bomb = 50, bio = 90, rad = 20)
	strip_delay = 120

/obj/item/clothing/head/helmet/space/beret
	name = "officer's beret"
	desc = "An armored beret commonly used by special operations officers. Uses advanced force field technology to protect the head from space."
	icon_state = "beret_badge"
	flags = STOPSPRESSUREDMAGE
	flags_inv = 0
	armor = list(melee = 80, bullet = 80, laser = 50, energy = 50, bomb = 100, bio = 100, rad = 100)
	strip_delay = 130
	max_heat_protection_temperature = FIRE_IMMUNITY_HELM_MAX_TEMP_PROTECT
	unacidable = 1

/obj/item/clothing/suit/space/officer
	name = "officer's jacket"
	desc = "An armored, space-proof jacket used in special operations."
	icon_state = "detective"
	item_state = "det_suit"
	blood_overlay_type = "coat"
	slowdown = 0
	flags_inv = 0
	w_class = 3
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/restraints/handcuffs,/obj/item/weapon/tank/internals)
	armor = list(melee = 80, bullet = 80, laser = 50, energy = 50, bomb = 100, bio = 100, rad = 100)
	strip_delay = 130
	max_heat_protection_temperature = FIRE_IMMUNITY_HELM_MAX_TEMP_PROTECT
	unacidable = 1


	//NASA Voidsuit
/obj/item/clothing/head/helmet/space/nasavoid
	name = "NASA Void Helmet"
	desc = "An old, NASA Centcom branch designed, dark red space suit helmet."
	icon_state = "void"
	item_state = "void"

/obj/item/clothing/suit/space/nasavoid
	name = "NASA Voidsuit"
	icon_state = "void"
	item_state = "void"
	desc = "An old, NASA Centcom branch designed, dark red space suit."
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals,/obj/item/device/multitool)

/obj/item/clothing/suit/space/nasavoid/defender
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/restraints/handcuffs,/obj/item/weapon/tank/internals)

	//Space santa outfit suit
/obj/item/clothing/head/helmet/space/santahat
	name = "Santa's hat"
	desc = "Ho ho ho. Merrry X-mas!"
	icon_state = "santahat"
	flags = STOPSPRESSUREDMAGE
	flags_cover = HEADCOVERSEYES

	dog_fashion = /datum/dog_fashion/head/santa

/obj/item/clothing/suit/space/santa
	name = "Santa's suit"
	desc = "Festive!"
	icon_state = "santa"
	item_state = "santa"
	slowdown = 0
	flags = STOPSPRESSUREDMAGE
	allowed = list(/obj/item) //for stuffing exta special presents


	//Space pirate outfit
/obj/item/clothing/head/helmet/space/pirate
	name = "pirate hat"
	desc = "Yarr."
	icon_state = "pirate"
	item_state = "pirate"
	armor = list(melee = 30, bullet = 50, laser = 30,energy = 15, bomb = 30, bio = 30, rad = 30)
	flags = STOPSPRESSUREDMAGE
	strip_delay = 40
	put_on_delay = 20
	flags_cover = HEADCOVERSEYES

/obj/item/clothing/suit/space/pirate
	name = "pirate coat"
	desc = "Yarr."
	icon_state = "pirate"
	item_state = "pirate"
	w_class = 3
	flags_inv = 0
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/restraints/handcuffs,/obj/item/weapon/tank/internals, /obj/item/weapon/melee/energy/sword/pirate, /obj/item/clothing/glasses/eyepatch, /obj/item/weapon/reagent_containers/food/drinks/bottle/rum)
	slowdown = 0
	armor = list(melee = 30, bullet = 50, laser = 30,energy = 15, bomb = 30, bio = 30, rad = 30)
	strip_delay = 40
	put_on_delay = 20

//Steampunk pirate outfit

/obj/item/clothing/head/helmet/space/hardsuit/steampunk_pirate
	name = "steampunk pirate helmet"
	desc = "It's literaly just rust and scrap welded together, how is this even airtight?"
	icon_state = "steampunk_pirate"
	item_state = "steampunk_pirate"
	armor = list(melee = 70, bullet = 30, laser = 20,energy = 15, bomb = 40, bio = 30, rad = 30)
	strip_delay = 130

/obj/item/clothing/suit/space/hardsuit/steampunk_pirate
	name = "steampunk pirate hardsuit"
	desc = "It's literaly just rust and scrap welded together, how is this even airtight?"
	icon_state = "steampunk_pirate"
	item_state = "steampunk_pirate"
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/restraints/handcuffs,/obj/item/weapon/tank/internals, /obj/item/weapon/melee/energy/sword/pirate, /obj/item/clothing/glasses/eyepatch, /obj/item/weapon/reagent_containers/food/drinks/bottle/rum)
	slowdown = 1
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/steampunk_pirate
	armor = list(melee = 70, bullet = 30, laser = 20,energy = 15, bomb = 40, bio = 30, rad = 30)
	strip_delay = 130
	put_on_delay = 20
	item_color = "pirate"

/obj/item/clothing/suit/space/hardsuit/steampunk_pirate/ToggleHelmet(sound, tint)
	sound = 'sound/effects/bin_close.ogg'
	..()

/obj/item/clothing/suit/space/hardsuit/steampunk_pirate/RemoveHelmet(sound, tint)
	sound = 'sound/effects/bin_open.ogg'
	..()

	//Emergency Response Team suits
/obj/item/clothing/head/helmet/space/hardsuit/ert
	name = "emergency response unit helmet"
	desc = "Standard issue command helmet for the ERT"
	icon_state = "hardsuit0-ert_commander"
	item_state = "hardsuit0-ert_commander"
	item_color = "ert_commander"
	armor = list(melee = 65, bullet = 50, laser = 50, energy = 50, bomb = 50, bio = 100, rad = 100)
	strip_delay = 130
	flags = STOPSPRESSUREDMAGE | THICKMATERIAL | NODROP
	brightness_on = 7

/obj/item/clothing/suit/space/hardsuit/ert
	name = "emergency response team suit"
	desc = "Standard issue command suit for the ERT."
	icon_state = "ert_command"
	item_state = "ert_command"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/ert
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/restraints/handcuffs,/obj/item/weapon/tank/internals)
	armor = list(melee = 30, bullet = 50, laser = 30, energy = 50, bomb = 50, bio = 100, rad = 100)
	slowdown = 0
	strip_delay = 130

	//ERT Security
/obj/item/clothing/head/helmet/space/hardsuit/ert/sec
	desc = "Standard issue security helmet for the ERT."
	icon_state = "hardsuit0-ert_security"
	item_state = "hardsuit0-ert_security"
	item_color = "ert_security"

/obj/item/clothing/suit/space/hardsuit/ert/sec
	desc = "Standard issue security suit for the ERT."
	icon_state = "ert_security"
	item_state = "ert_security"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/ert/sec

	//ERT Engineering
/obj/item/clothing/head/helmet/space/hardsuit/ert/engi
	desc = "Standard issue engineer helmet for the ERT."
	icon_state = "hardsuit0-ert_engineer"
	item_state = "hardsuit0-ert_engineer"
	item_color = "ert_engineer"

/obj/item/clothing/suit/space/hardsuit/ert/engi
	desc = "Standard issue engineer suit for the ERT."
	icon_state = "ert_engineer"
	item_state = "ert_engineer"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/ert/engi

	//ERT Medical
/obj/item/clothing/head/helmet/space/hardsuit/ert/med
	desc = "Standard issue medical helmet for the ERT."
	icon_state = "hardsuit0-ert_medical"
	item_state = "hardsuit0-ert_medical"
	item_color = "ert_medical"

/obj/item/clothing/suit/space/hardsuit/ert/med
	desc = "Standard issue medical suit for the ERT."
	icon_state = "ert_medical"
	item_state = "ert_medical"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/ert/med

/obj/item/clothing/suit/space/eva
	name = "EVA suit"
	icon_state = "space"
	item_state = "s_suit"
	desc = "A lightweight space suit with the basic ability to protect the wearer from the vacuum of space during emergencies."
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 20)

/obj/item/clothing/head/helmet/space/eva
	name = "EVA helmet"
	icon_state = "space"
	item_state = "space"
	desc = "A lightweight space helmet with the basic ability to protect the wearer from the vacuum of space during emergencies."
	flash_protect = 0
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 20)

/obj/item/clothing/head/helmet/space/freedom
	name = "eagle helmet"
	desc = "An advanced, space-proof helmet. It appears to be modeled after an old-world eagle."
	icon_state = "griffinhat"
	item_state = "griffinhat"
	armor = list(melee = 20, bullet = 40, laser = 30, energy = 25, bomb = 100, bio = 100, rad = 100)
	strip_delay = 130
	max_heat_protection_temperature = FIRE_IMMUNITY_HELM_MAX_TEMP_PROTECT
	unacidable = 1

/obj/item/clothing/suit/space/freedom
	name = "eagle suit"
	desc = "An advanced, light suit, fabricated from a mixture of synthetic feathers and space-resistant material. A gun holster appears to be intergrated into the suit and the wings appear to be stuck in 'freedom' mode."
	icon_state = "freedom"
	item_state = "freedom"
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/restraints/handcuffs,/obj/item/weapon/tank/internals)
	armor = list(melee = 20, bullet = 40, laser = 30,energy = 25, bomb = 100, bio = 100, rad = 100)
	strip_delay = 130
	max_heat_protection_temperature = FIRE_IMMUNITY_HELM_MAX_TEMP_PROTECT
	unacidable = 1

//Carpsuit, bestsuit, lovesuit
/obj/item/clothing/head/helmet/space/hardsuit/carp
	name = "carp helmet"
	desc = "Spaceworthy and it looks like a space carp's head, smells like one too."
	icon_state = "carp_helm"
	item_state = "syndicate"
	armor = list(melee = -20, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 100, rad = 75)	//As whimpy as a space carp
	brightness_on = 0 //luminosity when on
	actions_types = list()
	flags = STOPSPRESSUREDMAGE | THICKMATERIAL | NODROP


/obj/item/clothing/suit/space/hardsuit/carp
	name = "carp space suit"
	desc = "A slimming piece of dubious space carp technology, you suspect it won't stand up to hand-to-hand blows."
	icon_state = "carp_suit"
	item_state = "space_suit_syndicate"
	slowdown = 0	//Space carp magic, never stop believing
	armor = list(melee = -20, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 100, rad = 75) //As whimpy whimpy whoo
	allowed = list(/obj/item/weapon/tank/internals, /obj/item/weapon/gun/projectile/automatic/speargun)	//I'm giving you a hint here
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/carp


/obj/item/clothing/head/helmet/space/hardsuit/ert/paranormal
	name = "paranormal response unit helmet"
	desc = "A helmet worn by those who deal with paranormal threats for a living."
	icon_state = "hardsuit0-prt"
	item_state = "hardsuit0-prt"
	item_color = "knight_grey"
	max_heat_protection_temperature = FIRE_IMMUNITY_HELM_MAX_TEMP_PROTECT
	actions_types = list()

/obj/item/clothing/suit/space/hardsuit/ert/paranormal
	name = "paranormal response team suit"
	desc = "Powerful wards are built into this hardsuit, protecting the user from all manner of paranormal threats."
	icon_state = "knight_grey"
	item_state = "knight_grey"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/ert/paranormal
	max_heat_protection_temperature = FIRE_IMMUNITY_SUIT_MAX_TEMP_PROTECT


/obj/item/clothing/suit/space/hardsuit/ert/paranormal/New()
	..()
	new /obj/item/weapon/nullrod(src)

/obj/item/clothing/suit/space/hardsuit/ert/paranormal/inquisitor
	name = "inquisitor's hardsuit"
	icon_state = "hardsuit-inq"
	item_state = "hardsuit-inq"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/ert/paranormal/inquisitor

/obj/item/clothing/head/helmet/space/hardsuit/ert/paranormal/inquisitor
	name = "inquisitor's helmet"
	icon_state = "hardsuit0-inq"
	item_state = "hardsuit0-inq"

/obj/item/clothing/suit/space/hardsuit/ert/paranormal/beserker
	name = "champion's hardsuit"
	desc = "Voices echo from the hardsuit, driving the user insane."
	icon_state = "hardsuit-beserker"
	item_state = "hardsuit-beserker"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/ert/paranormal/beserker

/obj/item/clothing/head/helmet/space/hardsuit/ert/paranormal/beserker
	name = "champion's helmet"
	desc = "Peering into the eyes of the helmet is enough to seal damnation."
	icon_state = "hardsuit0-beserker"
	item_state = "hardsuit0-beserker"

//TODO: Move to separate file

/obj/item/clothing/suit/space/hardsuit/disposable
	name = "disposable hardsuit"
	desc = "This hardsuit can only be used once before going to waste. It also degrades over time when in hazardous environments."
	icon_state = "empressure_suit"
	item_state = "empressure_suit"
	w_class = 2 //fits in boxes
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/disposable
	var/condition = 100
	var/list/ripped = list()
	var/worn = FALSE

/obj/item/clothing/head/helmet/space/hardsuit/disposable
	name = "disposable helmet"
	desc = "When you remove this helmet from your head, you may never use it again."
	icon_state = "empressure_helmet"
	item_state = "empressure_helmet"
	tint = 2
	actions_types = list()

/obj/item/clothing/suit/space/hardsuit/disposable/New()
	..()
	flags |= DROPDEL

/obj/item/clothing/suit/space/hardsuit/disposable/ToggleHelmet(sound, tint)
	sound = 'sound/effects/rustle5.ogg'
	..()

/obj/item/clothing/suit/space/hardsuit/disposable/RemoveHelmet(sound, tint)
	sound = 'sound/effects/rustle5.ogg'
	..()

/obj/item/clothing/suit/space/hardsuit/disposable/equipped(mob/user, slot)
	..()
	if(slot == slot_wear_suit)
		START_PROCESSING(SSobj, src)
		worn = TRUE
		playsound(src.loc, 'sound/effects/inflate.ogg', 50, 1)
		to_chat(user, "<span class='alert'>You are now protected from hazardous levels of pressure and temperature. This won't last long, so seek shelter!</span>")

/obj/item/clothing/suit/space/hardsuit/disposable/process()
	var/mob/wearer = loc
	if(istype(wearer) && istype(wearer.get_item_by_slot(slot_wear_suit), /obj/item/clothing/suit/space/hardsuit/disposable))
		var/topass = degrade()
		chres(topass)

/obj/item/clothing/suit/space/hardsuit/disposable/dropped(mob/user)
	if(worn)
		RemoveHelmet('sound/effects/rustle5.ogg')
		STOP_PROCESSING(SSobj, src)
		qdel(src)
		var/obj/item/epsused/used = new /obj/item/epsused()
		user.put_in_active_hand(used)

/obj/item/clothing/suit/space/hardsuit/disposable/proc/degrade()
	var/mob/wearer = loc
	var/turf/T = get_turf(wearer)
	var/datum/gas_mixture/env = T.return_air()

	var/list/TLV = list( // Breathable air.
		"pressure"		= new/datum/tlv(ONE_ATMOSPHERE * 0.80, ONE_ATMOSPHERE *  0.90, ONE_ATMOSPHERE * 1.10, ONE_ATMOSPHERE * 1.20), // kPa
		"temperature"	= new/datum/tlv(T0C, T0C+10, T0C+40, T0C+66) // K
	)

	var/pressure = env.return_pressure()
	var/temperature = env.temperature
	var/datum/tlv/currtlv
	var/templevel
	var/presslevel

	if(T && env) //set up so it degrades fully over 10 mins
		currtlv = TLV["temperature"]
		templevel = currtlv.get_danger_level(temperature)
		if(templevel == 1 || templevel == 2)
			condition -= 0.115
		currtlv = TLV["pressure"]
		presslevel = currtlv.get_danger_level(pressure)
		if(presslevel == 1 || presslevel == 2)
			condition -= 0.205

	return list(templevel, presslevel)

/obj/item/clothing/suit/space/hardsuit/disposable/proc/chres(var/list/check)
	var/mob/user = loc
	if(condition >= 80)
		return
	if(condition < 80 && check[1] != 0)
		var/decrease = pick(0.11, 0.12, 0.13)
		var/increase = pick(0.11, 0.12, 0.13)
		min_cold_protection_temperature += increase
		max_heat_protection_temperature -= decrease
		if(prob(10))
			to_chat(user, "<span class='alert'>[src] rustles, slowly degrading by itself.</span>")
	if(condition < 50 && condition > 20 && check[2] != 0 && flags & STOPSPRESSUREDMAGE)
		if(prob(7))
			to_chat(user, "<span class='danger'>A hole appears in [src] and it deflates in a moments notice! You are no longer protected from pressure damage!</span>")
			flags &= ~STOPSPRESSUREDMAGE
	if(condition < 20 && check[1] != 0 && check[2] != 0)
		if(prob(5))
			var/torip = pick(HANDS, FEET)
			if(torip in ripped)
				return
			var/bodypart = ""
			if(torip == HANDS)
				bodypart = "hands"
			else
				bodypart = "feet"
			to_chat(user, "<span class='danger'>[src] rips and tears, and you're suddenly left without protection for your [bodypart]!</span>")
			body_parts_covered &= ~torip
			cold_protection &= ~torip
			heat_protection &= ~torip
			ripped += torip
		if(condition <= 0)
			to_chat(user, "<span class='danger'>[src] rips to shreds, leaving you at the mercy of the environment!</span>")
			qdel()

/obj/item/epsused
	name = "used disposable hardsuit"
	desc = "This suit has already been used. It's useless."
	icon = 'icons/obj/clothing/suits.dmi'
	icon_state = "empressure_suit"
