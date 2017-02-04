/obj/item/projectile/ship_projectile
	name = "ship projectile"

	range = 500

	var/datum/ship_attack/attack_data = null
	var/datum/starship/target = null
	var/armed = 1 //for armable weapons

/obj/item/projectile/ship_projectile/proc/set_armed(var/is_armed=1)
	armed = is_armed

/obj/item/projectile/ship_projectile/transition_act()
	if(!armed)
		SSship.broadcast_message("Error: [src] fired but not armed.")
	var/datum/ship_attack/data = new attack_data
	if(target && armed) SSship.damage_ship(target,data.hull_damage,data.evasion_mod,data.shield_bust)
	qdel(src)


/obj/item/projectile/ship_projectile/mac_round
	name = "\improper MAC cannon round"
	icon_state = "mac_round"

	damage = 300 //Will literally annihilate you if it hits you.
	damage_type = BRUTE
	nodamage = 0
	flag = "bullet"

/obj/item/projectile/ship_projectile/phase_blast
	name = "phase cannon blast"
	icon_state = "emitter"

	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage = 30
	luminosity = 2
	damage_type = BURN
	hitsound = 'sound/weapons/sear.ogg'
	hitsound_wall = 'sound/weapons/effects/searwall.ogg'
	flag = "laser"
	eyeblur = 2


	legacy = 1
	animate_movement = SLIDE_STEPS //copies all the shit from the emitter beam

	attack_data = /datum/ship_attack/laser

/obj/effect/landmark/ship_fire/Crossed(atom/movable/A)
	if(istype(A,/obj/item/projectile/ship_projectile))
		A.transition_act()