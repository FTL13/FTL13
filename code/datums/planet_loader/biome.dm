/datum/biome
	var/turf_type
	var/list/turfs = list()
	var/center_x
	var/center_y
	var/min_weight = 50
	var/max_weight = 300
	var/weight = 0
	var/list/cells = list()

/datum/biome/beach
	turf_type = /turf/open/floor/plating/asteroid/planet/sand
	max_weight = 100

/datum/biome/lake
	turf_type = /turf/open/floor/plating/asteroid/planet/water
	max_weight = 200

/datum/biome/plains
	turf_type = /turf/open/floor/plating/asteroid/planet/grass
	max_weight = 500

/datum/biome/snowy_plains
	turf_type = /turf/open/floor/plating/asteroid/planet/snow
	max_weight = 100

/datum/biome_cell
	var/center_x
	var/center_y
	var/datum/biome/biome

/datum/biome_cell/New()
	..()
	center_x = rand(1,world.maxx)
	center_y = rand(1,world.maxy)