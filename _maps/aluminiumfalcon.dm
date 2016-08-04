#if !defined(MAP_FILE)

		#define TITLESCREEN "title" //Add an image in misc/fullscreen.dmi, and set this define to the icon_state, to set a custom titlescreen for your map

		#define MINETYPE "lavaland"

        #include "map_files\AluminiumFalcon\AluminiumFalcon.dmm"
        #include "map_files\AluminiumFalcon\z2.dmm"

		#define MAP_PATH "map_files/AluminiumFalcon"
        #define MAP_FILE "AluminiumFalcon.dmm"
        #define MAP_NAME "Aluminium Falcon"

		#define MAP_TRANSITION_CONFIG DEFAULT_MAP_TRANSITION_CONFIG
		
		#define FTL_SHIP_DIR SOUTH
		#define FTL_SHIP_DWIDTH 29
		#define FTL_SHIP_DHEIGHT 8
		#define FTL_SHIP_WIDTH 58
		#define FTL_SHIP_HEIGHT 35
		// For mapping reference:
		// <-47,64>-<49,8>

#elif !defined(MAP_OVERRIDE)

	#warn a map has already been included, ignoring AluminiumFalcon.

#endif
