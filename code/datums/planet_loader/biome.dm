/datum/biome
	var/turf_type
	var/list/currturfs
	var/list/adjturfs
	var/min_weight = 50
	var/max_weight = 300

/datum/biome/beach
	turf_type = /turf/open/floor/plating/asteroid/planet/sand

/datum/biome/lake
	turf_type = /turf/open/floor/plating/asteroid/planet/water
	max_weight = 100

/datum/biome/plains
	turf_type = /turf/open/floor/plating/asteroid/planet/grass
	max_weight = 500

/datum/biome/snowy_plains
	turf_type = /turf/open/floor/plating/asteroid/planet/snow
	max_weight = 200