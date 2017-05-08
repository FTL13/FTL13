/obj/effect/spawner/lootdrop
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "x2"
	color = "#00FF00"
	var/lootcount = 1		//how many items will be spawned
	var/lootdoubles = TRUE	//if the same item can be spawned twice
	var/list/loot			//a list of possible items to spawn e.g. list(/obj/item, /obj/structure, /obj/effect)

/obj/effect/spawner/lootdrop/Initialize(mapload)
	..()
	if(loot && loot.len)
		var/turf/T = get_turf(src)
		while(lootcount && loot.len)
			var/lootspawn = pickweight(loot)
			if(!lootdoubles)
				loot.Remove(lootspawn)

			if(lootspawn)
				new lootspawn(T)
			lootcount--
	qdel(src)

/obj/effect/spawner/lootdrop/armory_contraband
	name = "armory contraband gun spawner"
	lootdoubles = FALSE

	loot = list(
				/obj/item/weapon/gun/ballistic/automatic/pistol = 8,
				/obj/item/weapon/gun/ballistic/shotgun/automatic/combat = 5,
				/obj/item/weapon/gun/ballistic/revolver/mateba,
				/obj/item/weapon/gun/ballistic/automatic/pistol/deagle
				)

/obj/effect/spawner/lootdrop/gambling
	name = "gambling valuables spawner"
	loot = list(
				/obj/item/weapon/gun/ballistic/revolver/russian = 5,
				/obj/item/weapon/storage/box/syndie_kit/throwing_weapons = 1,
				/obj/item/toy/cards/deck/syndicate = 2
				)

/obj/effect/spawner/lootdrop/grille_or_trash
	name = "maint grille or trash spawner"
	loot = list(/obj/structure/grille = 5,
			/obj/item/weapon/cigbutt = 1,
			/obj/item/trash/cheesie = 1,
			/obj/item/trash/candy = 1,
			/obj/item/trash/chips = 1,
			/obj/item/trash/deadmouse = 1,
			/obj/item/trash/pistachios = 1,
			/obj/item/trash/plate = 1,
			/obj/item/trash/popcorn = 1,
			/obj/item/trash/raisins = 1,
			/obj/item/trash/sosjerky = 1,
			/obj/item/trash/syndi_cakes = 1)

/obj/effect/spawner/lootdrop/maintenance
	name = "maintenance loot spawner"
	// see code/_globalvars/lists/maintenance_loot.dm for loot table

/obj/effect/spawner/lootdrop/maintenance/Initialize(mapload)
	loot = GLOB.maintenance_loot
	..()

/obj/effect/spawner/lootdrop/salvage_spawner
	name = "salvage spawner"
	lootdoubles = 1
	// The chance that the loot is nothing which is the "" should be 25% of the total chance, to prevent OP shit. Same goes for rare loot
	loot = list(
		/obj/structure/closet/ammunitionlocker = 3,
  	/obj/item/weapon/pickaxe/drill = 2,
		/obj/structure/janitorialcart = 3,
		/obj/structure/reagent_dispensers/beerkeg = 3,
		/obj/structure/reagent_dispensers/watertank = 3,
		/obj/machinery/suit_storage_unit/mining = 1,
		/obj/machinery/suit_storage_unit/mining/eva = 2,
		/obj/machinery/monkey_recycler = 2,
		/obj/machinery/hydroponics = 2,
		/obj/item/weapon/circuitboard/machine/smes = 2,
		/obj/item/weapon/circuitboard/machine/mac_breech = 1,
		/obj/item/weapon/circuitboard/machine/mac_barrel = 1,
		/obj/structure/shell = 1,
		/obj/structure/shell/shield_piercing = 1,
		/obj/structure/shell/smart_homing = 1,
		/obj/machinery/food_cart = 2,
		/obj/machinery/portable_atmospherics/canister/air = 3,
		/obj/machinery/portable_atmospherics/canister/oxygen = 3,
		/obj/machinery/portable_atmospherics/canister/nitrogen = 3,
		/obj/machinery/portable_atmospherics/canister/toxins = 2,
		/obj/item/slime_extract/metal = 2,
		/obj/item/slime_extract/grey = 2,
		/obj/item/weapon/pickaxe/diamond = 1,
		/obj/structure/statue/sandstone/assistant = 2,
		/obj/item/stack/sheet/glass{amount = 15} = 2,
		/obj/item/stack/sheet/metal{amount = 15} = 2,
		/obj/item/stack/sheet/plasteel/twenty = 1,
		/obj/item/stack/sheet/mineral/uranium{amount = 5} = 1,
		/obj/item/stack/sheet/mineral/plasma{amount = 5} = 1,
		/obj/item/stack/sheet/mineral/gold{amount = 5} = 1,
		/obj/item/stack/spacecash/c10 {amount = 5} = 3,
		/obj/item/stack/spacecash/c20 {amount = 5} = 2,
		/obj/item/stack/spacecash/c50 {amount = 5} = 2,
		/obj/item/stack/spacecash/c100{amount = 5} = 1,
		/mob/living/simple_animal/bot/secbot = 2,
		/mob/living/simple_animal/bot/cleanbot = 2,
		/mob/living/simple_animal/bot/medbot = 2,
		/obj/item/seeds/tomato/blue = 1,
		/obj/item/weapon/storage/box/firingpins = 1,
		/obj/item/weapon/suppressor = 2,
		/obj/item/weapon/grenade/plastic/c4  = 1,
		"" = 25, //estimate
		)


/obj/effect/spawner/lootdrop/raresalvage_spawner
		name = "rare salvage spawner"
		lootdoubles = 1
		loot = list(
			/obj/item/weapon/pickaxe/drill/diamonddrill = 3,
			/obj/item/weapon/pickaxe/drill/jackhammer = 2,
			/obj/structure/AIcore = 2,
			/obj/machinery/vending/boozeomat = 3,
			/obj/machinery/suit_storage_unit/captain = 1,
			/obj/machinery/suit_storage_unit/hos = 2,
			/obj/machinery/suit_storage_unit/security = 2,
			/obj/machinery/suit_storage_unit/syndicate = 1,
			/obj/machinery/suit_storage_unit/ert/command = 1,
			/obj/machinery/syndicatebomb = 1,
			/obj/machinery/power/supermatter_shard = 2,
			/obj/item/weapon/circuitboard/machine/phase_cannon = 1,
			/obj/machinery/shieldwallgen = 3,
			/obj/item/documents/syndicate = 1,
			/obj/mecha/working/ripley/mining = 1,
			/obj/mecha/working/ripley = 1,
			/obj/structure/displaycase/shiplabcage = 2,
			/obj/mecha/combat/gygax = 1,
			/obj/structure/closet/crate/secure/loot = 2,
			/obj/item/weapon/storage/bag/money = 1,
			/obj/item/slime_extract/adamantine = 1,
			/obj/item/slime_extract/bluespace = 1,
			/obj/item/slime_extract/gold = 2,
			/obj/item/slime_extract/cerulean = 2,
			/obj/item/slimepotion/transference = 1,
			/obj/item/slimepotion/sentience = 1,
			/obj/item/weapon/abductor_baton = 2,
			/obj/item/weapon/grenade/plastic/x4 = 3,
			/obj/item/weapon/grenade/syndieminibomb = 2,
			/obj/item/weapon/grenade/clusterbuster = 1,
			/obj/item/weapon/gun/medbeam = 1,
			/obj/item/weapon/gun/energy/floragun = 2,
			/obj/item/weapon/gun/magic/staff/honk = 1,
			/obj/item/weapon/gun/projectile/shotgun/automatic/combat = 1,
			/obj/item/weapon/gun/projectile/revolver/golden = 1,
			/obj/item/weapon/gun/projectile/revolver = 3,
			/obj/structure/statue/bananium/clown = 1,
			/obj/structure/statue/gold/xo = 2,
			/obj/structure/statue/silver/janitor = 3,
			/obj/item/stack/sheet/plasteel/fifty = 1,
			/obj/item/stack/sheet/mineral/adamantine{amount = 10} = 2,
			/obj/item/stack/sheet/mineral/uranium{amount = 15} = 2,
			/obj/item/stack/sheet/mineral/mythril{amount = 10} = 2,
			/obj/item/stack/sheet/mineral/gold{amount = 15} = 2,
			/obj/item/stack/sheet/mineral/silver{amount = 15} = 2,
			/obj/item/stack/sheet/mineral/diamond{amount = 10} = 2,
			/obj/machinery/ammo_rack/full = 2,
			/obj/machinery/ammo_rack/full/shield_piercing = 2,
			/obj/machinery/ammo_rack/full/smart_homing = 2,
			/obj/item/stack/spacecash/c100{amount = 5} = 5,
			/obj/item/stack/spacecash/c200{amount = 5} = 2,
			/obj/item/stack/spacecash/c500{amount = 3} = 2,
			/obj/item/stack/spacecash/c1000{amount = 2} = 1,
			/obj/item/weapon/gun/energy/kinetic_accelerator/hyper = 1,
			/obj/item/weapon/gun/energy/kinetic_accelerator/super = 2,
			/mob/living/simple_animal/bot/ed209 = 2,
			/obj/item/seeds/banana/bluespace = 2,
			/obj/item/seeds/tomato/blue/bluespace = 2,
			/obj/item/weapon/gun/energy/alien = 2,
			/obj/item/weapon/gun/energy = 2,
			/obj/item/weapon/gun/energy/gun/turret = 1,
			/obj/item/weapon/gun/energy/gun/dragnet/snare = 1,
			/obj/item/weapon/katana = 3,
			/obj/item/weapon/gun/projectile/automatic/wt550 = 3,
			/obj/item/weapon/gun/projectile/automatic/xmg80 = 3,
			/obj/item/weapon/gun/projectile/automatic/shotgun/bulldog = 1,
			/obj/item/weapon/storage/backpack/dufflebag/syndie/bulldogbundle = 1,
			/obj/item/weapon/storage/backpack/dufflebag/syndie/c20rbundle = 1,
			/obj/item/weapon/storage/backpack/dufflebag/syndie/ammo = 2,
			/obj/item/weapon/storage/backpack/dufflebag/syndie/surgery = 2,
			"" = 20, //estimate
			)


/obj/effect/spawner/lootdrop/crate_spawner
<<<<<<< HEAD
	name = "lootcrate spawner" //USE PROMO CODE "SELLOUT" FOR 20% OFF!
	lootdoubles = FALSE

	loot = list(
				/obj/structure/closet/crate/secure/loot = 20,
				"" = 80
				)

/obj/effect/spawner/lootdrop/organ_spawner
	name = "organ spawner"
	loot = list(
		/obj/item/organ/heart/gland/bloody = 7,
		/obj/item/organ/heart/gland/bodysnatch = 4,
		/obj/item/organ/heart/gland/egg = 7,
		/obj/item/organ/heart/gland/emp = 3,
		/obj/item/organ/heart/gland/mindshock = 5,
		/obj/item/organ/heart/gland/plasma = 7,
		/obj/item/organ/heart/gland/pop = 5,
		/obj/item/organ/heart/gland/slime = 4,
		/obj/item/organ/heart/gland/spiderman = 5,
		/obj/item/organ/heart/gland/ventcrawling = 1,
		/obj/item/organ/body_egg/alien_embryo = 1,
		/obj/item/organ/hivelord_core = 2)
	lootcount = 3

/obj/effect/spawner/lootdrop/two_percent_xeno_egg_spawner
	name = "2% chance xeno egg spawner"
	loot = list(
		/obj/effect/decal/remains/xeno = 49,
		/obj/effect/spawner/xeno_egg_delivery = 1)

/obj/effect/spawner/lootdrop/costume
	name = "random costume spawner"

/obj/effect/spawner/lootdrop/costume/Initialize()
	loot = list()
	for(var/path in subtypesof(/obj/effect/spawner/bundle/costume))
		loot[path] = TRUE
	..()

// Minor lootdrops follow

/obj/effect/spawner/lootdrop/minor/beret_or_rabbitears
	name = "beret or rabbit ears spawner"
	loot = list(
		/obj/item/clothing/head/beret = 1,
		/obj/item/clothing/head/rabbitears = 1)

/obj/effect/spawner/lootdrop/minor/bowler_or_that
	name = "bowler or top hat spawner"
	loot = list(
		/obj/item/clothing/head/bowler = 1,
		/obj/item/clothing/head/that = 1)

/obj/effect/spawner/lootdrop/minor/kittyears_or_rabbitears
	name = "kitty ears or rabbit ears spawner"
	loot = list(
		/obj/item/clothing/head/kitty = 1,
		/obj/item/clothing/head/rabbitears = 1)

/obj/effect/spawner/lootdrop/minor/pirate_or_bandana
	name = "pirate hat or bandana spawner"
	loot = list(
		/obj/item/clothing/head/pirate = 1,
		/obj/item/clothing/head/bandana = 1)

/obj/effect/spawner/lootdrop/minor/twentyfive_percent_cyborg_mask
	name = "25% cyborg mask spawner"
	loot = list(
		/obj/item/clothing/mask/gas/cyborg = 25,
		"" = 75)
=======
				name = "lootcrate spawner"
				lootdoubles = 0

				loot = list(
							/obj/structure/closet/crate/secure/loot = 20,
							"" = 80
							)
>>>>>>> master
