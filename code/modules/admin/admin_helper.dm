// Returns the number of Admins that are online that can delay round end for open tickets
/proc/total_admins_active()
	var/admins_online = 0
	for(var/client/X in GLOB.admins)
		var/invalid = 0
		if(!check_rights_for(X, R_TICKET))
			invalid = 1
		if(X.is_afk(600))
			invalid = 1
		if(!invalid)
			admins_online++
	return admins_online