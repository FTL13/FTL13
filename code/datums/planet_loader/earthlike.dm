/datum/planet_loader/earthlike
	var/list/biome_proportions = list()

/datum/planet_loader/earthlike/New()
	..()
	plant_color = HSVtoRGB(rgb(rand(0,255),rand(200,255),rand(200,255)))
	biome_proportions[/turf/open/floor/plating/asteroid/planet/sand] = rand(1,300)
	biome_proportions[/turf/open/floor/plating/asteroid/planet/water] = rand(1,100)
	biome_proportions[/turf/open/floor/plating/asteroid/planet/grass] = rand(1,500)
	biome_proportions[/turf/open/floor/plating/asteroid/planet/snow] = rand(1,200)

/datum/planet_loader/earthlike/add_more_shit(z_level, var/datum/planet/PL)
	var/list/available_turfs = list()
	var/biome_currturfs = list()
	var/biome_adjturfs = list()
	var/list/curr_biome_proportions = biome_proportions.Copy()
	for(var/turf/open/floor/plating/asteroid/planet/genturf/G in world) // Yes, I'm doing a "in world" loop. If you have a problem with that, you can piss off.
		if(G.z == z_level)
			available_turfs[G] = G
	for(var/biome in curr_biome_proportions)
		biome_adjturfs[biome] = list()
		biome_currturfs[biome] = list()
		for(var/i in 1 to 5)
			var/turf/T
			while(available_turfs[T])
				pick_n_take(available_turfs)
			biome_currturfs[biome][T] = T
			biome_adjturfs[biome] = list()
			for(var/cdir in cardinal)
				var/turf/T2 = get_step(T, cdir)
				if(T2 in available_turfs)
					biome_adjturfs[biome][T2] = T2
	
	while(curr_biome_proportions.len)
		var/biome = pickweight(curr_biome_proportions)
		var/turf/T = pick_n_take(biome_adjturfs[biome])
		var/list/this_biome_adjturfs = biome_adjturfs[biome]
		available_turfs -= T
		if(this_biome_adjturfs.len == 0)
			curr_biome_proportions -= biome
		biome_currturfs[biome][T] = T
		for(var/cdir in cardinal)
			var/turf/T2 = get_step(T, cdir)
			if(T2 in available_turfs)
				biome_adjturfs[biome][T] = T2
		CHECK_TICK
	
	for(var/biome in biome_currturfs)
		for(var/turf/T in biome_currturfs[biome])
			T.ChangeTurf(biome)
			CHECK_TICK