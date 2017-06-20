/area
	luminosity           = TRUE
	var/dynamic_lighting = DYNAMIC_LIGHTING_ENABLED

/area/proc/set_dynamic_lighting(var/new_dynamic_lighting = DYNAMIC_LIGHTING_ENABLED)
	for (var/turf/T in area_contents(src)) //If it was a dynamic lighting area, clear the turf overlays
		if (T.lighting_object)
			T.lighting_clear_overlay()

	if (!IS_DYNAMIC_LIGHTING(src)) //If it was a non dynamic lighting area, clear the fullbright
		cut_overlay(/obj/effect/fullbright)

	dynamic_lighting = new_dynamic_lighting

	if (IS_DYNAMIC_LIGHTING(src)) //If the new value is dynamic, build new turf overlays
		for (var/turf/T in area_contents(src))
			if (IS_DYNAMIC_LIGHTING(T))
				T.lighting_build_overlay()

	else
		add_overlay(/obj/effect/fullbright) //If the new value is non dynamic, give it a fullbright overlay

	return TRUE

/area/vv_edit_var(var_name, var_value)
	switch(var_name)
		if("dynamic_lighting")
			set_dynamic_lighting(var_value)
			return TRUE
	return ..()