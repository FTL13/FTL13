/obj/docking_port/mobile/ftl
	name = "FTL Ship"
	id = "ftl"
	var/area_base_type = /area/shuttle/ftl

/obj/docking_port/mobile/ftl/is_valid_area_for_shuttle(area/tileArea, area/thisArea)
	return istype(tileArea, area_base_type)
