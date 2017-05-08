/obj/item/mine
	name = "dummy mine"
	desc = "Better stay away from that thing."
	density = 0
	anchored = 0
	icon = 'icons/obj/weapons.dmi'
	icon_state = "uglymine"
	var/triggered = 0
	var/active = 0

/obj/item/mine/attack_self(mob/user)
	if(active)
		return
	to_chat(user, "<span class='notice'>[user] activated \icon[src] [src]!</span>")
	visible_message("<span class='notice'>\icon[src]beep!</span>")
	active = 1
	anchored = 1
	icon_state = "[initial(icon_state)]set"

/obj/item/mine/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/wirecutters))
		to_chat(user, "Defusing [src]...")
		if(do_after(user,50,target = src))
			visible_message("<span class='notice'>[src] defused by [user]!</span>")
			active = 0
			anchored = 0
			icon_state = initial(icon_state)

/obj/item/mine/proc/mineEffect(mob/victim)
	to_chat(victim, "<span class='danger'>*click*</span>")

/obj/item/mine/Crossed(AM as mob|obj)
	if(isturf(loc))
		if(isanimal(AM))
			var/mob/living/simple_animal/SA = AM
			if(!SA.flying)
				triggermine(SA)
		else
			triggermine(AM)

/obj/item/mine/proc/triggermine(mob/victim)
	if(triggered || !active)
		return
	visible_message("<span class='danger'>[victim] sets off \icon[src] [src]!</span>")
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	mineEffect(victim)
	triggered = 1
	qdel(src)


/obj/item/mine/explosive
	name = "explosive mine"
	var/range_devastation = 0
	var/range_heavy = 0
	var/range_light = 4
	var/range_flash = 4

/obj/item/mine/explosive/mineEffect(mob/victim)
	explosion(loc, range_devastation, range_heavy, range_light, range_flash)
	if(ishuman(victim))
		var/mob/living/carbon/human/hvictim = victim
		hvictim.adjustBruteLoss(rand(30,50))

/obj/item/mine/stun
	name = "stun mine"
	var/stun_time = 8

/obj/item/mine/stun/mineEffect(mob/victim)
	if(isliving(victim))
		victim.Weaken(stun_time)

/obj/item/mine/tesla
	name = "ZAP mine"
	var/watts = 10000

/obj/item/mine/tesla/mineEffect(mob/victim)
	if(isliving(victim))
		playsound(victim.loc, 'sound/magic/LightningShock.ogg', 100, 1, extrarange = 5)
		tesla_zap(victim, 3, watts) //ZAP for 1/5000 of the amount of power, which is from 15-25 with 200000W

/obj/item/mine/kickmine
	name = "kick mine"

/obj/item/mine/kickmine/mineEffect(mob/victim)
	if(isliving(victim) && victim.client)
		to_chat(victim, "<span class='userdanger'>You have been kicked FOR NO REISIN!</span>")
		del(victim.client)


/obj/item/mine/gas
	name = "oxygen mine"
	var/gas_amount = 360
	var/gas_type = "o2"

/obj/item/mine/gas/mineEffect(mob/victim)
	atmos_spawn_air("[gas_type]=[gas_amount]")


/obj/item/mine/gas/plasma
	name = "plasma mine"
	gas_type = "plasma"


/obj/item/mine/gas/n2o
	name = "\improper N2O mine"
	gas_type = "n2o"

/obj/item/mine/spawner
	name = "Spawner mine"
	var/spawner_type = null // must be an object path
	var/deliveryamt = 1 // amount of type to deliver

/obj/item/mine/spawner/mineEffect(mob/victim)
	if(spawner_type && deliveryamt)
		// Make a quick flash
		var/turf/T = get_turf(src)
		playsound(T, 'sound/effects/phasein.ogg', 100, 1)
		for(var/mob/living/carbon/C in viewers(T, null))
			C.flash_eyes()
		for(var/i=1, i<=deliveryamt, i++)
			var/atom/movable/x = new spawner_type
			x.loc = T
			if(prob(50))
				for(var/j = 1, j <= rand(1, 3), j++)
					step(x, pick(NORTH,SOUTH,EAST,WEST))

/obj/item/mine/spawner/soap
	name = "Soap Mine"
	spawner_type = /obj/item/weapon/soap/syndie
	deliveryamt = 5

/obj/item/mine/spawner/banana
	name = "Banana Mine"
	spawner_type = /obj/item/weapon/grown/bananapeel/bluespace
	deliveryamt = 5

/obj/item/mine/spawner/carp
	name = "Carp Mine"
	spawner_type = /mob/living/simple_animal/hostile/carp
	deliveryamt = 3

/obj/item/mine/sound
	name = "honkblaster 1000"
	var/sound = 'sound/items/bikehorn.ogg'

/obj/item/mine/sound/mineEffect(mob/victim)
	playsound(loc, sound, 100, 1)

/obj/item/mine/sound/bwoink
	name = "bwoink mine"
	sound = 'sound/effects/adminhelp.ogg'

/obj/item/mine/pickup
	name = "pickup"
	desc = "pick me up"
	icon = 'icons/effects/effects.dmi'
	icon_state = "electricity2"
	density = 0
	active = 1
	var/duration = 0

/obj/item/mine/pickup/New()
	..()
	animate(src, pixel_y = 4, time = 20, loop = -1)

/obj/item/mine/pickup/triggermine(mob/victim)
	if(triggered)
		return
	triggered = 1
	invisibility = INVISIBILITY_ABSTRACT
	mineEffect(victim)
	qdel(src)


/obj/item/mine/pickup/bloodbath
	name = "Red Orb"
	desc = "You feel angry just looking at it."
	duration = 1200 //2min
	color = "red"

/obj/item/mine/pickup/bloodbath/mineEffect(mob/living/carbon/victim)
	if(!victim.client || !istype(victim))
		return
	to_chat(victim, "<span class='reallybig redtext'>RIP AND TEAR</span>")
	victim << 'sound/misc/e1m1.ogg'
	var/old_color = victim.client.color
	var/red_splash = list(1,0,0,0.8,0.2,0, 0.8,0,0.2,0.1,0,0)
	var/pure_red = list(0,0,0,0,0,0,0,0,0,1,0,0)

	spawn(0)
		new /obj/effect/hallucination/delusion(victim.loc,victim,force_kind="demon",duration=duration,skip_nearby=0)

	var/obj/item/weapon/twohanded/required/chainsaw/doomslayer/chainsaw = new(victim.loc)
	chainsaw.flags |= NODROP
	victim.drop_r_hand()
	victim.drop_l_hand()
	victim.put_in_hands(chainsaw)

	victim.reagents.add_reagent("adminordrazine",25)

	victim.client.color = pure_red
	animate(victim.client,color = red_splash, time = 10, easing = SINE_EASING|EASE_OUT)
	sleep(10)
	animate(victim.client,color = old_color, time = duration)//, easing = SINE_EASING|EASE_OUT)
	sleep(duration)
	to_chat(victim, "<span class='notice'>Your bloodlust seeps back into the bog of your subconscious and you regain self control.<span>")
	qdel(chainsaw)
	qdel(src)

/obj/item/mine/pickup/healing
	name = "Blue Orb"
	desc = "You feel better just looking at it."
	color = "blue"

/obj/item/mine/pickup/healing/mineEffect(mob/living/carbon/victim)
	if(!victim.client || !istype(victim))
		return
	to_chat(victim, "<span class='notice'>You feel great!</span>")
	victim.revive(full_heal = 1, admin_revive = 1)

/obj/item/mine/pickup/speed
	name = "Yellow Orb"
	desc = "You feel faster just looking at it."
	color = "yellow"
	duration = 300

/obj/item/mine/pickup/speed/mineEffect(mob/living/carbon/victim)
	if(!victim.client || !istype(victim))
		return
	to_chat(victim, "<span class='notice'>You feel fast!</span>")
	victim.status_flags |= GOTTAGOREALLYFAST
	sleep(duration)
	victim.status_flags &= ~GOTTAGOREALLYFAST
	to_chat(victim, "<span class='notice'>You slow down.</span>")
