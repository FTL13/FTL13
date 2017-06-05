
//Timing subsystem
//Don't run if there is an identical unique timer active
#define TIMER_UNIQUE		0x1
//For unique timers: Replace the old timer rather then not start this one
#define TIMER_OVERRIDE		0x2
//Timing should be based on how timing progresses on clients, not the sever.
//	tracking this is more expensive,
//	should only be used in conjuction with things that have to progress client side, such as animate() or sound()
#define TIMER_CLIENT_TIME	0x4
//Timer can be stopped using deltimer()
#define TIMER_STOPPABLE		0x8
//To be used with TIMER_UNIQUE
//prevents distinguishing identical timers with the wait variable
#define TIMER_NO_HASH_WAIT  0x10

#define TIMER_NO_INVOKE_WARNING 600 //number of byond ticks that are allowed to pass before the timer subsystem thinks it hung on something

//For servers that can't do with any additional lag, set this to none in flightpacks.dm in subsystem/processing.
#define FLIGHTSUIT_PROCESSING_NONE 0
#define FLIGHTSUIT_PROCESSING_FULL 1

#define INITIALIZATION_INSSATOMS 0	//New should not call Initialize
#define INITIALIZATION_INNEW_MAPLOAD 1	//New should call Initialize(TRUE)
#define INITIALIZATION_INNEW_REGULAR 2	//New should call Initialize(FALSE)

#define INITIALIZE_HINT_NORMAL 0    //Nothing happens
#define INITIALIZE_HINT_LATELOAD 1  //Call LateInitialize
#define INITIALIZE_HINT_QDEL 2  //Call qdel on the atom

//type and all subtypes should always call Initialize in New()
#define INITIALIZE_IMMEDIATE(X) ##X/New(loc, ...){\
    ..();\
    if(!initialized) {\
        args[1] = TRUE;\
        SSatoms.InitAtom(src, args);\
    }\
}

// Subsystem init_order, from highest priority to lowest priority
// Subsystems shutdown in the reverse of the order they initialize in
// The numbers just define the ordering, they are meaningless otherwise.

#define INIT_ORDER_DBCORE 130
#define INIT_ORDER_SERVER_MAINT 120
#define INIT_ORDER_JOBS 110
#define INIT_ORDER_EVENTS 100
#define INIT_ORDER_TICKER 90
#define INIT_ORDER_SHIPS 80
#define INIT_ORDER_STARMAP 70
#define INIT_ORDER_MAPPING 60
#define INIT_ORDER_ATOMS 50
#define INIT_ORDER_LANGUAGE 40
#define INIT_ORDER_MACHINES 30
#define INIT_ORDER_SHUTTLE 20
#define INIT_ORDER_TIMER 10
#define INIT_ORDER_DEFAULT 0
#define INIT_ORDER_AIR -10
#define INIT_ORDER_MINIMAP -20
#define INIT_ORDER_ASSETS -30
#define INIT_ORDER_ICON_SMOOTHING -40
#define INIT_ORDER_OVERLAY -50
#define INIT_ORDER_XKEYSCORE -60
#define INIT_ORDER_STICKY_BAN -70
#define INIT_ORDER_LIGHTING -80
#define INIT_ORDER_SQUEAK -90
#define INIT_ORDER_PERSISTENCE -100

// SS runlevels

#define RUNLEVEL_INIT 0
#define RUNLEVEL_LOBBY 1
#define RUNLEVEL_SETUP 2
#define RUNLEVEL_GAME 4
#define RUNLEVEL_POSTGAME 8

#define RUNLEVELS_DEFAULT (RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME)
