/datum/happiness_event/handcuffed
	description = "<span class='warning'>I guess my antics have finally caught up with me..</span>\n"
	happiness = -1

/datum/happiness_event/broken_vow //Used for when mimes break their vow of silence
  description = "<span class='boldwarning'>I have brought shame upon my name, and betrayed my fellow mimes by breaking our sacred vow...</span>\n"
  happiness = -5

/datum/happiness_event/on_fire
	description = "<span class='boldwarning'>I'M ON FIRE!!!</span>\n"
	happiness = -8

/datum/happiness_event/suffocation
	description = "<span class='boldwarning'>CAN'T... BREATHE...</span>\n"
	happiness = -6

/datum/happiness_event/burnt_thumb
	description = "<span class='warning'>I shouldn't play with lighters...</span>\n"
	happiness = -1
	timeout = 1200

/datum/happiness_event/cold
	description = "<span class='warning'>It's way too cold in here.</span>\n"
	happiness = -2

/datum/happiness_event/hot
	description = "<span class='warning'>It's getting hot in here.</span>\n"
	happiness = -2

/datum/happiness_event/creampie
	description = "<span class='warning'>I've been creamed. Tastes like pie flavor.</span>\n"
	happiness = -2
	timeout = 1800

/datum/happiness_event/slipped
	description = "<span class='warning'>I slipped. I should be more careful next time...</span>\n"
	happiness = -3
	timeout = 1800

/datum/happiness_event/eye_stab
	description = "<span class='boldwarning'>I used to be an adventurer like you, until I took a screwdriver to the eye.</span>\n"
	happiness = -6
	timeout = 2400

/datum/happiness_event/delam //SM delamination
	description = "<span class='boldwarning'>Those God damn engineers can't do anything right...</span>\n"
	happiness = -8
	timeout = 6000

/datum/happiness_event/shameful_suicide //suicide_acts that return SHAME, like sord
  description = "<span class='boldwarning'>I can't even end it all!</span>\n"
  happiness = -10
  timeout = 600

/datum/happiness_event/dismembered
  description = "<span class='boldwarning'>AHH! I WAS USING THAT LIMB!</span>\n"
  happiness = -8
  timeout = 6000

//These are unused so far but I want to remember them to use them later
/datum/happiness_event/cloned_corpse
	description = "<span class='boldwarning'>I recently saw my own corpse...</span>\n"
	happiness = -6

/datum/happiness_event/surgery
	description = "<span class='boldwarning'>HE'S CUTTING ME OPEN!!</span>\n"
	happiness = -8
