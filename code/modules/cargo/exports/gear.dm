// Armor, gloves, space suits - it all goes here

/datum/export/gear

// Security gear
/datum/export/gear/sec_helmet
	cost = 100
	unit_name = "helmet"
	export_types = list(/obj/item/clothing/head/helmet/sec)
	cost_modifiers = list("Security")

/datum/export/gear/sec_armor
	cost = 100
	unit_name = "armor vest"
	cost_modifiers = list("Security")
	export_types = list(/obj/item/clothing/suit/armor/vest)
	include_subtypes = FALSE


/datum/export/gear/riot_helmet
	cost = 250
	unit_name = "riot helmet"
	cost_modifiers = list("Security")
	export_types = list(/obj/item/clothing/head/helmet/riot)

/datum/export/gear/riot_armor
	cost = 250
	unit_name = "riot armor suit"
	cost_modifiers = list("Security")
	export_types = list(/obj/item/clothing/suit/armor/riot)

/datum/export/gear/bulletproof_armor
	cost = 250
	unit_name = "bulletproof armor vest"
	cost_modifiers = list("Security")
	export_types = list(/obj/item/clothing/suit/armor/bulletproof)

/datum/export/gear/reflector_armor
	cost = 650
	unit_name = "reflector armor vest"
	cost_modifiers = list("Science")
	export_types = list(/obj/item/clothing/suit/armor/laserproof)


/datum/export/gear/riot_shield
	cost = 400
	unit_name = "riot shield"
	cost_modifiers = list("Security")
	export_types = list(/obj/item/weapon/shield/riot)


// Masks
/datum/export/gear/mask/breath
	cost = 2
	unit_name = "breath mask"
	cost_modifiers = list("Emergency")
	export_types = list(/obj/item/clothing/mask/breath)

/datum/export/gear/mask/gas
	cost = 10
	unit_name = "gas mask"
	cost_modifiers = list("Emergency")
	export_types = list(/obj/item/clothing/mask/gas)
	include_subtypes = FALSE



// EVA gear
/datum/export/gear/space
	include_subtypes = FALSE
	cost_modifiers = list("Emergency")

/datum/export/gear/space/helmet
	cost = 500
	unit_name = "space helmet"
	export_types = list(/obj/item/clothing/head/helmet/space, /obj/item/clothing/head/helmet/space/eva)

/datum/export/gear/space/suit
	cost = 600
	unit_name = "space suit"
	export_types = list(/obj/item/clothing/suit/space, /obj/item/clothing/suit/space/eva)


/datum/export/gear/space/voidhelmet
	cost = 550
	unit_name = "void helmet"
	export_types = list(/obj/item/clothing/head/helmet/space/nasavoid)

/datum/export/gear/space/voidsuit
	cost = 650
	unit_name = "void suit"
	export_types = list(/obj/item/clothing/suit/space/nasavoid)


/datum/export/gear/space/syndiehelmet
	cost = 1000
	unit_name = "Syndicate space helmet"
	export_types = list(/obj/item/clothing/head/helmet/space/syndicate)
	include_subtypes = TRUE

/datum/export/gear/space/syndiesuit
	cost = 1500
	unit_name = "Syndicate space suit"
	export_types = list(/obj/item/clothing/suit/space/syndicate)
	include_subtypes = TRUE


// Radsuits
/datum/export/gear/radhelmet
	cost = 50
	unit_name = "radsuit hood"
	cost_modifiers = list("Emergency", "Supermatter")
	export_types = list(/obj/item/clothing/head/radiation)

/datum/export/gear/radsuit
	cost = 100
	unit_name = "radsuit"
	cost_modifiers = list("Emergency", "Supermatter")
	export_types = list(/obj/item/clothing/suit/radiation)

// Biosuits
/datum/export/gear/biohood
	cost = 50
	unit_name = "biosuit hood"
	cost_modifiers = list("Emergency", "Medical")
	export_types = list(/obj/item/clothing/head/bio_hood)

/datum/export/gear/biosuit
	cost = 100
	unit_name = "biosuit"
	cost_modifiers = list("Emergency", "Medical")
	export_types = list(/obj/item/clothing/suit/bio_suit)

// Bombsuits
/datum/export/gear/bombhelmet
	cost = 100
	unit_name = "bomb suit hood"
	cost_modifiers = list("Emergency", "Ammo")		//Ammo includes mac rounds ok
	export_types = list(/obj/item/clothing/head/bomb_hood)

/datum/export/gear/bombsuit
	cost = 300
	unit_name = "bomb suit"
	cost_modifiers = list("Emergency", "Ammo")
	export_types = list(/obj/item/clothing/suit/bomb_suit)
