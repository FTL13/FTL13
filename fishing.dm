/turf/open/fishing/water
	name = "deep water puddle"
	desc = "Who knows what lays within?"
	icon = 'icons/obj/fishing.dmi'
	icon_state = "puddle" //this is temp pending keek's sprites
	var/baited


//turf/open/fishing/water/fishcatch()



/turf/open/fishing/water/attackby(obj/item/I, mob/user, params)
//	if(istype(I, /obj/item/weapon/fishing/pole/))
//		baited = bait_power * chance //Bait power multiplies the rod's power
//		user.visible_message("<span class='warning'>[user] casts their fishing line into the [src].</span>")
//		if(prob(baited))
//			fishcatch()
//		if(prob(100-baited)) //100 minus the probability gives us the remaining probability that it fucks up
////			user.visible_message("<span class='warning'>Your line dangles there akwardly as no fish take the bait.</span>")
//			return
//
//		return ..()
//
	if(istype(I, /obj/item/weapon/fishing/pulser))
		user.visible_message("<span class='warning'>[user] places a pulser on top of the [src]</span>")
//
	if(!istype(I, /obj/item/weapon/fishing/pulser))
		user.visible_message("<span class='warning'>[user] dips something into the [src]</span>")
		return ..()

//I will handle all the fishy calculations in this attackby, so it draws carp up and rolls the dice etc. etc.


//This will be phased out once i get the code actually working, this is just for prototyping








///Items/////////////////////////////////////////////
//												   //
/////////////////////////////////////////////////////



//EXPERIMENTAL//




/////////Bait//////////////////




/obj/item/weapon/fishing/pole
	name = "Fishing Pole"
	desc = "A basic rod made from wire and metal"
	icon = 'icons/obj/fishing.dmi'
	icon_state = "pole" //remember to change this
	var/chance = 30 //lowest chance for getting a fisherino, playtest to see
	var/bait_power = 0 //when bait added, chance increased will put in an if(then chance * bait power etc.)
	var/cancatch = 1 //What carp types can we catch? higher numbers = more rare carp
	var/baited
	var/carp_type = /mob/living/simple_animal/hostile/carp
	var/carpnumber = 1
	var/fishingspeed = 50 //5 seconds to catch a fish potentially

/obj/item/weapon/fishing/pole/admin
	name = "ADMIN Fishing Pole"
	desc = "REEEEEE"
	chance = 100
	cancatch = 8 //god pole catches all, and never uses bait
	fishingspeed = 0 //GOD POLE


/obj/item/weapon/fishing/pole/attackby(obj/item/I, mob/user, params)	//baiting uk shit pls kick
	if(istype(I, /obj/item/weapon/fishing/bait))
		var/obj/item/weapon/fishing/bait/B = I
		bait_power = B.bait_power
		cancatch = B.cancatch
		icon_state = "pole_bait"
		user.visible_message("<span class='warning'>[user] adds the [I] to the [src] creating an effective lure.</span>")
		qdel(B)

	if(istype(I, /obj/item/stack))
		var/obj/item/stack/B = I
		//B.Split(1,2)
		bait_power = B.bait_power
		cancatch = B.cancatch
		icon_state = "pole_bait"
		user.visible_message("<span class='warning'>[user] adds the [I] to the [src] creating a crude lure.</span>")		//dump minerals on rods for lures
		qdel(B) //will likely kill popped stack as well, need to test

	else
		user.visible_message("<span class='warning'>[user] slaps their [src] with the [I].</span>")



/obj/item/weapon/fishing/pole/proc/rollthedice() //WHAT CARP ARE WE GONNA GET OH BOY OH BOY
	var/list/carppossibilities = list(/mob/living/simple_animal/hostile/carp, /mob/living/simple_animal/hostile/carp/megacarp)		//all the carps it can be, we will change this with cancatch
	if(cancatch == 1)
		carp_type = pick(carppossibilities)
		caught()
		cancatch = 1 //Bait is used in catching process
		icon_state = "pole"


	if(cancatch == 2)
		carppossibilities += (/mob/living/simple_animal/hostile/carp/radcarp) //mob/living/simple_animal/hostile/carp/megacarp/radcarp
		carp_type = pick(carppossibilities)
		caught()
		cancatch = 1 //Bait is used in catching process
		icon_state = "pole"

	if(cancatch == 3)
		carppossibilities += (/mob/living/simple_animal/hostile/carp/angler) //mob/living/simple_animal/hostile/carp/megacarp/angler
		carp_type = pick(carppossibilities)
		caught()
		cancatch = 1 //Bait is used in catching process
		icon_state = "pole"

	if(cancatch == 4) //both radcarp AND megarad
		carppossibilities += (/mob/living/simple_animal/hostile/carp/radcarp)
		carppossibilities += (/mob/living/simple_animal/hostile/carp/radcarp/nukacarp)
		carp_type = pick(carppossibilities)
		caught()
		cancatch = 1 //Bait is used in catching process
		icon_state = "pole"

	if(cancatch == 5) //both angler AND deepcarp
		carppossibilities += (/mob/living/simple_animal/hostile/carp/angler) //mob/living/simple_animal/hostile/carp/megacarp/angler
		carppossibilities += (/mob/living/simple_animal/hostile/carp/angler/deep)
		carp_type = pick(carppossibilities)
		caught()
		cancatch = 1 //Bait is used in catching process
		icon_state = "pole"





/obj/item/weapon/fishing/pole/proc/caught()			// Prime now just handles the two loops that query for people in lockers and people who can see it.
	if(carp_type && carpnumber)
		var/turf/T = get_turf(src)
		playsound(T, 'sound/effects/phasein.ogg', 100, 1)
		for(var/i=1, i<=carpnumber, i++)
			var/atom/movable/x = new carp_type
			x.loc = T
			if(prob(50))
				for(var/j = 1, j <= rand(1, 3), j++)
					step(x, pick(NORTH,SOUTH,EAST,WEST))






/obj/item/weapon/fishing/pole/afterattack(atom/I, mob/user, proximity)
	if(istype(I, /turf/open/fishing/water))
		baited = bait_power * chance //Bait power multiplies the rod's power
		user.visible_message("<span class='warning'>[user] casts their fishing line into the [I].</span>")
		if(do_after(user, fishingspeed))
			if(prob(70)) //change this later
				user.visible_message("<span class='warning'>A wild carp bites the line and eats the bait! PULL!!!!.</span>")
				rollthedice()
			else //100 minus the probability gives us the remaining probability that it fucks up
				user.visible_message("<span class='warning'>Your line dangles there akwardly as no fish take the bait.</span>")
				return





/obj/item/weapon/fishing/bait
	name = "Fish Bait"
	desc = "A ball of stuff that's meant to be bait, what else"
	icon = 'icons/obj/fishing.dmi'
	icon_state = "bait" //remember to change this
	var/bait_power = 1.3 //basic bait only gives a teeny boost
	var/cancatch = 1 //Only able to catch basic carp with this crappy bait

/obj/item/weapon/fishing/bait/metal
	name = "Metal Bait"
	desc = "A ball of metal formed in a carp edible shape."
	icon = 'icons/obj/fishing.dmi'
	icon_state = "bait_metal" //remember to change this
	bait_power = 1.5 //gives it a good kick, but not masses
	cancatch = 2 //Basic carp and radioactive carp can be caught

/obj/item/weapon/fishing/bait/glowing
	name = "Glowing Bait"
	desc = "A ball of luminescant bait."
	icon = 'icons/obj/fishing.dmi'
	icon_state = "bait_glowing" //remember to change this
	bait_power = 1.7 //higher tier bait
	cancatch = 3 //deep carp can be caught



//ree



/////Pulsermajig/////

	//, its depth is set to [depth] and its power is at setting [setting], CTRL click it to set its intensity, and click it normally to set depth//

/obj/item/weapon/fishing/pulser
	name = "Sonic Pulser"
	desc = "This nifty device is used to draw lurking carp from the depths"
	icon = 'icons/obj/fishing.dmi'
	icon_state = "pulser"
	var/depth = 0 //depth is set manually
	var/setting = 0 //How powerful is the pulse, depth dictates what carp, this dictates how MANY

/obj/item/weapon/fishing/pulser/attack_self(mob/user)
	var/mode = input("Sonic Pulser.", "Modify Settings", "cancel") in list("Modify Settings", "cancel") //input defined here, may be a bad idea
	var/depthlevel = input("Depth setting.", "Set Depth Level Modifier", "cancel") in list("1", "2", "3", "4", "5", "cancel")
	var/pulselevel = input("Pulse setting.", "Set Pulse Intensity", "cancel") in list("1", "2", "3", "4", "5", "cancel")
	switch(mode)
		if("Modify Settings")
			switch(depthlevel) 		//long drawn way of doing it but i'm bad at this soooo.
				if("1")
					depth = 1
					icon_state = "pulser_1"
				if("2")
					depth = 2
					icon_state = "pulser_2"
				if("3")
					depth = 3
					icon_state = "pulser_3"
				if("4")
					depth = 4
					icon_state = "pulser_4"
				if("5")
					depth = 5
					icon_state = "pulser_5"

			switch(pulselevel) 		//long drawn way of doing it but i'm bad at this soooo.
				if("1")
					depth = 1
					icon_state = "pulser_1"
				if("2")
					depth = 2
					icon_state = "pulser_2"
				if("3")
					depth = 3
					icon_state = "pulser_3"
				if("4")
					depth = 4
					icon_state = "pulser_4"
				if("5")
					depth = 5
					icon_state = "pulser_5"












//	user.visible_message("<span class='warning'>[user] increases the depth setting on their [src]</span>")			//old clunky way of doing it
//	if(depth < 5) //only 5 depth settings allowed
//		depth += 1
//	else
//		user.visible_message("<span class='warning'>[user] resets the depth setting on their [src] back to 0</span>")
//		depth = 0

//obj/item/weapon/fishing/pulser/CtrlClick //Ctrl click to set intensity
//	visible_message("<span class='warning'>[user] increases the power setting on their [src]</span>")
//	if(setting < 5) //counter, only 5 settings allowed
//		setting += 1
//	else
//		visible_message("<span class='warning'>[user] resets the power setting of their [src] back to 0</span>")
//		setting = 0


