//Event types//

#define COMBAT 1
#define CHOICE 2
#define QUEST 4
#define PASSIVE 8
#define RUIN 16

//Event rarity//
#define COMMON_EVENT 100
#define UNCOMMON_EVENT 50
#define RARE_EVENT 25
#define EPIC_EVENT 5
#define LEGENDARY_EVENT 1

//Factions//
#define FTL_PLAYERSHIP "ship" //Player's ship, doesn't own any systems
#define FTL_NANOTRASEN "nanotrasen"
#define FTL_SYNDICATE "syndicate"
#define FTL_SOLGOV "solgov"
#define FTL_PIRATE "pirate" //doesn't own any systems
#define FTL_NEUTRAL "unaligned" //These are used for things that fit within any group

//Generic event state
#define FTL_EVENT_STATE_INITIATE 1

//Combat event state
#define FTL_EVENT_STATE_STARTCOUNTDOWN 2
#define FTL_EVENT_STATE_ENGAGECOMBAT 3
#define FTL_EVENT_STATE_AVOIDCOMBAT 4
#define FTL_EVENT_STATE_BRIBECOMBAT 5
