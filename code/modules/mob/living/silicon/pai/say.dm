/mob/living/silicon/pai/say(msg)
<<<<<<< HEAD
	if(silent)
=======
	if(silence_time)
>>>>>>> master
		to_chat(src, "<span class='warning'>Communication circuits remain unitialized.</span>")
	else
		..(msg)

/mob/living/silicon/pai/binarycheck()
	return 0
