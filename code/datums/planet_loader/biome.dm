/datum/biome
	var/turf_type
	var/list/turfs = list()
	var/center_x
	var/center_y
	var/min_weight = 50
	var/max_weight = 300
	var/weight = 0
	var/list/cells = list()
	var/flora_density = 0
	var/fauna_density = 0
	var/list/flora_types = list(/obj/structure/flora/grass/jungle)
	var/list/fauna_types = list(
	/mob/living/carbon/monkey{faction = list("wildlife")} = 50,
	)

/datum/biome/desert
	turf_type = /turf/open/floor/plating/asteroid/planet/sand
	flora_types = list(/obj/structure/flora/ausbushes, /obj/structure/flora/ausbushes/palebush, /obj/structure/flora/ausbushes/stalkybush)
	max_weight = 50
	flora_density = 15

/datum/biome/lake
	turf_type = /turf/open/floor/plating/asteroid/planet/water
	flora_types = list(/obj/structure/flora/grass/jungle)
	fauna_types = list(/mob/living/simple_animal/hostile/carp)
	max_weight = 50
	flora_density = 0
	fauna_density = 0.2

/datum/biome/plains
	turf_type = /turf/open/floor/plating/asteroid/planet/grass
	flora_types = list(/obj/structure/flora/grass/jungle,/obj/structure/flora/grass/jungle/b, /obj/structure/flora/tree/jungle, /obj/structure/flora/rock/jungle, /obj/structure/flora/junglebush, /obj/structure/flora/junglebush/b, /obj/structure/flora/junglebush/c, /obj/structure/flora/junglebush/large, /obj/structure/flora/rock/pile/largejungle)
	max_weight = 75
	flora_density = 20

/datum/biome/jungle
	turf_type = /turf/open/floor/plating/asteroid/planet/grass
	flora_types = list(/obj/structure/flora/grass/jungle,/obj/structure/flora/grass/jungle/b, /obj/structure/flora/tree/jungle, /obj/structure/flora/rock/jungle, /obj/structure/flora/junglebush, /obj/structure/flora/junglebush/b, /obj/structure/flora/junglebush/c, /obj/structure/flora/junglebush/large, /obj/structure/flora/rock/pile/largejungle)
	max_weight = 400
	flora_density = 75
	fauna_density = 0.5

/datum/biome/snowy_plains
	turf_type = /turf/open/floor/plating/asteroid/planet/snow
	flora_types = list(/obj/structure/flora/tree/pine,/obj/structure/flora/tree/dead, /obj/structure/flora/grass, /obj/structure/flora/grass/brown, /obj/structure/flora/grass/green, /obj/structure/flora/grass/both, /obj/structure/flora/bush)
	max_weight = 50
	flora_density = 20

/datum/biome/mountain
	turf_type = /turf/closed/mineral/random/planet
	max_weight = 250
	flora_density = 0

/datum/biome_cell
	var/center_x
	var/center_y
	var/datum/biome/biome

/datum/biome_cell/New()
	..()
	center_x = rand(1,world.maxx)
	center_y = rand(1,world.maxy)
