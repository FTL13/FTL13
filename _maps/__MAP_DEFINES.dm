/*
The /tg/ codebase currently requires you to have 11 z-levels of the same size dimensions.
z-level order is important, the order you put them in inside the map config.dm will determine what z level number they are assigned ingame.
Names of z-level do not matter, but order does greatly, for instances such as checking alive status of revheads on z1

current as of 2016/6/2
z1 = station
z2 = centcomm
z5 = mining
Everything else = randomized space
Last space-z level = empty
*/

#define CROSSLINKED 2
#define SELFLOOPING 1
#define UNAFFECTED 0

// Attributes (In text for the convenience of those using VV)
#define BLOCK_TELEPORT "Blocks Teleport"
// Impedes with the casting of some spells
#define IMPEDES_MAGIC "Impedes Magic"
// A level the station exists on
#define STATION_LEVEL "Station Level"
// A level affected by Code Red announcements, cargo telepads, or similar
#define STATION_CONTACT "Station Contact"
// A level dedicated to admin use
#define ADMIN_LEVEL "Admin Level"
// A level that can be navigated to through space
#define REACHABLE "Reachable"
// For away missions - used by some consoles
#define AWAY_LEVEL "Away"
// Allows weather
#define HAS_WEATHER "Weather"
// Enhances telecomms signals
#define BOOSTS_SIGNAL "Boosts signals"
// Currently used for determining mining score
#define ORE_LEVEL "Mining"
// Levels the AI can control bots on
#define AI_OK "AI Allowed"


#define MAIN_STATION "Main Station"
#define CENTCOMM "CentComm"
#define EMPTY_AREA_1 "Empty Area 1"
#define EMPTY_AREA_2 "Empty Area 2"
#define MINING "Mining Asteroid"
#define EMPTY_AREA_3 "Empty Area 3"
#define EMPTY_AREA_4 "Empty Area 4"
#define EMPTY_AREA_5 "Empty Area 5"
#define EMPTY_AREA_6 "Empty Area 6"
#define EMPTY_AREA_7 "Empty Area 7"
#define EMPTY_AREA_8 "Empty Area 8"
#define AWAY_MISSION "Away Mission"
#define AWAY_MISSION_LIST list(AWAY_MISSION = SELFLOOPING)

#define DECLARE_LEVEL(NAME,LINKS,TRAITS) list("name" = NAME, "linkage" = LINKS, "attributes" = TRAITS)


#define DEFAULT_MAP_TRANSITION_CONFIG list(\
DECLARE_LEVEL(MAIN_STATION,CROSSLINKED,list(STATION_LEVEL,STATION_CONTACT,REACHABLE,AI_OK)),\
DECLARE_LEVEL(CENTCOMM,SELFLOOPING,list(ADMIN_LEVEL, BLOCK_TELEPORT, IMPEDES_MAGIC)))

// define a default if it does not get set later and overridden
#define MAP_TRANSITION_CONFIG DEFAULT_MAP_TRANSITION_CONFIG