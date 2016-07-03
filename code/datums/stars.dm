/datum/star_system
	var/name = ""
	var/x = 0
	var/y = 0

/datum/star_system/proc/generate()
	name = generate_star_name()
	x = rand(0, 1000) / 10
	y = rand(0, 1000) / 10