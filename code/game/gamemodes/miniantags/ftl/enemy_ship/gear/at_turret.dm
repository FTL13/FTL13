/obj/machinery/at_field
  name="A.G. Field generator"
  desc="Disables incoming grenades in a range of 7 tiles. Wrench to floor to make it work."
  icon_state = "Shield_Gen"
  anchored = 0
  density = 1
  var/health = 100
  var/maxhealth = 100
  var/at_range=7

/obj/machinery/at_field/process()
  if(anchored)
    for(var/obj/item/weapon/grenade/G in orange(at_range,src))
      if(G.active)
        playsound(src.loc, 'sound/magic/Repulse.ogg', 100, 1, extrarange = 30)
        Beam(G, icon_state="lightning[rand(1,5)]", icon='icons/effects/effects.dmi', time=5)
        G.active = 0 //yeah so easy
        visible_message("<span class='notice'>[G] got disabled by A.G. field!")

/obj/machinery/at_field/take_damage(damage, damage_type = BRUTE, sound_effect = 1)
  ..()
  health -= damage
  if(health <= 0)
    var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
    s.set_up(3, 1, src)
    s.start()
    for(var/obj/item/weapon/grenade/G in orange(at_range,src))
      G.prime()
    visible_message("<span class='notice'>Grenades got primed again!")
    qdel(src)

/obj/machinery/at_field/attackby(obj/item/P, mob/user, params)
  if(default_unfasten_wrench(user, P))
    if(anchored)
      icon_state = "[initial(icon_state)] +a"
    else
      icon_state = initial(icon_state)
    return

/obj/machinery/at_field/attacked_by(obj/item/I, mob/living/user)
	..()
	take_damage(I.force)

/obj/machinery/at_field/bullet_act(obj/item/projectile/P)
	. = ..()
	visible_message("<span class='warning'>\The [src] is hit by [P]!</span>")
	take_damage(P.damage)

/obj/machinery/at_field/ex_act(severity, target)
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			take_damage(25, BRUTE, 0)
