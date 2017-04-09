#if !defined(MAP_FILE)

		#define TITLESCREEN "title" //Add an image in misc/fullscreen.dmi, and set this define to the icon_state, to set a custom titlescreen for your map

		#define MINETYPE "lavaland"

        #include "map_files\Aetherwhisp\Aetherwhisp.dmm"
        #include "map_files\Aetherwhisp\z2.dmm"

		#define MAP_PATH "map_files/Aetherwhisp"
        #define MAP_FILE "Aetherwhisp.dmm"
        #define MAP_NAME "NSV Aetherwhisp"

		#define MAP_TRANSITION_CONFIG DEFAULT_MAP_TRANSITION_CONFIG

		#define FTL_SHIP_DIR SOUTH
		#define FTL_SHIP_DWIDTH 60
		#define FTL_SHIP_DHEIGHT 6
		#define FTL_SHIP_WIDTH 109
		#define FTL_SHIP_HEIGHT 71

#elif !defined(MAP_OVERRIDE)

	#warn a map has already been included, ignoring Aetherwhisp.

#endif
