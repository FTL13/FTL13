/obj/effect/spawner/lootdrop
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "x2"
	color = "#00FF00"
	var/lootcount = 1		//how many items will be spawned
	var/lootdoubles = 1		//if the same item can be spawned twice
	var/list/loot			//a list of possible items to spawn e.g. list(/obj/item, /obj/structure, /obj/effect)

/obj/effect/spawner/lootdrop/New()
	if(loot && loot.len)
		for(var/i = lootcount, i > 0, i--)
			if(!loot.len) break
			var/lootspawn = pickweight(loot)
			if(!lootdoubles)
				loot.Remove(lootspawn)

			if(lootspawn)
				new lootspawn(get_turf(src))
	qdel(src)

/obj/effect/spawner/lootdrop/armory_contraband
	name = "armory contraband gun spawner"
	lootdoubles = 0

	loot = list(
				/obj/item/weapon/gun/projectile/automatic/pistol = 8,
				/obj/item/weapon/gun/projectile/shotgun/automatic/combat = 5,
				/obj/item/weapon/gun/projectile/revolver/mateba,
				/obj/item/weapon/gun/projectile/automatic/pistol/deagle
				)

/obj/effect/spawner/lootdrop/gambling
	name = "gambling valuables spawner"
	loot = list(
				/obj/item/weapon/gun/projectile/revolver/russian = 5,
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

	//How to balance this table
	//-------------------------
	//The total added weight of all the entries should be (roughly) equal to the total number of lootdrops
	//(take in account those that spawn more than one object!)
	//
	//While this is random, probabilities tells us that item distribution will have a tendency to look like
	//the content of the weighted table that created them.
	//The less lootdrops, the less even the distribution.
	//
	//If you want to give items a weight <1 you can multiply all the weights by 10
	//
	//the "" entry will spawn nothing, if you increase this value,
	//ensure that you balance it with more spawn points

	//table data:
	//-----------
	//aft maintenance: 		24 items, 18 spots 2 extra (28/08/2014)
	//asmaint: 				16 items, 11 spots 0 extra (08/08/2014)
	//asmaint2:			 	36 items, 26 spots 2 extra (28/08/2014)
	//fpmaint:				5  items,  4 spots 0 extra (08/08/2014)
	//fpmaint2:				12 items, 11 spots 2 extra (28/08/2014)
	//fsmaint:				0  items,  0 spots 0 extra (08/08/2014)
	//fsmaint2:				40 items, 27 spots 5 extra (28/08/2014)
	//maintcentral:			2  items,  2 spots 0 extra (08/08/2014)
	//port:					5  items,  5 spots 0 extra (08/08/2014)
	loot = list(
				/obj/item/bodybag = 1,
				/obj/item/clothing/glasses/meson = 2,
				/obj/item/clothing/glasses/sunglasses = 1,
				/obj/item/clothing/gloves/color/fyellow = 1,
				/obj/item/clothing/head/hardhat = 1,
				/obj/item/clothing/head/hardhat/red = 1,
				/obj/item/clothing/head/that{throwforce = 1; throwing = 1} = 1,
				/obj/item/clothing/head/ushanka = 1,
				/obj/item/clothing/head/welding = 1,
				/obj/item/clothing/mask/gas = 15,
				/obj/item/clothing/suit/hazardvest = 1,
				/obj/item/clothing/under/rank/vice = 1,
				/obj/item/device/assembly/prox_sensor = 4,
				/obj/item/device/assembly/timer = 3,
				/obj/item/device/flashlight = 4,
				/obj/item/device/flashlight/pen = 1,
				/obj/item/device/multitool = 2,
				/obj/item/device/radio/off = 2,
				/obj/item/device/t_scanner = 5,
				/obj/item/weapon/airlock_painter = 1,
				/obj/item/stack/cable_coil = 4,
				/obj/item/stack/cable_coil{amount = 5} = 6,
				/obj/item/stack/medical/bruise_pack = 1,
				/obj/item/stack/rods{amount = 10} = 9,
				/obj/item/stack/rods{amount = 23} = 1,
				/obj/item/stack/rods{amount = 50} = 1,
				/obj/item/stack/sheet/cardboard = 2,
				/obj/item/stack/sheet/metal{amount = 20} = 1,
				/obj/item/stack/sheet/mineral/plasma = 1,
				/obj/item/stack/sheet/rglass = 1,
				/obj/item/weapon/book/manual/wiki/engineering_construction = 1,
				/obj/item/weapon/book/manual/wiki/engineering_hacking = 1,
				/obj/item/clothing/head/cone = 1,
				/obj/item/weapon/coin/silver = 1,
				/obj/item/weapon/coin/twoheaded = 1,
				/obj/item/weapon/poster/contraband = 1,
				/obj/item/weapon/poster/legit = 1,
				/obj/item/weapon/crowbar = 1,
				/obj/item/weapon/crowbar/red = 1,
				/obj/item/weapon/extinguisher = 11,
				//obj/item/weapon/gun/projectile/revolver/russian = 1, //disabled until lootdrop is a proper world proc.
				/obj/item/weapon/hand_labeler = 1,
				/obj/item/weapon/paper/crumpled = 1,
				/obj/item/weapon/pen = 1,
				/obj/item/weapon/reagent_containers/spray/pestspray = 1,
				/obj/item/weapon/reagent_containers/glass/rag = 3,
				/obj/item/weapon/stock_parts/cell = 3,
				/obj/item/weapon/storage/belt/utility = 2,
				/obj/item/weapon/storage/box = 2,
				/obj/item/weapon/storage/box/cups = 1,
				/obj/item/weapon/storage/box/donkpockets = 1,
				/obj/item/weapon/storage/box/lights/mixed = 3,
				/obj/item/weapon/storage/box/hug/medical = 1,
				/obj/item/weapon/storage/fancy/cigarettes/dromedaryco = 1,
				/obj/item/weapon/storage/toolbox/mechanical = 1,
				/obj/item/weapon/screwdriver = 3,
				/obj/item/weapon/tank/internals/emergency_oxygen = 2,
				/obj/item/weapon/vending_refill/cola = 1,
				/obj/item/weapon/weldingtool = 3,
				/obj/item/weapon/wirecutters = 1,
				/obj/item/weapon/wrench = 4,
				/obj/item/weapon/relic = 3,
				/obj/item/weaponcrafting/reciever = 1,
				/obj/item/clothing/head/cone = 2,
				/obj/item/weapon/grenade/smokebomb = 2,
				/obj/item/device/geiger_counter = 3,
				/obj/item/weapon/reagent_containers/food/snacks/grown/citrus/orange = 1,
				/obj/item/device/radio/headset = 1,
				/obj/item/device/assembly/infra = 1,
				/obj/item/device/assembly/igniter = 2,
				/obj/item/device/assembly/signaler = 2,
				/obj/item/device/assembly/mousetrap = 2,
				/obj/item/weapon/reagent_containers/syringe = 2,
				/obj/item/clothing/gloves/color/random = 8,
				/obj/item/clothing/shoes/laceup = 1,
				/obj/item/weapon/storage/secure/briefcase = 3,
				"" = 4
				)

/obj/effect/spawner/lootdrop/salvage_spawner
	name = "salvage spawner"
	lootdoubles = 1
	loot = list(
		/obj/structure/closet/ammunitionlocker,
  	/obj/item/weapon/pickaxe/drill,
		/obj/structure/janitorialcart,
		/obj/structure/reagent_dispensers/beerkeg,
		/obj/structure/reagent_dispensers/watertank,
		/obj/machinery/suit_storage_unit/mining,
		/obj/machinery/suit_storage_unit/mining/eva,
		/obj/machinery/monkey_recycler,
		/obj/machinery/hydroponics,
		/obj/item/weapon/circuitboard/machine/smes,
		/obj/item/weapon/circuitboard/machine/mac_breech,
		/obj/item/weapon/circuitboard/machine/mac_barrel,
		/obj/structure/shell = 3,
		/obj/structure/shell/shield_piercing = 3,
		/obj/structure/shell/smart_homing = 3,
		/obj/machinery/food_cart,
		/obj/machinery/portable_atmospherics/canister/air,
		/obj/machinery/portable_atmospherics/canister/oxygen,
		/obj/machinery/portable_atmospherics/canister/nitrogen,
		/obj/machinery/portable_atmospherics/canister/toxins,
		/obj/item/slime_extract/metal = 3,
		/obj/item/slime_extract/grey = 5,
		/obj/item/weapon/pickaxe/diamond,
		/obj/structure/statue/sandstone/assistant,
		/obj/item/stack/sheet/glass{amount = 25},
		/obj/item/stack/sheet/metal{amount = 25},
		/obj/item/stack/sheet/plasteel/twenty,
		/obj/item/stack/sheet/mineral/uranium{amount = 15},
		/obj/item/stack/sheet/mineral/plasma{amount = 15},
		/obj/item/stack/sheet/mineral/gold{amount = 15},
		/obj/item/stack/spacecash = 10,
		/obj/item/stack/spacecash/c10 = 5,
		/obj/item/stack/spacecash/c20 = 5,
		/obj/item/stack/spacecash/c50 = 4,
		/obj/item/stack/spacecash/c10 = 3,
		/mob/living/simple_animal/bot/secbot,
		/mob/living/simple_animal/bot/cleanbot,
		/mob/living/simple_animal/bot/medbot,
		/obj/item/seeds/tomato/blue,
		/obj/item/weapon/storage/box/firingpins,
		/obj/item/weapon/suppressor,
		)


/obj/effect/spawner/lootdrop/raresalvage_spawner
		name = "rare salvage spawner"
		lootdoubles = 1
		loot = list(
			/obj/item/weapon/pickaxe/drill/diamonddrill,
			/obj/item/weapon/pickaxe/drill/jackhammer,
			/obj/structure/AIcore,
			/obj/machinery/vending/boozeomat,
			/obj/machinery/suit_storage_unit/captain,
			/obj/machinery/suit_storage_unit/hos,
			/obj/machinery/suit_storage_unit/security,
			/obj/machinery/suit_storage_unit/syndicate,
			/obj/machinery/suit_storage_unit/ert/command,
			/obj/machinery/syndicatebomb,
			/obj/machinery/power/supermatter_shard,
			/obj/item/weapon/circuitboard/machine/phase_cannon,
			/obj/machinery/shieldwallgen = 2,
			/obj/item/documents/syndicate,
			/obj/mecha/working/ripley/mining,
			/obj/mecha/working/ripley,
			/obj/structure/displaycase/shiplabcage,
			/obj/mecha/combat/gygax,
	  	/obj/structure/closet/crate/secure/loot,
			/obj/item/weapon/storage/bag/money,
			/obj/item/slime_extract/adamantine,
			/obj/item/slime_extract/bluespace,
			/obj/item/slime_extract/gold,
			/obj/item/slime_extract/cerulean = 2,
			/obj/item/slimepotion/transference,
			/obj/item/slimepotion/sentience,
			/obj/item/weapon/abductor_baton,
			/obj/item/weapon/grenade/plastic/c4  = 3,
			/obj/item/weapon/grenade/plastic/x4,
			/obj/item/weapon/grenade/syndieminibomb,
			/obj/item/weapon/grenade/clusterbuster,
			/obj/item/weapon/gun/medbeam,
			/obj/item/weapon/gun/energy/floragun,
			/obj/item/weapon/gun/energy/pulse,
			/obj/item/weapon/gun/magic/staff/honk,
			/obj/item/weapon/gun/projectile/shotgun/automatic/combat,
			/obj/item/weapon/gun/projectile/revolver/golden,
			/obj/item/weapon/gun/projectile/revolver,
			/obj/structure/statue/bananium/clown,
			/obj/structure/statue/gold/hop,
			/obj/structure/statue/silver/janitor,
			/obj/vehicle/janicart,
			/obj/item/stack/sheet/plasteel/fifty,
			/obj/item/stack/sheet/mineral/adamantine{amount = 10},
			/obj/item/stack/sheet/mineral/uranium{amount = 30},
			/obj/item/stack/sheet/mineral/mythril{amount = 10},
			/obj/item/stack/sheet/mineral/gold{amount = 30},
			/obj/item/stack/sheet/mineral/silver{amount = 30},
			/obj/item/stack/sheet/mineral/diamond{amount = 20},
			/obj/machinery/ammo_rack/full,
			/obj/machinery/ammo_rack/full/shield_piercing,
			/obj/machinery/ammo_rack/full/smart_homing,
			/obj/item/stack/spacecash/c100 = 3,
			/obj/item/stack/spacecash/c200 = 4,
			/obj/item/stack/spacecash/c500 = 3,
			/obj/item/stack/spacecash/c1000 = 2,
			/obj/item/weapon/gun/energy/kinetic_accelerator/hyper,
			/obj/item/weapon/gun/energy/kinetic_accelerator/super,
			/mob/living/simple_animal/bot/ed209,
			/obj/item/seeds/banana/bluespace,
			/obj/item/seeds/tomato/blue/bluespace,
			/obj/item/weapon/gun/energy/alien,
			/obj/item/weapon/gun/energy = 2,
			/obj/item/weapon/gun/energy/gun/turret,
			/obj/item/weapon/gun/energy/gun/dragnet/snare,
			/obj/item/weapon/katana,
			/obj/item/weapon/gun/projectile/automatic/wt550,
			/obj/item/weapon/gun/projectile/automatic/xmg80,
			/obj/item/weapon/gun/projectile/automatic/shotgun/bulldog,
			/obj/item/weapon/storage/backpack/dufflebag/syndie/bulldogbundle,
			/obj/item/weapon/storage/backpack/dufflebag/syndie/c20rbundle,
			/obj/item/weapon/storage/backpack/dufflebag/syndie/ammo,
			/obj/item/weapon/storage/backpack/dufflebag/syndie/surgery,
			)


/obj/effect/spawner/lootdrop/crate_spawner
				name = "lootcrate spawner"
				lootdoubles = 0

				loot = list(
							/obj/structure/closet/crate/secure/loot = 20,
							"" = 80
							)
