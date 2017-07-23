/datum/ftl_event
	var/name = "event" //Name of event
	var/class //Type of event
	var/severity //unused



/datum/ftl_event/combat
	name = "Combat encounter" //Name of event
	class = COMBAT //Type of event
	var/faction = "pirates"
	var/ship_to_spawn

/datum/ftl_event/combat/New()
	ship_to_spawn= pick(SSship.faction2list(faction))
