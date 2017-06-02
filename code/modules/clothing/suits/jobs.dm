/*
 * Job related
 */

//Botanist
/obj/item/clothing/suit/apron
	name = "apron"
	desc = "A basic blue apron."
	icon_state = "apron"
	item_state = "apron"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST|GROIN
	allowed = list(/obj/item/weapon/reagent_containers/spray/plantbgone,/obj/item/device/plant_analyzer,/obj/item/seeds,/obj/item/weapon/reagent_containers/glass/bottle, /obj/item/weapon/reagent_containers/glass/beaker, /obj/item/weapon/cultivator,/obj/item/weapon/reagent_containers/spray/pestspray,/obj/item/weapon/hatchet,/obj/item/weapon/storage/bag/plants)

//Captain
/obj/item/clothing/suit/captunic
	name = "captain's parade tunic"
	desc = "Worn by a Captain to show their class."
	icon_state = "captunic"
	item_state = "bio_suit"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT
	allowed = list(/obj/item/weapon/disk, /obj/item/weapon/stamp, /obj/item/weapon/reagent_containers/food/drinks/flask, /obj/item/weapon/melee, /obj/item/weapon/storage/lockbox/medal, /obj/item/device/assembly/flash/handheld, /obj/item/weapon/storage/box/matches, /obj/item/weapon/lighter, /obj/item/clothing/mask/cigarette, /obj/item/weapon/storage/fancy/cigarettes, /obj/item/weapon/tank/internals/emergency_oxygen)

//Chaplain
/obj/item/clothing/suit/hooded/chaplain_hoodie
	name = "chaplain hoodie"
	desc = "This suit says to you 'hush'!"
	icon_state = "chaplain_hoodie"
	item_state = "chaplain_hoodie"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	allowed = list(/obj/item/weapon/storage/book/bible, /obj/item/weapon/nullrod, /obj/item/weapon/reagent_containers/food/drinks/bottle/holywater, /obj/item/weapon/storage/fancy/candle_box, /obj/item/candle, /obj/item/weapon/tank/internals/emergency_oxygen)
	hoodtype = /obj/item/clothing/head/hooded/chaplain_hood

/obj/item/clothing/head/hooded/chaplain_hood
	name = "chaplain hood"
	desc = "For protecting your identity when immolating demons."
	icon_state = "chaplain_hood"
	body_parts_covered = HEAD
	flags_inv = HIDEHAIR|HIDEFACE|HIDEEARS

/obj/item/clothing/suit/nun
	name = "nun robe"
	desc = "Maximum piety in this star system."
	icon_state = "nun"
	item_state = "nun"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS|HANDS
	flags_inv = HIDESHOES|HIDEJUMPSUIT
	allowed = list(/obj/item/weapon/storage/book/bible, /obj/item/weapon/nullrod, /obj/item/weapon/reagent_containers/food/drinks/bottle/holywater, /obj/item/weapon/storage/fancy/candle_box, /obj/item/candle, /obj/item/weapon/tank/internals/emergency_oxygen)

/obj/item/clothing/suit/studentuni
	name = "student robe"
	desc = "The uniform of a bygone institute of learning."
	icon_state = "studentuni"
	item_state = "studentuni"
	body_parts_covered = ARMS|CHEST
	allowed = list(/obj/item/weapon/storage/book/bible, /obj/item/weapon/nullrod, /obj/item/weapon/reagent_containers/food/drinks/bottle/holywater, /obj/item/weapon/storage/fancy/candle_box, /obj/item/candle, /obj/item/weapon/tank/internals/emergency_oxygen)

/obj/item/clothing/suit/witchhunter
	name = "witchunter garb"
	desc = "This worn outfit saw much use back in the day."
	icon_state = "witchhunter"
	item_state = "witchhunter"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	allowed = list(/obj/item/weapon/storage/book/bible, /obj/item/weapon/nullrod, /obj/item/weapon/reagent_containers/food/drinks/bottle/holywater, /obj/item/weapon/storage/fancy/candle_box, /obj/item/candle, /obj/item/weapon/tank/internals/emergency_oxygen)

//Chef
/obj/item/clothing/suit/toggle/chef
	name = "chef's apron"
	desc = "An apron-jacket used by a high class chef."
	icon_state = "chef"
	item_state = "chef"
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	body_parts_covered = CHEST|GROIN|ARMS
	allowed = list(/obj/item/weapon/kitchen)
	togglename = "sleeves"

//Cook
/obj/item/clothing/suit/apron/chef
	name = "cook's apron"
	desc = "A basic, dull, white chef's apron."
	icon_state = "apronchef"
	item_state = "apronchef"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST|GROIN
	allowed = list(/obj/item/weapon/kitchen)

//Detective
/obj/item/clothing/suit/det_suit
	name = "trenchcoat"
	desc = "An 18th-century multi-purpose trenchcoat. Someone who wears this means serious business."
	icon_state = "detective"
	item_state = "det_suit"
	blood_overlay_type = "coat"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	allowed = list(/obj/item/weapon/tank/internals/emergency_oxygen,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/device/flashlight,/obj/item/weapon/gun/energy,/obj/item/weapon/gun/ballistic,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/restraints/handcuffs,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/lighter,/obj/item/device/detective_scanner,/obj/item/device/taperecorder,/obj/item/weapon/melee/classic_baton)
	armor = list(melee = 25, bullet = 10, laser = 25, energy = 10, bomb = 0, bio = 0, rad = 0, fire = 0, acid = 45)
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/suit/det_suit/grey
	name = "noir trenchcoat"
	desc = "A hard-boiled private investigator's grey trenchcoat."
	icon_state = "greydet"
	item_state = "greydet"

//Engineering
/obj/item/clothing/suit/hazardvest
	name = "hazard vest"
	desc = "A high-visibility vest used in work zones."
	icon_state = "hazard"
	item_state = "hazard"
	blood_overlay_type = "armor"
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals/emergency_oxygen,/obj/item/device/t_scanner,/obj/item/device/radio)
	resistance_flags = 0
//Lawyer
/obj/item/clothing/suit/toggle/lawyer
	name = "blue suit jacket"
	desc = "A snappy dress jacket."
	icon_state = "suitjacket_blue"
	item_state = "suitjacket_blue"
	blood_overlay_type = "coat"
	body_parts_covered = CHEST|ARMS
	togglename = "buttons"

/obj/item/clothing/suit/toggle/lawyer/purple
	name = "purple suit jacket"
	desc = "A foppish dress jacket."
	icon_state = "suitjacket_purp"
	item_state = "suitjacket_purp"

/obj/item/clothing/suit/toggle/lawyer/black
	name = "black suit jacket"
	desc = "A professional suit jacket."
	icon_state = "suitjacket_black"
	item_state = "ro_suit"


//Mime
/obj/item/clothing/suit/suspenders
	name = "suspenders"
	desc = "They suspend the illusion of the mime's play."
	icon = 'icons/obj/clothing/belts.dmi'
	icon_state = "suspenders"
	blood_overlay_type = "armor" //it's the less thing that I can put here

//Security
/obj/item/clothing/suit/security/officer
	name = "security officer's jacket"
	desc = "This jacket is for those special occasions when a security officer isn't required to wear their armor."
	icon_state = "officerbluejacket"
	item_state = "officerbluejacket"
	body_parts_covered = CHEST|ARMS

/obj/item/clothing/suit/security/masteratarms
	name = "master-at-arms's jacket"
	desc = "Perfectly suited for the master-at-arms that wants to leave an impression of style on those who visit the brig."
	icon_state = "masteratarmsbluejacket"
	item_state = "masteratarmsbluejacket"
	body_parts_covered = CHEST|ARMS

/obj/item/clothing/suit/security/hos
	name = "head of security's jacket"
	desc = "This piece of clothing was specifically designed for asserting superior authority."
	icon_state = "hosbluejacket"
	item_state = "hosbluejacket"
	body_parts_covered = CHEST|ARMS

//Surgeon
/obj/item/clothing/suit/apron/surgical
	name = "surgical apron"
	desc = "A sterile blue surgical apron."
	icon_state = "surgical"
	allowed = list(/obj/item/weapon/scalpel, /obj/item/weapon/surgical_drapes, /obj/item/weapon/cautery, /obj/item/weapon/hemostat, /obj/item/weapon/retractor)

//Curator
/obj/item/clothing/suit/curator
	name = "treasure hunter's coat"
	desc = "Both fashionable and lightly armoured, this jacket is favoured by treasure hunters the galaxy over."
	icon_state = "curator"
	item_state = "curator"
	blood_overlay_type = "coat"
	body_parts_covered = CHEST|ARMS
	allowed = list(/obj/item/weapon/tank/internals, /obj/item/weapon/melee/curator_whip)
	armor = list(melee = 25, bullet = 10, laser = 25, energy = 10, bomb = 0, bio = 0, rad = 0, fire = 0, acid = 45)
	cold_protection = CHEST|ARMS
	heat_protection = CHEST|ARMS


//Service uniforms

/obj/item/clothing/suit/toggle/service/assistant
	name = "assistant's service uniform"
	desc = "Worn around the ship for comfort and style by assistants, although it is no way near as fancy as the other ones it still feels quite well made."
	icon_state = "service_assistant"
	item_state = "service_assistant" //TODO add in item states
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals/emergency_oxygen,/obj/item/weapon/reagent_containers/glass/bottle,/obj/item/device/radio) //holds stuff so that crew will actually wear it

/obj/item/clothing/suit/toggle/service/clown
	name = "clown's service uniform"
	desc = "A jacket denoting a former admiral in the clown navy, the mime spun fibres are laced with pure bananium and it is slippery to the touch."
	icon_state = "service_clown"
	item_state = "service_clown" //TODO add in item states
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/bikehorn, /obj/item/weapon/tank/internals/emergency_oxygen,/obj/item/weapon/reagent_containers/glass/bottle,/obj/item/device/radio)

/obj/item/clothing/suit/toggle/service/clown/Crossed(AM)
	if(iscarbon(AM))
		var/mob/living/carbon/carbon = AM
		if(carbon.slip(2, 2, src, FALSE))
			visible_message("<span class='danger'>HONK!</span>")
//^ i just had to...

/obj/item/clothing/suit/toggle/service/bridge
	name = "bridge officer's service uniform"
	desc = "Worn around the ship by the bridge staff, it is well made and should last well."
	icon_state = "service_bridge"
	item_state = "service_bridge" //TODO add in item states
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals/emergency_oxygen,/obj/item/weapon/reagent_containers/glass/bottle,/obj/item/device/radio) //holds stuff so that crew will actually wear it


/obj/item/clothing/suit/toggle/service/captain
	name = "captain's service uniform"
	desc = "A cuban silk spun, highly luxury coat worn by only the best, it has a kevlar nanoweave to protect even the least popular captains from assasination."
	icon_state = "service_captain"
	item_state = "service_captain" //TODO add in item states
	allowed = list(/obj/item/weapon/disk, /obj/item/weapon/stamp, /obj/item/weapon/reagent_containers/food/drinks/flask, /obj/item/weapon/melee, /obj/item/weapon/storage/lockbox/medal, /obj/item/device/assembly/flash/handheld, /obj/item/weapon/storage/box/matches, /obj/item/weapon/lighter, /obj/item/clothing/mask/cigarette, /obj/item/weapon/storage/fancy/cigarettes, /obj/item/weapon/tank/internals/emergency_oxygen)
	armor = list(melee = 20, bullet = 30, laser = 20, energy = 10, bomb = 25, bio = 0, rad = 0)


/obj/item/clothing/suit/toggle/service/security
	name = "security officer's service uniform"
	desc = "Worn around the ship by those who police it, it has a lot of padding and is robust enough to replace armour."
	icon_state = "service_sec"
	item_state = "service_sec" //TODO add in item states
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals/emergency_oxygen,/obj/item/weapon/gun/energy/taser, /obj/item/weapon/reagent_containers/glass/bottle,/obj/item/device/radio,/obj/item/weapon/melee) //holds stuff so that crew will actually wear it
	armor = list(melee = 30, bullet = 30, laser = 30, energy = 10, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/suit/toggle/service/hos
	name = "Head Of Security's service uniform"
	desc = "Worn around the ship by the chief of security, it is heavily padded to protect the wearer in the line of duty."
	icon_state = "service_hos"
	item_state = "service_hos" //TODO add in item states
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals/emergency_oxygen,/obj/item/weapon/gun/energy/taser, /obj/item/weapon/reagent_containers/glass/bottle,/obj/item/device/radio,/obj/item/weapon/melee) //holds stuff so that crew will actually wear it
	armor = list(melee = 30, bullet = 30, laser = 30, energy = 10, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/suit/toggle/service/medical
	name = "medical officer's service uniform"
	desc = "Worn around the ship by its doctors, it is splash proof and machine washable."
	icon_state = "service_med"
	item_state = "service_med" //TODO add in item states
	allowed = list(/obj/item/weapon/scalpel, /obj/item/weapon/storage/firstaid/, /obj/item/weapon/surgical_drapes, /obj/item/weapon/cautery, /obj/item/weapon/hemostat, /obj/item/weapon/retractor)

/obj/item/clothing/suit/toggle/service/cmo
	name = "Chief Medical Officer's service uniform"
	desc = "A blue styled coat which doubles as a labcoat for the CMO.."
	icon_state = "service_cmo"
	item_state = "service_cmo" //TODO add in item states
	allowed = list(/obj/item/weapon/scalpel, /obj/item/weapon/storage/firstaid/, /obj/item/weapon/surgical_drapes, /obj/item/weapon/cautery, /obj/item/weapon/hemostat, /obj/item/weapon/retractor)

/obj/item/clothing/suit/toggle/service/cargo
	name = "cargo officer's service uniform"
	desc = "Worn around the ship by the cargonians, it has a box emblazened on the back."
	icon_state = "service_cargo"
	item_state = "service_cargo" //TODO add in item states
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals/emergency_oxygen,/obj/item/weapon/reagent_containers/glass/bottle,/obj/item/device/radio)

/obj/item/clothing/suit/toggle/service/munitions
	name = "munitions officer's service uniform"
	desc = "Worn around the ship by the MO, it is padded slightly to protect you"
	icon_state = "service_munitions"
	item_state = "service_munitions" //TODO add in item states
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals/emergency_oxygen,/obj/item/weapon/reagent_containers/glass/bottle,/obj/item/device/radio)
	armor = list(melee = 10, bullet = 10, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)


/obj/item/clothing/suit/toggle/service/science
	name = "science officer's service uniform"
	desc = "Worn around the ship by research staff, it feels more like a labcoat than a proper coat"
	icon_state = "service_science"
	item_state = "service_science" //TODO add in item states
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals/emergency_oxygen,/obj/item/weapon/reagent_containers/glass/bottle,/obj/item/device/radio)

/obj/item/clothing/suit/toggle/service/rd
	name = "Research Director's service uniform"
	desc = "Worn around the ship by the head researcher, it smells of curry and sweat from countless all-nighters"
	icon_state = "service_rd"
	item_state = "service_rd" //TODO add in item states
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals/emergency_oxygen,/obj/item/weapon/reagent_containers/glass/bottle,/obj/item/device/radio)

/obj/item/clothing/suit/toggle/service/civilian
	name = "Civilian service uniform"
	desc = "Worn around the ship by uncomissioned officers."
	icon_state = "service_civilian"
	item_state = "service_civilian" //TODO add in item states
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals/emergency_oxygen,/obj/item/weapon/reagent_containers/glass/bottle,/obj/item/device/radio,/obj/item/weapon/storage/bag/plants/portaseeder,/obj/item/device/plant_analyzer,/obj/item/weapon/cultivator,/obj/item/weapon/hatchet)

/obj/item/clothing/suit/toggle/service/xo/silly //meme coat for XO
	name = "XO's modified service uniform"
	desc = "Ian's favey wavey snuggley wuggly coat!."
	icon_state = "service_xosilly"
	item_state = "service_xosilly" //TODO add in item states
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals/emergency_oxygen,/obj/item/weapon/reagent_containers/glass/bottle,/obj/item/device/radio)

/obj/item/clothing/suit/toggle/service/xo
	name = "XO's modified service uniform"
	desc = "Worn by the second in command, this coat is padded and extremely comfortable."
	icon_state = "service_xo"
	item_state = "service_xo" //TODO add in item states
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals/emergency_oxygen,/obj/item/weapon/reagent_containers/glass/bottle,/obj/item/device/radio)

/obj/item/clothing/suit/toggle/service/engi
	name = "Engineer's service uniform"
	desc = "This jacket is worn by the workers on the ship, they keep you breathing and powered and all they get for it is this stupid jacket."
	icon_state = "service_eng"
	item_state = "service_eng" //TODO add in item states
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals/emergency_oxygen,/obj/item/weapon/reagent_containers/glass/bottle,/obj/item/device/radio)


/obj/item/clothing/suit/toggle/service/ce
	name = "Chief Engineer's service uniform"
	desc = "This jacket is worn by the Chief Engineer, it is very comfortable."
	icon_state = "service_ce"
	item_state = "service_ce" //TODO add in item states
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals/emergency_oxygen,/obj/item/weapon/reagent_containers/glass/bottle,/obj/item/device/radio)
