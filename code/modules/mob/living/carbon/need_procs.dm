/mob/living/carbon/proc/print_happiness()
	var/msg = "<span class='info'>*---------*\n<EM>Your current mood</EM>\n"
	for(var/i in events)
		var/datum/happiness_event/event = events[i]
		msg += event.description
	to_chat(src, msg)

/mob/living/carbon/proc/update_happiness()
	happiness = 0
	for(var/i in events)
		var/datum/happiness_event/event = events[i]
		happiness += event.happiness

	switch(happiness)
		if(-INFINITY to MOOD_LEVEL_SAD4)
			if(client && hud_used)
				hud_used.happiness.icon_state = "mood1"
		if(MOOD_LEVEL_SAD4 to MOOD_LEVEL_SAD3)
			if(client && hud_used)
				hud_used.happiness.icon_state = "mood2"
		if(MOOD_LEVEL_SAD3 to MOOD_LEVEL_SAD2)
			if(client && hud_used)
				hud_used.happiness.icon_state = "mood3"
		if(MOOD_LEVEL_SAD2 to MOOD_LEVEL_SAD1)
			if(client && hud_used)
				hud_used.happiness.icon_state = "mood4"
		if(MOOD_LEVEL_SAD1 to MOOD_LEVEL_HAPPY1)
			if(client && hud_used)
				hud_used.happiness.icon_state = "mood5"
		if(MOOD_LEVEL_HAPPY1 to MOOD_LEVEL_HAPPY2)
			if(client && hud_used)
				hud_used.happiness.icon_state = "mood6"
		if(MOOD_LEVEL_HAPPY2 to MOOD_LEVEL_HAPPY3)
			if(client && hud_used)
				hud_used.happiness.icon_state = "mood7"
		if(MOOD_LEVEL_HAPPY3 to MOOD_LEVEL_HAPPY4)
			if(client && hud_used)
				hud_used.happiness.icon_state = "mood8"
		if(MOOD_LEVEL_HAPPY4 to INFINITY)
			if(client && hud_used)
				hud_used.happiness.icon_state = "mood9"

/mob/living/carbon/proc/handle_happiness()
	if(has_mood)
		switch(happiness)
			if(-INFINITY to MOOD_LEVEL_SAD4)
				overlay_fullscreen("insanity", /obj/screen/fullscreen/insanity, 3)
			if(MOOD_LEVEL_SAD4 to MOOD_LEVEL_SAD3)
				overlay_fullscreen("insanity", /obj/screen/fullscreen/insanity, 2)
			if(MOOD_LEVEL_SAD3 to MOOD_LEVEL_SAD2)
				overlay_fullscreen("insanity", /obj/screen/fullscreen/insanity, 1)
			if(MOOD_LEVEL_SAD2 to MOOD_LEVEL_SAD1)
				clear_fullscreen("insanity")
			if(MOOD_LEVEL_SAD1 to MOOD_LEVEL_HAPPY1)
				clear_fullscreen("insanity")
			if(MOOD_LEVEL_HAPPY1 to MOOD_LEVEL_HAPPY2)
				clear_fullscreen("insanity")
			if(MOOD_LEVEL_HAPPY2 to MOOD_LEVEL_HAPPY3)
				clear_fullscreen("insanity")
			if(MOOD_LEVEL_HAPPY3 to MOOD_LEVEL_HAPPY4)
				clear_fullscreen("insanity")
			if(MOOD_LEVEL_HAPPY4 to INFINITY)
				clear_fullscreen("insanity")


/mob/living/carbon/proc/add_event(category, type, param) //Category will override any events in the same category, should be unique unless the event is based on the same thing like hunger.
	var/datum/happiness_event/the_event
	if(events[category])
		the_event = events[category]
		if(the_event.type != type)
			clear_event(category)
			return .()
		else
			return 0 //Don't have to update the event.
	else
		the_event = new type(src, param)

	events[category] = the_event
	update_happiness()

	if(the_event.timeout)
		addtimer(CALLBACK(src, .proc/clear_event, category), the_event.timeout)

/mob/living/carbon/proc/clear_event(category)
	var/datum/happiness_event/event = events[category]
	if(!event)
		return 0

	events -= category
	qdel(event)
	update_happiness()

/mob/living/carbon/proc/handle_hygiene()
	adjust_hygiene(-HYGIENE_FACTOR)
	switch(hygiene)
		if(HYGIENE_LEVEL_NORMAL to INFINITY)
			add_event("hygiene", /datum/happiness_event/hygiene/clean)
		if(HYGIENE_LEVEL_DIRTY to HYGIENE_LEVEL_NORMAL)
			clear_event("hygiene")
		if(0 to HYGIENE_LEVEL_DIRTY)
			add_event("hygiene", /datum/happiness_event/hygiene/smelly)

/mob/living/carbon/proc/adjust_hygiene(amount)
	hygiene = Clamp(hygiene+amount, 0, HYGIENE_LEVEL_CLEAN)

/mob/living/carbon/proc/set_hygiene(amount)
	hygiene	 = Clamp(amount, 0, HYGIENE_LEVEL_CLEAN)

/mob/living/carbon/proc/adjust_thirst(amount)
	thirst = Clamp(thirst+amount, 0, THIRST_LEVEL_MAX)

/mob/living/carbon/proc/set_thirst(amount)
	thirst = Clamp(amount, 0, THIRST_LEVEL_MAX)
