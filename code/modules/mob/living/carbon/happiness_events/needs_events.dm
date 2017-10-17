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
	description = "<span class='greentext'>I feel so clean!</span>\n"
	happiness = 2

/datum/happiness_event/hygiene/clean/add_effects(param)
	owner.update_smell()

/datum/happiness_event/hygiene/smelly
	description = "<span class='warning'>I should really take a shower.</span>\n"
	happiness = -4

/datum/happiness_event/hygiene/smelly/add_effects(param)
	owner.update_smell()

/datum/happiness_event/hygiene/smelly/remove_effects()
	owner.update_smell()

//Disgust
/datum/happiness_event/disgust/gross
	description = "<span class='warning'>I saw something gross.</span>\n"
	happiness = -2

/datum/happiness_event/disgust/verygross
	description = "<span class='warning'>I think I'm going to puke...</span>\n"
	happiness = -5

/datum/happiness_event/disgust/disgusted
	description = "<span class='boldwarning'>Oh god that's disgusting...</span>\n"
	happiness = -8

//Generic needs events
/datum/happiness_event/favorite_food
	description = "<span class='green'>I really enjoyed eating that.</span>\n"
	happiness = 3
	timeout = 2400

/datum/happiness_event/nice_shower
	description = "<span class='green'>I have recently had a nice shower.</span>\n"
	happiness = 2
	timeout = 1800
