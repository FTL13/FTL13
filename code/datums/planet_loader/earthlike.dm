/datum/planet_loader/earthlike
	var/list/biomes = list()
	var/list/cells = list()
	has_gravity = 1

/datum/planet_loader/earthlike/New()
	..()
	plant_color = HSVtoRGB(hsv(rand(0,1536),rand(220,255),rand(220,255)))
	for(var/I in 1 to 100)
		cells += new /datum/biome_cell
	var/list/unused_cells = cells.Copy()
	var/possible_biomes = typesof(/datum/biome) - /datum/biome

	for(var/i in 1 to rand(5,10))
		var/biometype = pick(possible_biomes)
		var/datum/biome/B = new biometype
		B.center_x = rand(1,world.maxx)
		B.center_y = rand(1,world.maxy)
		B.weight = rand(B.min_weight, B.max_weight)
		var/datum/biome_cell/cell = pick_n_take(unused_cells)
		B.cells += cell
		cell.biome = B
		biomes[B] = B.weight

	while(unused_cells.len)
		var/datum/biome/B = pickweight(biomes)
		var/datum/biome_cell/closest_cell
		var/closest_dist = 9876543210
		for(var/datum/biome_cell/C1 in B.cells)
			for(var/datum/biome_cell/C2 in unused_cells)
				var/dx = C2.center_x - C1.center_x
				var/dy = C2.center_y - C1.center_y
				var/dist = (dx*dx) + (dy*dy)
				if(dist < closest_dist)
					closest_cell = C2
					closest_dist = dist
		if(!closest_cell)
			break // SHITS FUCKED
		unused_cells -= closest_cell
		B.cells += closest_cell
		closest_cell.biome = B
/datum/planet_loader/earthlike/add_more_shit(z_level, var/datum/planet/PL)
	// Generate voronoi cells using manhattan distance

	for(var/datum/sub_turf_block/STB in split_block(locate(1, 1, z_level), locate(world.maxx, world.maxy, z_level)))
		for(var/turf/T in STB.return_list())
			if(!istype(T, /turf/open/floor/plating/asteroid/planet/genturf))
				continue // no
			var/datum/biome_cell/closest
			var/closest_dist = 99999
			for(var/datum/biome_cell/B in cells)
				var/dx = B.center_x-T.x
				var/dy = B.center_y-T.y
				var/dist = (dx*dx)+(dy*dy)
				if(dist < closest_dist)
					closest = B
					closest_dist = dist
			if(closest)
				var/datum/biome/B = closest.biome
				T.ChangeTurf(B.turf_type)
				B.turfs += T
				if(istype(T,/turf/open))
					if(B.flora_density && B.flora_types)
						if(prob(B.flora_density))
							var/obj/structure/flora = pick(B.flora_types)
							new flora(T)
					if(B.fauna_density && B.fauna_types)
						if(prob(B.fauna_density))
							var/fauna = pick(B.fauna_types)
							new fauna(T)
			CHECK_TICK
