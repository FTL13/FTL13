/datum/ftl_event_action
	var/buttonname = "Button" //Title of action

	var/title = "example results" //Name that appears on the results UI
	var/flavortext = "flavor text about cool thing that is happening"  //Description that appears on the results UI
	var/effects = "you get 5 beans"
	var/datum/ftl_event/our_event //owning event

/datum/ftl_event_action/proc/activate() //Called when you press the button.
	return
