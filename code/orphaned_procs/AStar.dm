/*
A Star pathfinding algorithm
Returns a list of tiles forming a path from A to B, taking dense objects as well as walls, and the orientation of
windows along the route into account.
Use:
your_list = AStar(start location, end location, moving atom, distance proc, max nodes, maximum node depth, minimum distance to target, adjacent proc, atom id, turfs to exclude, check only simulated)

Optional extras to add on (in order):
Distance proc : the distance used in every A* calculation (length of path and heuristic)
MaxNodes: The maximum number of nodes the returned path can be (0 = infinite)
Maxnodedepth: The maximum number of nodes to search (default: 30, 0 = infinite)
Mintargetdist: Minimum distance to the target before path returns, could be used to get
near a target, but not right to it - for an AI mob with a gun, for example.
Adjacent proc : returns the turfs to consider around the actually processed node
Simulated only : whether to consider unsimulated turfs or not (used by some Adjacent proc)

Also added 'exclude' turf to avoid travelling over; defaults to null

Actual Adjacent procs :

	/turf/proc/reachableAdjacentTurfs : returns reachable turfs in cardinal directions (uses simulated_only)

	/turf/proc/reachableAdjacentAtmosTurfs : returns turfs in cardinal directions reachable via atmos

*/

//////////////////////
//PathNode object
//////////////////////

//A* nodes variables
/PathNode
	var/PathNode/prevNode //link to the parent PathNode
	var/f		//A* Node weight (f = g + h)
	var/g		//A* movement cost variable
	var/h		//A* heuristic variable
	var/nt		//count the number of Nodes traversed

/PathNode/New(p,pg,ph,pnt)
	prevNode = p
	g = pg
	h = ph
	f = g + h
	nt = pnt

/PathNode/proc/calc_f()
	f = g + h

/PathNode/Destroy()
	prevNode = null
	return ..()

/PathNode/Turf
	var/turf/source //turf associated with the PathNode

/PathNode/Turf/New(s,p,pg,ph,pnt)
	..(p,pg,ph,pnt)
	source = s
	source.PNode = src

/PathNode/Turf/Destroy()
	source.PNode = null
	source = null
	return ..()

/PathNode/Star
	var/datum/star_system/source //star system associated with the PathNode

/PathNode/Star/New(s,p,pg,ph,pnt)
	..(p,pg,ph,pnt)
	source = s
	source.PNodes += src

/PathNode/Star/Destroy()
	source.PNodes -= src
	source = null
	return ..()

//////////////////////
//A* procs
//////////////////////

//the weighting function, used in the A* algorithm
/proc/PathWeightCompare(PathNode/a, PathNode/b)
	return a.f - b.f

//reversed so that the Heap is a MinHeap rather than a MaxHeap
/proc/HeapPathWeightCompare(PathNode/a, PathNode/b)
	return b.f - a.f

//wrapper that returns an empty list if A* failed to find a path
/proc/get_path_to(caller, end, dist, maxnodes, maxnodedepth = 30, mintargetdist, adjacent = /turf/proc/reachableAdjacentTurfs, id=null, turf/exclude=null, simulated_only = 1)
	var/list/path = AStar(caller, end, dist, maxnodes, maxnodedepth, mintargetdist, adjacent,id, exclude, simulated_only)
	if(!path)
		path = list()
	return path

//the actual algorithm
/proc/AStar(caller, end, dist, maxnodes, maxnodedepth = 30, mintargetdist, adjacent = /turf/proc/reachableAdjacentTurfs, id=null, turf/exclude=null, simulated_only = 1)

	//sanitation
	var/start = get_turf(caller)
	if(!start)
		return 0

	if(maxnodes)
		//if start turf is farther than maxnodes from end turf, no need to do anything
		if(call(start, dist)(end) > maxnodes)
			return 0
		maxnodedepth = maxnodes //no need to consider path longer than maxnodes

	var/Heap/open = new /Heap(/proc/HeapPathWeightCompare) //the open list
	var/list/closed = new() //the closed list
	var/list/path = null //the returned path, if any
	var/PathNode/Turf/cur //current processed turf

	//initialization
	open.Insert(new /PathNode/Turf(start,null,0,call(start,dist)(end),0))

	//then run the main loop
	while(!open.IsEmpty() && !path)
		//get the lower f node on the open list
		cur = open.Pop() //get the lower f turf in the open list
		closed.Add(cur) //and tell we've processed it

		//if we only want to get near the target, check if we're close enough
		var/closeenough
		if(mintargetdist)
			closeenough = call(cur.source,dist)(end) <= mintargetdist

		//if too many steps, abandon that path
		if(maxnodedepth && (cur.nt > maxnodedepth))
			continue

		//found the target turf (or close enough), let's create the path to it
		if(cur.source == end || closeenough)
			path = new()
			path.Add(cur.source)

			while(cur.prevNode)
				cur = cur.prevNode
				path.Add(cur.source)

			break

		//get adjacents turfs using the adjacent proc, checking for access with id
		var/list/L = call(cur.source,adjacent)(caller,id, simulated_only)
		for(var/turf/T in L)
			if(T == exclude || T.PNode && (T.PNode in closed))
				continue

			var/newg = cur.g + call(cur.source,dist)(T)
			if(!T.PNode) //is not already in open list, so add it
				open.Insert(new /PathNode/Turf(T,cur,newg,call(T,dist)(end),cur.nt+1))
			else //is already in open list, check if it's a better way from the current turf
				if(newg < T.PNode.g)
					T.PNode.prevNode = cur
					T.PNode.g = newg
					T.PNode.calc_f()
					T.PNode.nt = cur.nt + 1
					open.ReSort(T.PNode)//reorder the changed element in the list
		CHECK_TICK


	//cleaning after us
	for(var/PathNode/PN in open.L)
		qdel(PN)
	for(var/PathNode/PN in closed)
		qdel(PN)

	//reverse the path to get it from start to finish
	if(path)
		for(var/i in 1 to path.len/2)
			path.Swap(i, path.len - i + 1)

	return path

/proc/get_path_to_system(caller, end, ftl_range, maxnodes, maxnodedepth = 30, mintargetdist)
	var/list/path = AStar_abstract(caller, end, ftl_range, maxnodes, maxnodedepth, mintargetdist)
	if(!path)
		path = list()
	else
		path -= caller
	return path

//since someone took a perfectly good algorithm and snowflaked it for turfs, I have to mess with it
/proc/AStar_abstract(caller, end, ftl_range, maxnodes, maxnodedepth = 30, dist = /datum/star_system/proc/dist, mintargetdist = 0, adjacent = /datum/star_system/proc/adjacent_systems)

	//sanitation
	var/start = caller
	if(!start)
		return 0

	if(maxnodes)
		//if start turf is farther than maxnodes from end turf, no need to do anything
		if(call(start, dist)(end) > maxnodes)
			return 0
		maxnodedepth = maxnodes //no need to consider path longer than maxnodes

	var/Heap/open = new /Heap(/proc/HeapPathWeightCompare) //the open list
	var/list/closed = new() //the closed list
	var/list/path = null //the returned path, if any
	var/PathNode/Star/cur //current processed turf

	//initialization
	open.Insert(new /PathNode/Star(start,null,0,call(start,dist)(end),0))

	//then run the main loop
	while(!open.IsEmpty() && !path)
		//get the lower f node on the open list
		cur = open.Pop() //get the lower f turf in the open list
		closed.Add(cur) //and tell we've processed it

		//if we only want to get near the target, check if we're close enough
		var/closeenough
		if(mintargetdist)
			closeenough = call(cur.source,dist)(end) <= mintargetdist

		//if too many steps, abandon that path
		if(maxnodedepth && (cur.nt > maxnodedepth))
			continue

		//found the target turf (or close enough), let's create the path to it
		if(cur.source == end || closeenough)
			path = new()
			path.Add(cur.source)

			while(cur.prevNode)
				cur = cur.prevNode
				path.Add(cur.source)

			break

		//get adjacents turfs using the adjacent proc, checking for access with id
		var/list/L = call(cur.source,adjacent)(ftl_range)
		for(var/datum/star_system/T in L)
			if(T == exclude)
				continue

			if(T.PNodes.len)
				var/skip = FALSE
				for(var/PathNode/PN in T.PNodes)
					if(PN in closed) //is in closed list, so skip them
						skip = TRUE
						break
					if(PN in open.L) //is already in open list, check if it's a better way from the current turf
						skip = TRUE
						var/newg = cur.g + call(cur.source,dist)(T)
						if(newg < PN.g)
							PN.prevNode = cur
							PN.g = newg
							PN.calc_f()
							PN.nt = cur.nt + 1
							open.ReSort(PN)//reorder the changed element in the list
				if(skip)
					continue
			else //is not already in open list, so add it
				var/newg = cur.g + call(cur.source,dist)(T)
				open.Insert(new /PathNode/Star(T, cur, newg, call(T, dist)(end), cur.nt + 1))

		CHECK_TICK


	//cleaning after us
	for(var/PathNode/PN in open.L)
		qdel(PN)
	for(var/PathNode/PN in closed)
		qdel(PN)

	//reverse the path to get it from start to finish
	if(path)
		for(var/i in 1 to path.len/2)
			path.Swap(i, path.len - i + 1)

	return path

//Returns adjacent turfs in cardinal directions that are reachable
//simulated_only controls whether only simulated turfs are considered or not
/turf/proc/reachableAdjacentTurfs(caller, ID, simulated_only)
	var/list/L = new()
	var/turf/T

	for(var/dir in cardinal)
		T = get_step(src,dir)
		if(simulated_only && !istype(T))
			continue
		if(!T.density && !LinkBlockedWithAccess(T,caller, ID))
			L.Add(T)
	return L

//Returns adjacent turfs in cardinal directions that are reachable via atmos
/turf/proc/reachableAdjacentAtmosTurfs()
	return atmos_adjacent_turfs

/turf/proc/LinkBlockedWithAccess(turf/T, caller, ID)
	var/adir = get_dir(src, T)
	var/rdir = get_dir(T, src)

	for(var/obj/structure/window/W in src)
		if(!W.CanAStarPass(ID, adir))
			return 1
	for(var/obj/O in T)
		if(!O.CanAStarPass(ID, rdir, caller))
			return 1

	return 0

/datum/star_system/proc/adjacent_systems(var/range)
	var/list/adjacent_systems = list()
	for(var/datum/star_system/system in SSstarmap.star_systems)
		if(src.dist(system) < range && src != system)
			adjacent_systems += system

	return adjacent_systems
