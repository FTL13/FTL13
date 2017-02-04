/datum/star_resource
	var/name = "Resource"
	var/cname = "resource"

	var/scale_price = 100000
	var/scale_weight = 500

/datum/star_resource/iron
	name = "iron ore"
	cname = "iron"

	scale_price = 120000
	scale_weight = 2000

/datum/star_resource/hyperlite
	name = "hyperlite crystals"
	cname = "hyper"

	scale_price = 40000
	scale_weight = 300

/datum/star_resource/silicon
	name = "silicate ore"
	cname = "silicon"

	scale_price = 60000
	scale_weight = 1000

/datum/subsystem/starmap/proc/cname2resource(var/cname)
	for(var/datum/star_resource/resource in star_resources)
		if(resource.cname == cname)
			return resource

