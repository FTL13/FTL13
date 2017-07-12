GLOBAL_DATUM_INIT(player_attack, /datum/player_ship_attack, new)

/datum/player_ship_attack
	var/cname = "Player Ship Attack"

	var/shot_amount = null
	var/projectile_type = null
	var/projectile_sound = null

/datum/player_ship_attack/laser
	cname = "Phaser Cannon Attack"

	shot_amount = 3
	projectile_type = /obj/item/projectile/ship_projectile/phase_blast
	projectile_sound = 'sound/effects/phasefire.ogg'
