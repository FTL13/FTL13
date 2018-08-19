/obj/item/weapon_chip //PLAYER CUSTOMIZATION FOR WEAPON FRAME
  name = "basic phase cannon chip"
  desc = "I could use this to change the programming of the ship's attack matrix" //lol what does that even mean
  icon = 'icons/obj/items.dmi'
  icon_state = "permit" //PLACEHOLDER

  var/weapon_name = "Phaser Cannon"
  var/icon_name ="phase_cannon"

  var/projectile_type = /obj/item/projectile/ship_projectile/phase_blast
  var/fire_sound = 'sound/effects/phasefire.ogg'
  var/datum/ship_attack/attack_data = new /datum/ship_attack/laser

  var/charge_to_fire = 2000


/obj/item/weapon_chip/ion
  name = "ion cannon chip"
  weapon_name = "Ion Cannon"
  icon_name ="ion_cannon"

  projectile_type = /obj/item/projectile/ship_projectile/phase_blast/ion
  fire_sound = 'sound/weapons/emitter2.ogg'

  attack_data = new /datum/ship_attack/ion

  charge_to_fire = 10000
