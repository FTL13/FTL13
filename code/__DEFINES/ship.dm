#define SHIP_CONTROL 1
#define SHIP_WEAPONS 2
#define SHIP_SHIELDS 4
#define SHIP_REPAIR 8
#define SHIP_ENGINES 16

#define STARTING_FACTION_CASH 250000
#define STARTING_FACTION_WARSHIPS 40
#define STARTING_FACTION_MERCHANTS 10
#define STARTING_FACTION_FLEETS 2

#define FLEET_FORMATION_CHANCE 20 //chance for a fleet to form randomly to gank some offending ship
#define PRICE_CAP 500 //maximum price of resources
#define SHIP_BUILD_PRICE 1000 //price to build a ship on top of resources
#define FACTION_BUILD_DELAY 900 //delay in between building ships

#define BOARDING_MISSION_UNSTARTED 0
#define BOARDING_MISSION_STARTED 1
#define BOARDING_MISSION_SUCCESS 2

#define FTL_NOT_LOADING 0
#define FTL_LOADING 1
#define FTL_DONE_LOADING 2
#define FTL_LOADING_PLANET 3

#define PLANET_LOADING 1
#define PLANET_LOADED 2
#define PLANET_IS_A_GAS_GIANT 3
