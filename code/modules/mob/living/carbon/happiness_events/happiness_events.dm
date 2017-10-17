/datum/happiness_event
	var/description
	var/happiness = 0
	var/timeout = 0
	var/mob/living/carbon/owner

/datum/happiness_event/New(mob/living/carbon/C, param)
	owner = C
	add_effects(param)

/datum/happiness_event/Destroy()
	remove_effects()

/datum/happiness_event/proc/add_effects(param)
	return

/datum/happiness_event/proc/remove_effects()
	return

///For descriptions, use the span classes bold green, green, none, warning and boldwarning in order from great to horrible.
