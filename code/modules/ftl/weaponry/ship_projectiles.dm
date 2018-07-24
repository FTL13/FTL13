/obj/item/projectile/ship_projectile //PHYSICAL PROJECTILE OF WEAPONS
	name = "ship projectile"

	range = 500

	var/datum/ship_attack/attack_data = null
	var/datum/starship/target = null
	var/armed = 1 //for armable weapons

	var/shooter //Used for logging starting wars

/obj/item/projectile/ship_projectile/proc/set_armed(var/is_armed=1)
	armed = is_armed

/obj/item/projectile/ship_projectile/transition_act()
	if(!attack_data)
		SSship.broadcast_message("Error: [src] fired but not armed.")
		qdel(src)
		return
	var/datum/ship_attack/data = attack_data //???
	if(target) SSship.damage_ship(target,data,null,shooter)
	qdel(src)


/obj/item/projectile/ship_projectile/mac_round
	name = "\improper MAC cannon round"
	icon_state = "mac_round"

	damage = 300 //Will literally annihilate you if it hits you.
	damage_type = BRUTE
	nodamage = 0
	flag = "bullet"

/obj/effect/landmark/ship_fire/Crossed(atom/movable/A)
	if(istype(A,/obj/item/projectile/ship_projectile))
		A.transition_act()

/obj/item/projectile/ship_projectile/phase_blast
	name = "phase cannon blast"
	icon_state = "phase_cannon"

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

/obj/item/projectile/ship_projectile/phase_blast/ion
	name = "ion cannon blast"
	icon_state = "tesla_projectile"

	hitsound = 'sound/weapons/zapbang.ogg'
	hitsound_wall = 'sound/weapons/zapbang.ogg'
