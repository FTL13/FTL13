#if !defined(MAP_FILE)

		#define TITLESCREEN "title" //Add an image in misc/fullscreen.dmi, and set this define to the icon_state, to set a custom titlescreen for your map

		#define MINETYPE "lavaland"

        #include "map_files\Trailblazer\Trailblazer.dmm"
        #include "map_files\Trailblazer\z2.dmm"

		#define MAP_PATH "map_files/Trailblazer"
        #define MAP_FILE "Trailblazer.dmm"
        #define MAP_NAME "Trailblazer"

		#define MAP_TRANSITION_CONFIG DEFAULT_MAP_TRANSITION_CONFIG
		
		#define FTL_SHIP_DIR SOUTH
		#define FTL_SHIP_DWIDTH 99
		#define FTL_SHIP_DHEIGHT 8
		#define FTL_SHIP_WIDTH 153
		#define FTL_SHIP_HEIGHT 59

#elif !defined(MAP_OVERRIDE)

	#warn a map has already been included, ignoring SpaceSHIP.

#endif
