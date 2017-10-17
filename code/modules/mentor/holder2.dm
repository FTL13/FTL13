var/list/mentor_datums = list()

/datum/mentors
	var/client/owner = null
	var/following = null

/datum/mentors/New(ckey)
	if(!ckey)
		del(src)
		return
	mentor_datums[ckey] = src

/datum/mentors/proc/associate(client/C)
	if(istype(C))
		owner = C
		GLOB.mentors |= C
		owner.holder.rank = "Mentor"
		owner.holder.rank.rights = R_MENTOR
		owner.add_admin_verbs()

/datum/mentors/proc/disassociate()
	if(owner)
		GLOB.mentors -= owner
		owner.holder.rank = "Player"
		owner.remove_admin_verbs()
		owner = null

/client/proc/dementor()
	var/mentor = mentor_datums[ckey]
	mentor_datums -= ckey
	qdel(mentor)

	return TRUE

/proc/check_mentor()
	if(usr && usr.client)
		var/mentor = mentor_datums[usr.client.ckey]
		if(mentor || check_rights(R_ADMIN,0) || check_rights(R_MENTOR,0))
			return TRUE

	return FALSE

/proc/check_mentor_other(var/client/C)
	if(C)
		var/mentor = mentor_datums[C.ckey]
		if(C.holder && C.holder.rank)
			if(C.holder.rank.rights & R_ADMIN)
				return TRUE
		else if(mentor)
			return TRUE
	return FALSE
