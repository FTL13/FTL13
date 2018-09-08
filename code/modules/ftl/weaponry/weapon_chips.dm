/obj/item/weapon_chip //PLAYER CUSTOMIZATION FOR WEAPON FRAME
  name = "burst phase cannon chip"
  desc = "I could use this to change the programming of the ship's attack matrix" //lol what does that even mean
  icon = 'icons/obj/items.dmi'
  icon_state = "permit" //PLACEHOLDER

  var/weapon_name = "Burst Phaser Cannon"
  var/weapon_desc = "A powerful weapon designed to damage the hull of other ships. This one fires a three round burst"
  var/icon_name = "phase_cannon"

  var/projectile_type = /obj/item/projectile/ship_projectile/phase_blast
  var/fire_sound = 'sound/effects/phasefire.ogg'
  var/datum/ship_attack/attack_data = new /datum/ship_attack/laser/burst

  var/charge_to_fire = 2000


/obj/item/weapon_chip/laser_basic
  name = "basic phase cannon chip"

  weapon_name = "Basic Phaser Cannon"
  weapon_desc = "A powerful weapon designed to damage the hull of other ships."

  attack_data = new /datum/ship_attack/laser


/obj/item/weapon_chip/laser_focused
  name = "focused phase cannon chip"

  weapon_name = "Focused Phaser Cannon"
  weapon_desc = "A powerful weapon designed to damage the hull of other ships. This one travels faster and is easier to aim."

  attack_data = new /datum/ship_attack/laser/focused


/obj/item/weapon_chip/laser_heavy
  name = "heavy phase cannon chip"

  weapon_name = "Heavy Phaser Cannon"
  weapon_desc = "A powerful weapon designed to damage the hull of other ships. This one deals more damage."

  attack_data = new /datum/ship_attack/laser/heavy


/obj/item/weapon_chip/laser_gatling
  name = "gatling phase cannon chip"

  weapon_name = "Gatling Phaser Cannon"
  weapon_desc = "A powerful weapon designed to damage the hull of other ships. This one rapidly unloads at the targetted ship, but will probably hit everything behind it."

  attack_data = new /datum/ship_attack/laser/gatling




/obj/item/weapon_chip/ion
  name = "ion cannon chip"
  weapon_name = "Ion Cannon"
  weapon_desc = "A powerful weapon designed to break through shields and unpower key components on enemy ships."
  icon_name ="ion_cannon"

  projectile_type = /obj/item/projectile/ship_projectile/phase_blast/ion
  fire_sound = 'sound/weapons/emitter2.ogg'

  attack_data = new /datum/ship_attack/ion

  charge_to_fire = 5000
