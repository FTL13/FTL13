/datum/space_chunk
	var/x
	var/y
	var/width
	var/height
	var/zpos
	// Whether this chunk has been dedicated for use or not
	var/occupied = FALSE
	// Whether this chunk contains children that are dedicated for use or not
	var/is_empty = TRUE
	var/list/children = list()
	var/datum/space_chunk/parent = null

/datum/space_chunk/New(new_x, new_y, z, w, h)
	x = new_x
	y = new_y
	zpos = z
	width = w
	height = h

/datum/space_chunk/Destroy()
	set_occupied(FALSE)
	if(parent)
		parent.children -= src
	for(var/datum/space_chunk/child in children)
		qdel(child)
	children.Cut()
	parent = null
	return ..()

/datum/space_chunk/proc/can_fit_space(w, h)
	if(w > width || h > height)
		return FALSE
	if(occupied)
		return FALSE
	if(is_empty)
		return TRUE
	for(var/datum/space_chunk/C in children)
		if(C.can_fit_space(w, h))
			return TRUE
	return FALSE

// This algorithm recursively goes down the tree and picks the most efficient
// chunk, which is the chunk that is the closest to the desired size
/datum/space_chunk/proc/get_optimal_chunk(w, h)
	if(w > width || h > height)
		return null
	if(occupied)
		return null
	if(is_empty)
		return src
	var/datum/space_chunk/optimal_chunk
	var/optimal_chunk_optimalness = 99999
	for(var/datum/space_chunk/C in children)
		var/datum/space_chunk/C2 = C.get_optimal_chunk(w, h)
		if(!C2)
			continue
		var/optimalness = C2.width+C2.height-w-h
		if(optimalness < optimal_chunk_optimalness)
			optimal_chunk_optimalness = optimalness
			optimal_chunk = C2
	return optimal_chunk

/datum/space_chunk/proc/set_occupied(new_occupied)
	if(new_occupied)
		occupied = TRUE
		var/datum/space_chunk/C = parent
		while(C)
			C.is_empty = FALSE
			C = C.parent
	else
		occupied = FALSE
		var/datum/space_chunk/C = parent
		while(C)
			var/is_children_empty = TRUE
			for(var/datum/space_chunk/C2 in C.children)
				if(!C2.is_empty || C2.occupied)
					is_children_empty = FALSE
			if(!is_children_empty)
				break
			C.is_empty = TRUE
			C = C.parent

/datum/space_chunk/proc/check_sanity()
	var/i_am_sane = 1
	i_am_sane |= (x > 0)
	i_am_sane |= (y > 0)
	i_am_sane |= (x <= world.maxx)
	i_am_sane |= (y <= world.maxy)
	return i_am_sane

/datum/space_chunk/proc/return_turfs()
	return
