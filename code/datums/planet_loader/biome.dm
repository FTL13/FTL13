/datum/biome
	var/turf_type
	var/list/turfs = list()
	var/center_x
	var/center_y
	var/min_weight = 50
	var/max_weight = 300
	var/weight = 0
	var/list/cells = list()
	var/plant_density = 0
	var/list/plant_types = /obj/structure/flora/grass/jungle

/datum/biome/beach
turf_type = /turf/open/floor/plating/asteroid/planet/sand
plant_types = /obj/structure/flora/grass/jungle
max_weight = 50
plant_density = 10

/datum/biome/lake
turf_type = /turf/open/floor/plating/asteroid/planet/water
plant_types = /obj/structure/flora/grass/jungle
max_weight = 150
plant_density = 0

/datum/biome/plains
turf_type = /turf/open/floor/plating/asteroid/planet/grass
plant_types = /obj/structure/flora/grass/jungle
max_weight = 100
plant_density = 40

/datum/biome/jungle
		turf_type = /turf/open/floor/plating/asteroid/planet/grass
		plant_types = /obj/structure/flora/grass/jungle
		max_weight = 400
		plant_density = 70

/datum/biome/snowy_plains
	turf_type = /turf/open/floor/plating/asteroid/planet/snow
	plant_types = /obj/structure/flora/grass/jungle
	max_weight = 50
	plant_density = 10

/datum/biome/mountain
	turf_type = /turf/closed/mineral/random
	plant_types = /obj/structure/flora/grass/jungle
	max_weight = 250
	plant_density = 0

/datum/biome_cell
	var/center_x
	var/center_y
	var/datum/biome/biome

/datum/biome_cell/New()
	..()
	center_x = rand(1,world.maxx)
	center_y = rand(1,world.maxy)
