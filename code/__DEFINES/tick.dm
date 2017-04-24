#define TICK_LIMIT_RUNNING 85
#define TICK_LIMIT_TO_RUN 80
#define TICK_LIMIT_MC 84
#define TICK_LIMIT_MC_INIT_DEFAULT 98

#define TICK_CHECK ( world.tick_usage > CURRENT_TICKLIMIT ? stoplag() : 0 )
#define CHECK_TICK if (world.tick_usage > CURRENT_TICKLIMIT)  stoplag()
