// This is basically a communications hologram mob. It can exist in nullspace
// or it can be manifested on a communications holopad. It usually controls a
// ship, unless it's adminspawned, then it's just a CC hologram or something.
/mob/communicator
	name = "Communicator"
	desc = "A communications hologram. This person is somewhere else, but he is being projected here via a communications device."
	var/datum/starship/linked_ship
	anchored = 1
	status_flags = GODMODE  // You can't damage it.
	languages_spoken = HUMAN
	languages_understood = HUMAN

/mob/communicator/New()
	gender = pick(MALE,FEMALE)
	name = random_unique_name(gender)
	..()

/mob/communicator/proc/update_hologram_to_outfit(datum/outfit/O)
	if(!O)
		return
	var/mob/living/carbon/human/dummy/mannequin = new()
	O.equip(mannequin, 1)
	CHECK_TICK
	var/icon/mob_icon = icon('icons/effects/effects.dmi', "nothing")
	CHECK_TICK
	// This is a bit of extra work, but I find it really annoying when sprites
	// permanently face south (I'm looking at you, Paradise)
	for(var/cdir in cardinal)
		mannequin.setDir(cdir)
		mob_icon.Insert(getFlatIcon(mannequin), dir=cdir)
		CHECK_TICK
	icon = getHologramIcon(mob_icon, 1, "green")

/mob/communicator/Hear(message, atom/movable/speaker, message_langs, raw_message, radio_freq, list/spans)
	src << "[message]"