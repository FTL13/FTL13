/datum/happiness_event
	var/description
	var/happiness = 0
	var/timeout = 0

///For descriptions, use the span classes bold green, green, none, warning and boldwarning in order from great to horrible.

//thirst
/datum/happiness_event/thirst/filled
		description = "<span class='green'><span class='green'>I've had enough to drink for a while!</span>\n"
		happiness = 4

/datum/happiness_event/thirst/watered
		description = "<span class='green'>I have recently had something to drink.</span>\n"
		happiness = 2

/datum/happiness_event/thirst/thirsty
		description = "<span class='warning'>I'm getting a bit thirsty.</span>\n"
		happiness = -7

/datum/happiness_event/thirst/dehydrated
		description = "<span class='boldwarning'>I need water!</span>\n"
		happiness = -14



//nutrition
/datum/happiness_event/nutrition/fat
		description = "<span class='warning'><B>I'm so fat..</B></span>\n" //muh fatshaming
		happiness = -4

/datum/happiness_event/nutrition/wellfed
		description = "<span class='green'><span class='green'>My belly feels round and full.</span>\n"
		happiness = 4

/datum/happiness_event/nutrition/fed
		description = "<span class='green'>I have recently had some food.</span>\n"
		happiness = 2

/datum/happiness_event/nutrition/hungry
		description = "<span class='warning'>I'm getting a bit hungry.</span>\n"
		happiness = -6

/datum/happiness_event/nutrition/starving
		description = "<span class='boldwarning'>I'm starving!</span>\n"
		happiness = -12


//Hygiene
/datum/happiness_event/hygiene/clean
		description = "<span class='greentext'><span class='greentext'>I feel so clean!\n"
		happiness = 2

/datum/happiness_event/hygiene/smelly
		description = "<span class='warning'>I smell like shit.\n"
		happiness = -5

//Disgust
/datum/happiness_event/disgust/gross
		description = "<span class='warning'>That was gross.</span>\n"
		happiness = -2

/datum/happiness_event/disgust/verygross
		description = "<span class='warning'>I think I'm going to puke...</span>\n"
		happiness = -4

/datum/happiness_event/disgust/disgusted
		description = "<span class='boldwarning'>Oh god that's disgusting...</span>\n"
		happiness = -6



//Generic events
/datum/happiness_event/favorite_food
	description = "<span class='green'>I really liked eating that.</span>\n"
	happiness = 3
	timeout = 2400

/datum/happiness_event/nice_shower
	description = "<span class='green'>I had a nice shower.</span>\n"
	happiness = 1
	timeout = 1800

/datum/happiness_event/handcuffed
	description = "<span class='warning'>I guess my antics finally caught up with me..</span>\n"
	happiness = -1


//Unused so far but I want to remember them to use them later
/datum/happiness_event/disturbing
	description = "I recently saw something disturbing</span>\n"
	happiness = -2

/datum/happiness_event/clown
	description = "I recently saw a funny clown!</span>\n"
	happiness = 1

/datum/happiness_event/cloned_corpse
	description = "I recently saw my own corpse...</span>\n"
	happiness = -6

/datum/happiness_event/surgery
	description = "HE'S CUTTING ME OPEN!!</span>\n"
	happiness = -8
