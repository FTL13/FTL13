/**********************Mine areas**************************/

/area/mine
	icon_state = "mining"
	has_gravity = TRUE

/area/mine/explored
	name = "Mine"
	icon_state = "explored"
	music = null
	always_unpowered = TRUE
	requires_power = TRUE
	poweralm = FALSE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	outdoors = TRUE
	ambientsounds = list('sound/ambience/ambimine.ogg', 'sound/ambience/ambicave.ogg', 'sound/ambience/ambiruin.ogg',\
	 'sound/ambience/ambiruin2.ogg',  'sound/ambience/ambiruin3.ogg',  'sound/ambience/ambiruin4.ogg',\
	  'sound/ambience/ambiruin5.ogg',  'sound/ambience/ambiruin6.ogg',  'sound/ambience/ambiruin7.ogg',\
		'sound/ambience/ambidanger.ogg', 'sound/ambience/ambidanger2.ogg')
	flags = NONE

/area/mine/unexplored
	name = "Mine"
	icon_state = "unexplored"
	music = null
	always_unpowered = TRUE
	requires_power = TRUE
	poweralm = FALSE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	outdoors = TRUE
	ambientsounds = list('sound/ambience/ambimine.ogg', 'sound/ambience/ambicave.ogg', 'sound/ambience/ambiruin.ogg',\
	 'sound/ambience/ambiruin2.ogg',  'sound/ambience/ambiruin3.ogg',  'sound/ambience/ambiruin4.ogg',\
	  'sound/ambience/ambiruin5.ogg',  'sound/ambience/ambiruin6.ogg',  'sound/ambience/ambiruin7.ogg',\
		'sound/ambience/ambidanger.ogg', 'sound/ambience/ambidanger2.ogg')
	flags = NONE

/area/mine/lobby
	name = "Mining Station"

/area/mine/storage
	name = "Mining Station Storage"

/area/mine/production
	name = "Mining Station Starboard Wing"
	icon_state = "mining_production"

/area/mine/abandoned
	name = "Abandoned Mining Station"

/area/mine/living_quarters
	name = "Mining Station Port Wing"
	icon_state = "mining_living"

/area/mine/eva
	name = "Mining Station EVA"
	icon_state = "mining_eva"

/area/mine/maintenance
	name = "Mining Station Communications"

/area/mine/cafeteria
	name = "Mining Station Cafeteria"

/area/mine/hydroponics
	name = "Mining Station Hydroponics"

/area/mine/sleeper
	name = "Mining Station Emergency Sleeper"

/area/mine/north_outpost
	name = "North Mining Outpost"

/area/mine/west_outpost
	name = "West Mining Outpost"

/area/mine/laborcamp
	name = "Labor Camp"

/area/mine/laborcamp/security
	name = "Labor Camp Security"
	icon_state = "security"




/**********************Lavaland Areas**************************/

/area/lavaland
	icon_state = "mining"
	has_gravity = TRUE
	flags = NONE

/area/lavaland/surface
	name = "Lavaland"
	icon_state = "explored"
	music = null
	always_unpowered = TRUE
	poweralm = FALSE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	requires_power = TRUE
	ambientsounds = list('sound/ambience/ambilava.ogg')

/area/lavaland/underground
	name = "Lavaland Caves"
	icon_state = "unexplored"
	music = null
	always_unpowered = TRUE
	requires_power = TRUE
	poweralm = FALSE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	ambientsounds = list('sound/ambience/ambilava.ogg')


/area/lavaland/surface/outdoors
	name = "Lavaland Wastes"
	outdoors = TRUE

/area/lavaland/surface/outdoors/unexplored //monsters and ruins spawn here
	icon_state = "unexplored"

/area/lavaland/surface/outdoors/unexplored/danger //megafauna will also spawn here
	icon_state = "danger"

/area/lavaland/surface/outdoors/explored
	name = "Lavaland Labor Camp"
