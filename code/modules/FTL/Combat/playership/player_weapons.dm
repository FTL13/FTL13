/datum/player_ship_attack
	var/name = "Player Ship Attack"

	var/shot_amount
	var/required_charge
	var/projectile_type
	var/projectile_sound

/datum/player_ship_attack/laser
	name = "Phaser Cannon Attack"

	shot_amount = 3
	required_charge = 1000
	projectile_type = /obj/item/projectile/ship_projectile/phase_blast
	projectile_sound = 'sound/effects/phasefire.ogg'

/datum/player_ship_attack/heavylaser
	name = "Heavy Phaser Cannon Attack"

	required_charge = 1500
	shot_amount = 1
	projectile_type = /obj/item/projectile/ship_projectile/heavy_phase_blast
	projectile_sound = 'sound/effects/phasefire.ogg'
