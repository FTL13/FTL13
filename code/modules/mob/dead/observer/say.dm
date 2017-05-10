/mob/dead/observer/say(message)
	message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))

	if (!message)
		return

	log_say("Ghost/[src.key] : [message]")

<<<<<<< HEAD
=======
	if(jobban_isbanned(src, "OOC"))
		to_chat(src, "<span class='danger'>You have been banned from deadchat.</span>")
		return

	if (src.client)
		if(src.client.prefs.muted & MUTE_DEADCHAT)
			to_chat(src, "<span class='danger'>You cannot talk in deadchat (muted).</span>")
			return

		if (src.client.handle_spam_prevention(message,MUTE_DEADCHAT))
			return

>>>>>>> master
	. = src.say_dead(message)

/mob/dead/observer/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode)
	var/atom/movable/to_follow = speaker
	if(radio_freq)
		var/atom/movable/virtualspeaker/V = speaker

		if(isAI(V.source))
			var/mob/living/silicon/ai/S = V.source
			to_follow = S.eyeobj
		else
<<<<<<< HEAD
			to_follow = V.source
	var/link = FOLLOW_LINK(src, to_follow)
	// Recompose the message, because it's scrambled by default
	message = compose_message(speaker, message_language, raw_message, radio_freq, spans, message_mode)
=======
			speaker = V.source
	var/link = FOLLOW_LINK(src, speaker)
>>>>>>> master
	to_chat(src, "[link] [message]")

