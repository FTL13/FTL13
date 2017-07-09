 /**
  * tgui state: admin_state
  *
  * Checks that the user is part of staff, end-of-story.
 **/

GLOBAL_DATUM_INIT(admin_state, /datum/ui_state/admin_state, new)

/datum/ui_state/admin_state/can_use_topic(src_object, mob/user)
	if(check_rights_for(user.client, R_MENTOR))
		return UI_INTERACTIVE
	return UI_CLOSE
