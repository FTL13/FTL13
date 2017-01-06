/obj/structure/volatile_bomb
	icon = 'icons/obj/volatile_bomb.dmi'
	name = "volatile bomb"
	desc = "A large, run down and vandalized bomb. You probably should treat it carefully. It has a monkey and Fuck NT graffitied on it"
	icon_state = "fuck_you"

	anchored = 0
	density = 1
	var/health = 5
	var/exploded = FALSE

/obj/structure/volatile_bomb/proc/boom()
	if(exploded == FALSE)
		exploded = TRUE
		playsound(src.loc, 'sound/machines/ding.ogg',100,1)
		sleep(20)
		explosion(get_turf(src), 3, 9, 17, flame_range = 17)
		qdel(src)

/obj/structure/volatile_bomb/blob_act(obj/effect/blob/B)
	message_admins("[key_name_admin(B.overmind)] (<A HREF='?_src_=holder;adminmoreinfo=\ref[B.overmind]'>?</A>) (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[B.overmind]'>FLW</A>) Hit a volatile bomb!")
	boom()

/obj/structure/volatile_bomb/ex_act()
	boom()

/obj/structure/volatile_bomb/fire_act()
	boom()

/obj/structure/volatile_bomb/tesla_act()
	..() //extend the zap
	boom()

/obj/structure/volatile_bomb/attack_hand(mob/living/user)
	user.visible_message("<span class='danger'>[user] tries to hug the [src]. Risky move.</span>")
	playsound(src.loc, pick (
				'sound/effects/bodyfall1.ogg',
				'sound/effects/bodyfall2.ogg',
				'sound/effects/bodyfall3.ogg',
				'sound/effects/bodyfall4.ogg',),40,0)

obj/structure/volatile_bomb/attackby(obj/item/I, mob/living/user)
	message_admins("[key_name_admin(user)] (<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[user]'>FLW</A>) Hit a volatile bomb!")
	if(user.a_intent == "harm")
		user.visible_message("<span class='danger'>[user] is fucking mentally handicapped and hits the [src] with [I].</span>") //it's true
		playsound(src.loc, 'sound/items/trayhit2.ogg')
		health -= 2
		..()

		if(health <= 0)
			boom()

	else
		user.visible_message("<span class='danger'>[user] taps the [src] with [I]. That probably wasn't a great idea.</span>") //it's true
		playsound(src.loc, 'sound/items/trayhit1.ogg')
		health -= 1
		..()

		if(health <= 0)
			boom()
