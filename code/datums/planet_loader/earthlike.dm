/datum/planet_loader/earthlike
	var/list/biome_proportions = list()

/datum/planet_loader/earthlike/New()
	..()
	plant_color = HSVtoRGB(hsv(rand(0,1536),rand(220,255),rand(220,255)))
	var/possible_biomes = typesof(/datum/biome) - /datum/biome
	for(var/i in 1 to rand(5,20))
		var/biometype = pick(possible_biomes)
		var/datum/biome/B = new biometype
		biome_proportions[B] = rand(B.min_weight, B.max_weight)

/datum/planet_loader/earthlike/add_more_shit(z_level, var/datum/planet/PL)
	var/list/available_turfs = list()
	var/list/curr_biome_proportions = biome_proportions.Copy()
	for(var/turf/open/floor/plating/asteroid/planet/genturf/G in world) // Yes, I'm doing a "in world" loop. If you have a problem with that, you can piss off.
		if(G.z == z_level)
			available_turfs[G] = G
	for(var/datum/biome/biome in curr_biome_proportions)
		biome.adjturfs = list()
		biome.currturfs = list()
		var/turf/T = pick_n_take(available_turfs)
		biome.currturfs[T] = 1
		for(var/cdir in cardinal)
			var/turf/T2 = get_step(T, cdir)
			if(T2 in available_turfs)
				biome.adjturfs[T2] = 1
	
	while(curr_biome_proportions.len)
		var/datum/biome/biome = pickweight(curr_biome_proportions)
		var/turf/T
		while(!(available_turfs[T]))
			T = pick_n_take(biome.adjturfs)
			if(biome.adjturfs.len == 0)
				break
		available_turfs -= T
		if(biome.adjturfs.len == 0)
			curr_biome_proportions -= biome
		biome.currturfs[T] = 1
		for(var/cdir in cardinal)
			var/turf/T2 = get_step(T, cdir)
			if(T2 in available_turfs)
				biome.adjturfs[T2] = 1
		CHECK_TICK
	
	for(var/datum/biome/biome in biome_proportions)
		for(var/turf/T in biome.currturfs)
			T.ChangeTurf(biome.turf_type)
			CHECK_TICK