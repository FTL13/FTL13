/obj/item/device/megaphone
	name = "megaphone"
	desc = "A device used to project your voice. Loudly."
	icon_state = "megaphone"
	item_state = "radio"
	w_class = WEIGHT_CLASS_SMALL
	siemens_coefficient = 1
	var/spamcheck = 0
	var/emagged = 0
<<<<<<< HEAD
	var/list/voicespan = list(SPAN_COMMAND)
=======
	var/insults = 0
	var/voicespan = "command_headset" // sic
	var/list/insultmsg = list("FUCK EVERYONE!", "DEATH TO LIZARDS!", "ALL SECURITY TO SHOOT ME ON SIGHT!", "I HAVE A BOMB!", "CAPTAIN IS A COMDOM!", "FOR THE SYNDICATE!", "VIVA!", "HONK!")

/obj/item/device/megaphone/attack_self(mob/living/carbon/human/user)
	if(user.client)
		if(user.client.prefs.muted & MUTE_IC)
			to_chat(src, "<span class='warning'>You cannot speak in IC (muted).</span>")
			return

	if(!ishuman(user))
		to_chat(user, "<span class='warning'>You don't know how to use this!</span>")
		return
>>>>>>> master

/obj/item/device/megaphone/get_held_item_speechspans(mob/living/carbon/user)
	if(spamcheck > world.time)
		to_chat(user, "<span class='warning'>\The [src] needs to recharge!</span>")
<<<<<<< HEAD
	else
=======
		return

	var/message = copytext(sanitize(input(user, "Shout a message?", "Megaphone", null)  as text),1,MAX_MESSAGE_LEN)
	if(!message)
		return

	message = capitalize(message)
	if(!user.can_speak(message))
		to_chat(user, "<span class='warning'>You find yourself unable to speak at all!</span>")
		return

	if ((src.loc == user && user.stat == 0))
		if(emagged)
			if(insults)
				user.say(pick(insultmsg),"machine", list(voicespan))
				insults--
			else
				to_chat(user, "<span class='warning'>*BZZZZzzzzzt*</span>")
		else
			user.say(message,"machine", list(voicespan))

>>>>>>> master
		playsound(loc, 'sound/items/megaphone.ogg', 100, 0, 1)
		spamcheck = world.time + 50
		return voicespan

/obj/item/device/megaphone/emag_act(mob/user)
	to_chat(user, "<span class='warning'>You overload \the [src]'s voice synthesizer.</span>")
	emagged = 1
	voicespan = list(SPAN_REALLYBIG, "userdanger")

/obj/item/device/megaphone/sec
	name = "security megaphone"
	icon_state = "megaphone-sec"

/obj/item/device/megaphone/command
	name = "command megaphone"
	icon_state = "megaphone-command"

/obj/item/device/megaphone/cargo
	name = "supply megaphone"
	icon_state = "megaphone-cargo"

/obj/item/device/megaphone/clown
	name = "clown's megaphone"
	desc = "Something that should not exist."
	icon_state = "megaphone-clown"
	voicespan = list(SPAN_CLOWN)