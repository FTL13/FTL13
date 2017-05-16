/obj/effect/spawner/lootdrop
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "x2"
	color = "#00FF00"
	var/lootcount = 1		//how many items will be spawned
	var/lootdoubles = 1		//if the same item can be spawned twice
	var/nolootchance = 0 // mapper can edit this variable on each of the landmarks so they can decide how rare the loot is.
	var/list/loot			//a list of possible items to spawn e.g. list(/obj/item, /obj/structure, /obj/effect)


/obj/effect/spawner/lootdrop/New()
	if(loot && loot.len)
		for(var/i = lootcount, i > 0, i--)
			if(!loot.len) break
			var/lootspawn = pickweight(loot)
			if(!lootdoubles)
				loot.Remove(lootspawn)
		if(nolootchance)
			loot += list("" = nolootchance)

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
				name = "lootcrate spawner"
				lootdoubles = 0

				loot = list(
							/obj/structure/closet/crate/secure/loot = 20,
							"" = 80
							)

/obj/effect/spawner/lootdrop/commodities_loot_spawner // Only spawns refined minerals, metal, glass and trade goods
		name = "commodities salvage spawner"
		lootdoubles = 1
		nolootchance = 5
		loot = list(
			/obj/item/stack/sheet/mineral/adamantine{amount = 1} = 1,
			/obj/item/stack/sheet/mineral/uranium{amount = 5} = 5,
			/obj/item/stack/sheet/mineral/mythril{amount = 1} = 1,
			/obj/item/stack/sheet/mineral/gold{amount = 5} = 5,
			/obj/item/stack/sheet/mineral/silver{amount = 5} = 5,
			/obj/item/stack/sheet/mineral/diamond{amount = 1} = 3,
			/obj/item/stack/sheet/mineral/plasma{amount = 10} = 4,
			/obj/item/stack/sheet/metal{amount = 25} = 7,
			/obj/item/stack/sheet/plasteel{amount = 10} = 5,
			/obj/item/stack/sheet/glass{amount = 35} = 7,
			/obj/item/stack/sheet/rglass{amount = 10} = 5,
			/obj/item/stack/sheet/mineral/wood{amount = 50} = 7,
			/obj/item/stack/sheet/cardboard/fifty = 7,

			)

/obj/effect/spawner/lootdrop/wealth_loot_spawner //  Only spawns space cash, coins and other forms of currency
		name = "wealth salvage spawner"
		lootdoubles = 1
		nolootchance = 5
		loot = list(
			/obj/item/stack/spacecash/c50 = 10,
			/obj/item/stack/spacecash/c100 = 7,
			/obj/item/stack/spacecash/c200 = 5,
			/obj/item/stack/spacecash/c500 = 4,
			/obj/item/stack/spacecash/c1000 = 2,
			/obj/item/weapon/coin/iron = 7,
			/obj/item/weapon/coin/silver = 7,
			/obj/item/weapon/coin/uranium = 7,
			/obj/item/weapon/coin/gold = 5,
			/obj/item/weapon/coin/plasma = 3,
			/obj/item/weapon/coin/diamond = 3,
			/obj/item/weapon/coin/mythril = 2,
			/obj/item/weapon/coin/adamantine = 2,
			/obj/item/weapon/coin/clown = 1,

			)


/obj/effect/spawner/lootdrop/illegaltech_loot_spawner // Contains contraband technology manafactured by the Syndicate, not always necessarily dangerous, but sometimes extremely valuable for R&D
		name = "illegal tech salvage spawner"
		lootdoubles = 0
		nolootchance = 20
		loot = list(
			/obj/item/weapon/grenade/spawnergrenade/manhacks = 2,
			/obj/item/weapon/pen/edagger = 6,
			/obj/item/weapon/soap/syndie = 7,
			/obj/item/toy/carpplushie/dehy_carp = 7,
			/obj/item/device/flashlight/emp = 5,
			/obj/item/weapon/storage/box/syndie_kit/cutouts = 7,
			/obj/item/weapon/storage/box/syndie_kit/space = 6,
			/obj/item/clothing/suit/space/hardsuit/syndi = 2,
			/obj/item/clothing/suit/space/hardsuit/syndi/elite = 1,
			/obj/item/weapon/storage/belt/military = 6,
			/obj/item/device/encryptionkey/binary = 5,
			/obj/item/device/multitool/ai_detect = 6,
			/obj/item/clothing/shoes/magboots/syndie = 7,
			/obj/item/weapon/storage/box/syndie_kit/imp_microbomb = 1,
			/obj/item/weapon/storage/box/syndie_kit/chameleon = 1,

			)

/obj/effect/spawner/lootdrop/toys_loot_spawner // spawns any toy from the entire list of available toys
		name = "toys salvage spawner"
		lootdoubles = 1
		loot = list(
			/obj/item/toy/katana = 1,
			/obj/item/toy/sword = 1,
			/obj/item/toy/syndicateballoon = 1,
			/obj/item/weapon/storage/crayons = 1,
			/obj/item/toy/cards/deck = 1,
			/obj/item/toy/cattoy = 1,
			/obj/item/toy/gun = 1,
			/obj/item/toy/foamblade = 1,
			/obj/item/toy/minimeteor = 1,
			/obj/item/toy/redbutton = 1,
			/obj/item/toy/spinningtoy = 1,
			/obj/item/toy/figure/assistant = 1,
			/obj/item/toy/figure/atmos = 1,
			/obj/item/toy/figure/bartender = 1,
			/obj/item/toy/figure/borg = 1,
			/obj/item/toy/figure/botanist = 1,
			/obj/item/toy/figure/captain = 1,
			/obj/item/toy/figure/cargotech = 1,
			/obj/item/toy/figure/ce = 1,
			/obj/item/toy/figure/chaplain = 1,
			/obj/item/toy/figure/chef = 1,
			/obj/item/toy/figure/chemist = 1,
			/obj/item/toy/figure/clown = 1,
			/obj/item/toy/figure/cmo = 1,
			/obj/item/toy/figure/detective = 1,
			/obj/item/toy/figure/dsquad = 1,
			/obj/item/toy/figure/engineer = 1,
			/obj/item/toy/figure/geneticist = 1,
			/obj/item/toy/figure/hos = 1,
			/obj/item/toy/figure/ian = 1,
			/obj/item/toy/figure/janitor = 1,
			/obj/item/toy/figure/lawyer = 1,
			/obj/item/toy/figure/librarian = 1,
			/obj/item/toy/figure/md = 1,
			/obj/item/toy/figure/mime = 1,
			/obj/item/toy/figure/miner = 1,
			/obj/item/toy/figure/ninja = 1,
			/obj/item/toy/figure/qm = 1,
			/obj/item/toy/figure/rd = 1,
			/obj/item/toy/figure/roboticist = 1,
			/obj/item/toy/figure/scientist = 1,
			/obj/item/toy/figure/secofficer = 1,
			/obj/item/toy/figure/syndie = 1,
			/obj/item/toy/figure/virologist = 1,
			/obj/item/toy/figure/wizard = 1,
			/obj/item/toy/prize/deathripley = 1,
			/obj/item/toy/prize/durand = 1,
			/obj/item/toy/prize/fireripley = 1,
			/obj/item/toy/prize/gygax = 1,
			/obj/item/toy/prize/honk = 1,
			/obj/item/toy/prize/marauder = 1,
			/obj/item/toy/prize/mauler = 1,
			/obj/item/toy/prize/odysseus = 1,
			/obj/item/toy/prize/phazon = 1,
			/obj/item/toy/prize/reticence = 1,
			/obj/item/toy/prize/ripley = 1,
			/obj/item/toy/prize/seraph = 1,

			)

/obj/effect/spawner/lootdrop/food_loot_spawner // food! Mostly if you want to have a random genned canteen etc.
		name = "food salvage spawner"
		lootdoubles = 1
		loot = list(
			/obj/item/weapon/reagent_containers/food/snacks/burger/plain = 1,
			/obj/item/weapon/reagent_containers/food/snacks/burger/bigbite = 1,
			/obj/item/weapon/reagent_containers/food/snacks/burger/tofu = 1,
			/obj/item/weapon/reagent_containers/food/snacks/burrito = 1,
			/obj/item/weapon/reagent_containers/food/snacks/carrotfries = 1,
			/obj/item/weapon/reagent_containers/food/snacks/honkdae = 1,
			/obj/item/weapon/reagent_containers/food/snacks/cubancarp = 1,
			/obj/item/weapon/reagent_containers/food/snacks/cubannachos = 1,
			/obj/item/weapon/reagent_containers/food/snacks/donkpocket = 1,
			/obj/item/weapon/reagent_containers/food/snacks/fishandchips = 1,
			/obj/item/weapon/reagent_containers/food/snacks/friedegg = 1,
			/obj/item/weapon/reagent_containers/food/snacks/waffles = 1,
			/obj/item/weapon/reagent_containers/food/snacks/salad/jungle = 1,
			/obj/item/weapon/reagent_containers/food/snacks/omelette = 1,
			/obj/item/weapon/reagent_containers/food/snacks/kebab/monkey = 1,
			/obj/item/weapon/reagent_containers/food/snacks/fishfingers = 1,

			)
/obj/effect/spawner/lootdrop/drinks_loot_spawner // drinks! Mostly if you want to have a random genned canteen etc.
		name = "drinks salvage spawner"
		lootdoubles = 1
		loot = list(
			/obj/item/weapon/reagent_containers/food/drinks/beer = 1,
			/obj/item/weapon/reagent_containers/food/drinks/coffee = 1,
			/obj/item/weapon/reagent_containers/food/drinks/bottle/orangejuice = 1,
			/obj/item/weapon/reagent_containers/food/drinks/bottle/cream = 1,
			/obj/item/weapon/reagent_containers/food/drinks/soda_cans/cola = 1,
			/obj/item/weapon/reagent_containers/food/drinks/soda_cans/dr_gibb = 1,
			/obj/item/weapon/reagent_containers/food/drinks/soda_cans/lemon_lime = 1,
			/obj/item/weapon/reagent_containers/food/drinks/soda_cans/sodawater = 1,
			/obj/item/weapon/reagent_containers/food/drinks/soda_cans/starkist = 1,
			/obj/item/weapon/reagent_containers/food/drinks/soda_cans/thirteenloko = 1,

			)

/obj/effect/spawner/lootdrop/abductor // Includes all abductor materials and equipment
		name ="abductor salvage spawner"
		nolootchance
		lootdoubles = 0
		loot = list(
			/obj/item/clothing/suit/armor/abductor/vest = 3,
			/obj/item/device/abductor/gizmo = 1,
			/obj/item/device/abductor/silencer = 1,
			/obj/item/device/firing_pin/abductor = 6,
			/obj/item/organ/tongue/abductor = 1,
			/obj/item/stack/sheet/mineral/abductor{amount = 5} = 2,
			/obj/item/weapon/abductor_baton = 3,

			)

/obj/effect/spawner/lootdrop/organs // Includes all organs except xeno ones
		name ="organs salvage spawner"
		lootdoubles = 1
		nolootchance = 2
		loot = list(
			/obj/item/organ/brain = 1,
			/obj/item/organ/lungs = 1,
			/obj/item/organ/heart = 1,
			/obj/item/organ/tongue = 1,
			/obj/item/organ/tongue/lizard = 1,
			/obj/item/organ/tongue/fly = 1,
			/obj/item/organ/appendix = 1,

			)

/obj/effect/spawner/lootdrop/mechs // lootdrop for mechs
		name ="mech salvage spawner"
		lootdoubles = 1
		nolootchance = 8
		loot = list(
			/obj/mecha/combat/durand = 2,
			/obj/mecha/combat/gygax = 2,
			/obj/mecha/combat/gygax/dark = 1,
			/obj/mecha/combat/marauder = 2,
			/obj/mecha/combat/marauder/mauler = 1,
			/obj/mecha/combat/phazon = 1,
			/obj/mecha/medical/odysseus = 3,
			/obj/mecha/working/ripley = 5,
			/obj/mecha/working/ripley/firefighter = 4,

			)


// DEPARTMENT BASED LOOT

/obj/effect/spawner/lootdrop/department/medical // medical supplies
		name ="medical department salvage spawner"
		lootdoubles = 1
		nolootchance = 10
		loot = list(
			/obj/item/weapon/storage/firstaid/brute = 4,
			/obj/item/weapon/storage/firstaid/fire = 4,
			/obj/item/weapon/storage/firstaid/o2 = 4,
			/obj/item/weapon/storage/firstaid/regular = 4,
			/obj/item/weapon/storage/firstaid/toxin = 4,
			/obj/item/stack/medical/bruise_pack = 5,
			/obj/item/stack/medical/ointment = 5,
			/obj/item/stack/medical/gauze = 5,
			/obj/item/weapon/reagent_containers/syringe/bluespace = 1,
			/obj/item/weapon/storage/pill_bottle/stimulant = 1,
			/obj/item/weapon/reagent_containers/glass/beaker/bluespace = 1,
			/obj/item/weapon/reagent_containers/hypospray/combat/nanites = 1,
			/obj/item/weapon/defibrillator/compact/combat/loaded = 3,
			/obj/item/weapon/gun/medbeam = 1,

			)


/obj/effect/spawner/lootdrop/department/engineering // tools, devices and doohickies used to make good machines
		name ="engineering department salvage spawner"
		lootdoubles = 1
		nolootchance = 5
		loot = list(
			/obj/item/weapon/storage/toolbox/mechanical = 5,
			/obj/machinery/power/port_gen/pacman/super = 1,
			/obj/item/weapon/circuitboard/machine/smes = 2,
			/obj/item/hardsuit_jetpack = 3,
			/obj/item/weapon/weldingtool/experimental = 3,
			/obj/item/weapon/stock_parts/capacitor/super = 3,
			/obj/item/weapon/stock_parts/cell/hyper = 3,
			/obj/item/weapon/rcd/loaded = 4,
			/obj/item/weapon/grenade/chem_grenade/smartmetalfoam = 5,

			)

/obj/effect/spawner/lootdrop/department/security // tools and equipment attributed to systematic oppression
		name ="security department salvage spawner"
		lootdoubles = 1
		loot = list(
			/obj/item/clothing/gloves/combat = 3,
			/obj/item/clothing/glasses/hud/security/night = 3,
			/obj/item/weapon/storage/box/flashbangs = 3,
			/obj/item/weapon/storage/box/emps = 1,
			/obj/item/weapon/storage/box/lethalshot = 2,
			/obj/item/clothing/suit/space/hardsuit/ert/sec = 1,
			/obj/item/weapon/storage/fancy/donut_box = 5,

			)

/obj/effect/spawner/lootdrop/department/science // tech, advanced stock parts and other knick knacks
		name ="science department salvage spawner"
		lootdoubles = 1
		loot = list(
			/obj/item/weapon/stock_parts/manipulator/femto = 5,
			/obj/item/weapon/stock_parts/matter_bin/bluespace = 5,
			/obj/item/weapon/stock_parts/micro_laser/quadultra = 5,
			/obj/item/weapon/stock_parts/scanning_module/triphasic = 5,
			/obj/item/weapon/storage/backpack/holding = 1,
			/obj/item/weapon/storage/part_replacer/bluespace = 3,
			nolootchance = 15

			)


/obj/effect/spawner/lootdrop/department/cargo // crates, crates and more crates
		name ="cargo department salvage spawner"
		lootdoubles = 1
		loot = list(
			/obj/structure/closet/crate/critter = 1 ,
			/obj/structure/closet/crate/large = 5,
			/obj/structure/closet/crate/secure/plasma = 1,
			/obj/structure/closet/crate/secure/loot = 3,
			/obj/structure/closet/crate/secure/weapon = 1,
			/obj/structure/closet/crate/medical = 4,
			/obj/structure/closet/crate/internals = 3,

			)


/obj/effect/spawner/lootdrop/shells // munition shells
		name ="munition shells salvage spawner"
		lootdoubles = 1
		loot = list(
			/obj/structure/shell = 1,
			/obj/structure/shell/shield_piercing = 3,
			/obj/structure/shell/smart_homing = 3,

			)

/obj/effect/spawner/lootdrop/slime_extracts // more controlled way of spawning slime extracts
		name ="slime extracts salvage spawner"
		lootdoubles = 1
		nolootchance = 5
		loot = list(
			/obj/item/slime_extract/adamantine = 2,
			/obj/item/slime_extract/black = 3,
			/obj/item/slime_extract/blue = 4,
			/obj/item/slime_extract/bluespace = 3,
			/obj/item/slime_extract/cerulean = 4,
			/obj/item/slime_extract/darkblue = 5,
			/obj/item/slime_extract/darkpurple = 2,
			/obj/item/slime_extract/gold = 1,
			/obj/item/slime_extract/green = 4,
			/obj/item/slime_extract/grey = 5,
			/obj/item/slime_extract/lightpink = 2,
			/obj/item/slime_extract/metal = 4,
			/obj/item/slime_extract/oil = 1,
			/obj/item/slime_extract/orange = 3,
			/obj/item/slime_extract/pink = 2,
			/obj/item/slime_extract/purple = 2,
			/obj/item/slime_extract/pyrite = 3,
			/obj/item/slime_extract/rainbow = 1,
			/obj/item/slime_extract/red = 3,
			/obj/item/slime_extract/sepia = 3,
			/obj/item/slime_extract/silver = 3,
			/obj/item/slime_extract/yellow = 3,

			)

/obj/effect/spawner/lootdrop/slime_potions // more controlled way of spawning slime potions
		name ="slime potions salvage spawner"
		lootdoubles = 1
		nolootchance = 10
		loot = list(
			/obj/item/slimepotion/docility = 5,
			/obj/item/slimepotion/enhancer = 4,
			/obj/item/slimepotion/fireproof = 3,
			/obj/item/slimepotion/mutator = 2,
			/obj/item/slimepotion/speed = 2,
			/obj/item/slimepotion/stabilizer = 3,
			/obj/item/slimepotion/steroid = 4,
			/obj/item/slimepotion/transference = 1,
			/obj/item/slimepotion/sentience = 1,

			)

/obj/effect/spawner/lootdrop/clown // for clown themed environments
		name ="clown loot salvage spawner"
		lootdoubles = 1
		loot = list(
			/obj/item/clothing/gloves/color/rainbow/clown = 3,
			/obj/item/clothing/shoes/clown_shoes/banana_shoes = 2,
			/obj/item/device/firing_pin/clown = 3,
			/obj/item/weapon/reagent_containers/food/snacks/grown/banana/bluespace = 2,
			/obj/item/mine/spawner/banana = 2,
			/obj/item/stack/sheet/mineral/bananium{amount = 15}= 1,
			/obj/item/weapon/grenade/clusterbuster/soap = 1,

			)

// WEAPON SPAWNERS

/obj/effect/spawner/lootdrop/weapons/guns_light // sidearms that have rather limited ammunition and usually can't finish the job
		name ="light gun salvage spawner"
		lootdoubles = 1
		nolootchance = 5
		loot = list(
			/obj/item/weapon/gun/projectile/automatic/pistol = 2,
			/obj/item/weapon/gun/projectile/automatic/pistol/APS = 1,
			/obj/item/weapon/gun/projectile/automatic/pistol/m1911 = 3,
			/obj/item/weapon/gun/projectile/automatic/pistol/c05r = 1,
			/obj/item/weapon/gun/energy/gun/mini = 2,
			/obj/item/weapon/gun/energy/gun/advtaser = 3,

			)

/obj/effect/spawner/lootdrop/weapons/guns_medium // more reliable and effective for killing
		name ="medium gun salvage spawner"
		lootdoubles = 1
		nolootchance = 5
		loot = list(
			/obj/item/weapon/gun/projectile/automatic/proto/unrestricted = 1,
			/obj/item/weapon/gun/projectile/automatic/c20r/unrestricted = 1,
			/obj/item/weapon/gun/projectile/revolver = 2,
			/obj/item/weapon/gun/projectile/automatic/wt550 = 3,
			/obj/item/weapon/gun/projectile/automatic/shotgun/bulldog/unrestricted = 2,
			/obj/item/weapon/gun/projectile/shotgun/lethal = 3,
			/obj/item/weapon/gun/energy/gun = 2,
			/obj/item/weapon/gun/energy/laser = 2,

			)

/obj/effect/spawner/lootdrop/weapons/guns_deadly // designed to be the most effective at killing, with balance in mind
		name ="deadly gun salvage spawner"
		lootdoubles = 1
		nolootchance = 10
		loot = list(
			/obj/item/weapon/gun/projectile/automatic/m90/unrestricted = 1,
			/obj/item/weapon/gun/projectile/shotgun/automatic/combat = 2,
			/obj/item/weapon/gun/projectile/revolver/mateba = 3,
			/obj/item/weapon/gun/projectile/automatic/sniper_rifle = 1,
			/obj/item/weapon/gun/projectile/automatic/l6_saw/unrestricted = 1,
			/obj/item/weapon/gun/energy/lasercannon = 2,

			)

/obj/effect/spawner/lootdrop/weapons/guns_ludicrous // guns that are designed to be unfair and have little to none balance
		name ="ludicrous gun salvage spawner"
		lootdoubles = 1
		nolootchance = 7
		loot = list(
			/obj/item/weapon/gun/projectile/automatic/xmg80 = 3,
			/obj/item/weapon/gun/projectile/automatic/aks74 = 2,
			/obj/item/weapon/gun/projectile/automatic/ar = 2,

			)

/obj/effect/spawner/lootdrop/weapons/melee_weapons // not enough variety with melee to split it into seperate categories
		name ="melee weapons salvage spawner"
		lootdoubles = 1
		loot = list(
			/obj/item/weapon/melee/energy/sword/saber = 1,
			/obj/item/weapon/melee/rapier = 3,
			/obj/item/weapon/katana = 2,
			/obj/item/weapon/twohanded/spear = 4,
			/obj/item/weapon/twohanded/fireaxe = 3,

			)
/obj/effect/spawner/lootdrop/weapons/shipweapon // put this where guns normally spawn. change nolootchance depending on what ship it is
	name ="ship weapon spawner"
	lootdoubles = 95
	loot = list(
		/obj/machinery/power/shipweapon = 5,

		)
