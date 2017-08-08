/datum/ftl_event_action/engage
	buttonname = "Attack them"

	title = "Ships engaged"
	flavortext = "The ships activate their weapon and engage you in combat"

/datum/ftl_event_action/engage/activate() //Called when you press the button.
	our_event.spawn_ships()

/datum/ftl_event_action/avoid
	buttonname = "Attempt to avoid them"

/datum/ftl_event_action/avoid/activate() //Called when you press the button.
	if(prob(50))
		title = "Avoiding succeeded"
		flavortext = "NIGGA WE DID IT"
	else
		title = "Avoiding failed"
		flavortext = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA WE GOT SPOTTED"
		our_event.spawn_ships()


/datum/ftl_event_action/bribe
	buttonname = "Attempt to bribe them"
	var/bribe_cost = 1000

/datum/ftl_event_action/bribe/activate() //Called when you press the button.
	if(prob(75 && SSshuttle.points > 1000))
		title = "Avoiding succeeded"
		flavortext = "NIGGA WE DID IT"
		SSshuttle.points -= bribe_cost
	else
		title = "Avoiding failed"
		flavortext = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA WE GOT SPOTTED"
		our_event.spawn_ships()
