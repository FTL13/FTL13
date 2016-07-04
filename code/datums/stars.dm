/datum/star_system
	var/name = ""
	var/x = 0
	var/y = 0

/datum/star_system/proc/generate()
	name = generate_star_name()
	var/valid_coords = 0
	while(!valid_coords)
		generate_coords()
		valid_coords = 1
		for(var/datum/star_system/other in SSstarmap.star_systems)
			if(other == src)
				continue
			if(dist(other) <= 2)
				valid_coords = 0
				break

/datum/star_system/proc/generate_coords()
	x = rand(0, 1000) / 10
	y = rand(0, 1000) / 10

/datum/star_system/proc/dist(datum/star_system/other)
	var/dx = other.x - x
	var/dy = other.y - y
	return sqrt((dx * dx) + (dy * dy))

/datum/star_system/proc/lerp_x(datum/star_system/other, t)
	return x + (t * (other.x - x))

/datum/star_system/proc/lerp_y(datum/star_system/other, t)
	return y + (t * (other.y - y))