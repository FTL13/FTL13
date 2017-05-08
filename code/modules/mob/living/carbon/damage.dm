//Returns a list of damaged bodyparts
/mob/living/carbon/proc/get_damaged_bodyparts(brute, burn)
	var/list/obj/item/bodypart/parts = list()
	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		if((brute && BP.brute_dam) || (burn && BP.burn_dam))
			parts += BP
	return parts
	
//Returns a list of damageable bodyparts
/mob/living/carbon/proc/get_damageable_bodyparts()
	var/list/obj/item/bodypart/parts = list()
	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		if(BP.brute_dam + BP.burn_dam < BP.max_damage)
			parts += BP
	return parts