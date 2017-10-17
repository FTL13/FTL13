/datum/happiness_event/drugs/high
	happiness = 6

/datum/happiness_event/drugs/high/add_effects(name)
	description = "<span class='greentext'>Woooow duudeeeeee...I'm tripping on this [drug_name]</span>\n"

/datum/happiness_event/drugs/smoked
	description = "<span class='green'>I have had a smoke recently.</span>\n"
	happiness = 2

/datum/happiness_event/drugs/overdose
	happiness = -8
	timeout = 3000

/datum/happiness_event/drugs/overdose/add_effects(name)
	description = "<span class='warning'>I think I took a bit too much of that [name]</span>\n"

/datum/happiness_event/drugs/withdrawal_light
	happiness = -2

/datum/happiness_event/drugs/withdrawal_light/add_effects(name)
	description = "<span class='warning'>I could use some [name]</span>\n"

/datum/happiness_event/drugs/withdrawal_medium
	happiness = -5

/datum/happiness_event/drugs/withdrawal_medium/add_effects(name)
	description = "<span class='warning'>I really need [name]</span>\n"

/datum/happiness_event/drugs/withdrawal_severe
	happiness = -7

/datum/happiness_event/drugs/withdrawal_severe/add_effects(name)
	description = "<span class='boldwarning'>Oh god I need some [name]</span>\n"

/datum/happiness_event/drugs/withdrawal_critical
	happiness = -15

/datum/happiness_event/drugs/withdrawal_critical/New(name)
	description = "<span class='boldwarning'>[_name]! [name]! [name]!</span>\n"
