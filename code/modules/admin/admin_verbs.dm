//admin verb groups - They can overlap if you so wish. Only one of each verb will exist in the verbs list regardless
var/list/admin_verbs_default = list(
	/client/proc/toggleadminhelpsound,	/*toggles whether we hear a sound when adminhelps/PMs are used*/
	/client/proc/toggleannouncelogin, /*toggles if an admin's login is announced during a round*/
	/client/proc/deadmin,				/*destroys our own admin datum so we can play as a regular player*/
	/client/proc/cmd_admin_say,			/*admin-only ooc chat*/
	/client/proc/hide_verbs,			/*hides all our adminverbs*/
	/client/proc/hide_most_verbs,		/*hides all our hideable adminverbs*/
	/client/proc/debug_variables,		/*allows us to -see- the variables of any instance in the game. +VAREDIT needed to modify*/
	/client/proc/admin_memo,			/*admin memo system. show/delete/write. +SERVER needed to delete admin memos of others*/
	/client/proc/deadchat,				/*toggles deadchat on/off*/
	/client/proc/dsay,					/*talk in deadchat using our ckey/fakekey*/
	/client/proc/toggleprayers,			/*toggles prayers on/off*/
	/client/verb/toggleprayersounds,	/*Toggles prayer sounds (HALLELUJAH!)*/
	/client/proc/toggle_hear_radio,		/*toggles whether we hear the radio*/
	/client/proc/investigate_show,		/*various admintools for investigation. Such as a singulo grief-log*/
	/client/proc/secrets,
	/client/proc/reload_admins,
	/client/proc/adminwhotoggle,
	/client/proc/adminwho,
	/client/proc/reestablish_db_connection,/*reattempt a connection to the database*/
	/client/proc/cmd_admin_pm_context,	/*right-click adminPM interface*/
	/client/proc/cmd_admin_pm_panel,		/*admin-pm list*/
	/client/proc/view_tickets,
	/client/proc/toggleticketlistenall,
	/client/proc/stop_sounds,
	/client/proc/check_economy,
	/client/proc/check_ships
	)
var/list/admin_verbs_admin = list(
	/client/proc/player_panel_new,		/*shows an interface for all players, with links to various panels*/
	/client/proc/invisimin,				/*allows our mob to go invisible/visible*/
//	/datum/admins/proc/show_traitor_panel,	/*interface which shows a mob's mind*/ -Removed due to rare practical use. Moved to debug verbs ~Errorage
	/datum/admins/proc/show_player_panel,	/*shows an interface for individual players, with various links (links require additional flags*/
	/client/proc/game_panel,			/*game panel, allows to change game-mode etc*/
	/client/proc/check_ai_laws,			/*shows AI and borg laws*/
	/datum/admins/proc/toggleooc,		/*toggles ooc on/off for everyone*/
	/datum/admins/proc/toggleoocdead,	/*toggles ooc on/off for everyone who is dead*/
	/datum/admins/proc/toggleenter,		/*toggles whether people can join the current game*/
	/datum/admins/proc/toggleguests,	/*toggles whether guests can join the current game*/
	/datum/admins/proc/announce,		/*priority announce something to all clients.*/
	/datum/admins/proc/set_admin_notice,/*announcement all clients see when joining the server.*/
	/client/proc/admin_ghost,			/*allows us to ghost/reenter body at will*/
	/client/proc/toggle_view_range,		/*changes how far we can see*/
	/datum/admins/proc/view_txt_log,	/*shows the server log (diary) for today*/
	/datum/admins/proc/view_atk_log,	/*shows the server combat-log, doesn't do anything presently*/
	/client/proc/cmd_admin_subtle_message,	/*send an message to somebody as a 'voice in their head'*/
	/client/proc/cmd_admin_delete,		/*delete an instance/object/mob/etc*/
	/client/proc/cmd_admin_check_contents,	/*displays the contents of an instance*/
	/client/proc/check_antagonists,		/*shows all antags*/
	/datum/admins/proc/access_news_network,	/*allows access of newscasters*/
	/client/proc/giveruntimelog,		/*allows us to give access to runtime logs to somebody*/
	/client/proc/getruntimelog,			/*allows us to access runtime logs to somebody*/
	/client/proc/getserverlog,			/*allows us to fetch server logs (diary) for other days*/
	/client/proc/jumptocoord,			/*we ghost and jump to a coordinate*/
	/client/proc/Getmob,				/*teleports a mob to our location*/
	/client/proc/Getkey,				/*teleports a mob with a certain ckey to our location*/
//	/client/proc/sendmob,				/*sends a mob somewhere*/ -Removed due to it needing two sorting procs to work, which were executed every time an admin right-clicked. ~Errorage
	/client/proc/jumptoarea,
	/client/proc/jumptokey,				/*allows us to jump to the location of a mob with a certain ckey*/
	/client/proc/jumptomob,				/*allows us to jump to a specific mob*/
	/client/proc/jumptoturf,			/*allows us to jump to a specific turf*/
	/client/proc/admin_call_shuttle,	/*allows us to call the emergency shuttle*/
	/client/proc/admin_cancel_shuttle,	/*allows us to cancel the emergency shuttle, sending it back to centcom*/
	/client/proc/cmd_admin_direct_narrate,	/*send text directly to a player with no padding. Useful for narratives and fluff-text*/
	/client/proc/cmd_admin_world_narrate,	/*sends text to all players with no padding*/
	/client/proc/cmd_admin_local_narrate,	/*sends text to all mobs within view of atom*/
	/client/proc/cmd_admin_create_centcom_report,
	/client/proc/cmd_change_command_name,
	/client/proc/toggle_antag_hud, 	/*toggle display of the admin antag hud*/
	/client/proc/toggle_AI_interact, /*toggle admin ability to interact with machines as an AI*/
	/client/proc/customiseSNPC, /* Customise any interactive crewmembers in the world */
	/client/proc/resetSNPC, /* Resets any interactive crewmembers in the world */
	/client/proc/toggleSNPC, /* Toggles an npc's processing mode */
	/client/proc/open_shuttle_manipulator, /* Opens shuttle manipulator UI */
	/datum/admins/proc/toggle_ticket_counter_visibility,	/* toggles all players being able to see tickets remaining */
	/client/proc/toggle_afreeze /* Toggles admin-freeze on someone. Useful for admin-freezing really fast */
	)
var/list/admin_verbs_ban = list(
	/client/proc/unban_panel,
	/client/proc/DB_ban_panel,
	/client/proc/stickybanpanel
	)
var/list/admin_verbs_sounds = list(
	/client/proc/play_local_sound,
	/client/proc/play_sound,
	/client/proc/set_round_end_sound,
	)
var/list/admin_verbs_fun = list(
	/client/proc/cmd_admin_dress,
	/client/proc/cmd_admin_gib_self,
	/client/proc/drop_bomb,
	/client/proc/cinematic,
	/client/proc/one_click_antag,
	/client/proc/send_space_ninja,
	/client/proc/cmd_admin_add_freeform_ai_law,
	/client/proc/cmd_admin_add_random_ai_law,
	/client/proc/object_say,
	/client/proc/toggle_random_events,
	/client/proc/set_ooc,
	/client/proc/reset_ooc,
	/client/proc/forceEvent,
	/client/proc/bluespace_artillery,
	/client/proc/admin_change_sec_level,
	/client/proc/toggle_nuke,
	/client/proc/mass_zombie_infection,
	/client/proc/mass_zombie_cure,
	/client/proc/polymorph_all,
	/client/proc/show_tip,
	/client/proc/create_ship,
	/client/proc/create_fleet,
	/client/proc/create_boarding,
	/client/proc/create_wingmen
	)
var/list/admin_verbs_spawn = list(
	/datum/admins/proc/spawn_atom,		/*allows us to spawn instances*/
	/client/proc/respawn_character
	)
var/list/admin_verbs_server = list(
	/datum/admins/proc/startnow,
	/datum/admins/proc/restart,
	/datum/admins/proc/end_round,
	/datum/admins/proc/delay,
	/datum/admins/proc/toggleaban,
	/client/proc/toggle_log_hrefs,
	/client/proc/everyone_random,
	/datum/admins/proc/toggleAI,
	/client/proc/cmd_admin_delete,		/*delete an instance/object/mob/etc*/
	/client/proc/cmd_debug_del_all,
	/client/proc/toggle_random_events,
#if SERVERTOOLS
	/client/proc/forcerandomrotate,
	/client/proc/adminchangemap,
#endif
	/client/proc/panicbunker

	)
var/list/admin_verbs_debug = list(
	/client/proc/restart_controller,
	/client/proc/cmd_admin_list_open_jobs,
	/client/proc/Debug2,
	/client/proc/cmd_debug_make_powernets,
	/client/proc/cmd_debug_mob_lists,
	/client/proc/cmd_admin_delete,
	/client/proc/cmd_debug_del_all,
	/client/proc/restart_controller,
	/client/proc/enable_debug_verbs,
	/client/proc/callproc,
	/client/proc/callproc_datum,
	/client/proc/SDQL2_query,
	/client/proc/test_movable_UI,
	/client/proc/test_snap_UI,
	/client/proc/debugNatureMapGenerator,
	/client/proc/check_bomb_impacts,
	/proc/machine_upgrade,
	/client/proc/populate_world,
	/client/proc/cmd_display_del_log,
	/client/proc/reset_latejoin_spawns,
	/client/proc/create_outfits,
	/client/proc/debug_huds,
	/client/proc/map_template_load,
	/client/proc/map_template_upload,
	/client/proc/jump_to_ruin,
	/client/proc/view_runtimes
	)
var/list/admin_verbs_possess = list(
	/proc/possess,
	/proc/release
	)
var/list/admin_verbs_permissions = list(
	/client/proc/edit_admin_permissions,
	/client/proc/create_poll
	)
var/list/admin_verbs_rejuv = list(
	/client/proc/respawn_character
	)

//verbs which can be hidden - needs work
var/list/admin_verbs_hideable = list(
	/client/proc/set_ooc,
	/client/proc/reset_ooc,
	/client/proc/deadmin,
	/client/proc/deadchat,
	/client/proc/toggleprayers,
	/client/proc/toggle_hear_radio,
	/datum/admins/proc/show_traitor_panel,
	/datum/admins/proc/toggleenter,
	/datum/admins/proc/toggleguests,
	/datum/admins/proc/announce,
	/datum/admins/proc/set_admin_notice,
	/client/proc/admin_ghost,
	/client/proc/toggle_view_range,
	/datum/admins/proc/view_txt_log,
	/datum/admins/proc/view_atk_log,
	/client/proc/cmd_admin_subtle_message,
	/client/proc/cmd_admin_check_contents,
	/datum/admins/proc/access_news_network,
	/client/proc/admin_call_shuttle,
	/client/proc/admin_cancel_shuttle,
	/client/proc/cmd_admin_direct_narrate,
	/client/proc/cmd_admin_world_narrate,
	/client/proc/cmd_admin_local_narrate,
	/client/proc/play_local_sound,
	/client/proc/play_sound,
	/client/proc/set_round_end_sound,
	/client/proc/cmd_admin_dress,
	/client/proc/cmd_admin_gib_self,
	/client/proc/drop_bomb,
	/client/proc/cinematic,
	/client/proc/send_space_ninja,
	/client/proc/cmd_admin_add_freeform_ai_law,
	/client/proc/cmd_admin_add_random_ai_law,
	/client/proc/cmd_admin_create_centcom_report,
	/client/proc/cmd_change_command_name,
	/client/proc/object_say,
	/client/proc/toggle_random_events,
	/client/proc/cmd_admin_add_random_ai_law,
	/datum/admins/proc/startnow,
	/datum/admins/proc/restart,
	/datum/admins/proc/delay,
	/datum/admins/proc/toggleaban,
	/client/proc/toggle_log_hrefs,
	/client/proc/everyone_random,
	/datum/admins/proc/toggleAI,
	/client/proc/restart_controller,
	/client/proc/cmd_admin_list_open_jobs,
	/client/proc/callproc,
	/client/proc/callproc_datum,
	/client/proc/Debug2,
	/client/proc/reload_admins,
	/client/proc/cmd_debug_make_powernets,
	/client/proc/startSinglo,
	/client/proc/cmd_debug_mob_lists,
	/client/proc/cmd_debug_del_all,
	/client/proc/enable_debug_verbs,
	/proc/possess,
	/proc/release,
	/client/proc/reload_admins,
	/client/proc/panicbunker,
	/client/proc/admin_change_sec_level,
	/client/proc/toggle_nuke,
	/client/proc/cmd_display_del_log,
	/client/proc/toggle_antag_hud,
	/client/proc/debug_huds,
	/client/proc/customiseSNPC,
	/client/proc/resetSNPC,
	/client/proc/toggleSNPC
	)

/client/proc/add_admin_verbs()
	if(holder)
		control_freak = CONTROL_FREAK_SKIN | CONTROL_FREAK_MACROS

		var/rights = holder.rank.rights
		verbs += admin_verbs_default
		if(rights & R_BUILDMODE)
			verbs += /client/proc/togglebuildmodeself
		if(rights & R_ADMIN)
			verbs += admin_verbs_admin
		if(rights & R_BAN)
			verbs += admin_verbs_ban
		if(rights & R_FUN)
			verbs += admin_verbs_fun
		if(rights & R_SERVER)
			verbs += admin_verbs_server
		if(rights & R_DEBUG)
			verbs += admin_verbs_debug
		if(rights & R_POSSESS)
			verbs += admin_verbs_possess
		if(rights & R_PERMISSIONS)
			verbs += admin_verbs_permissions
		if(rights & R_STEALTH)
			verbs += /client/proc/stealth
		if(rights & R_REJUVINATE)
			verbs += admin_verbs_rejuv
		if(rights & R_SOUNDS)
			verbs += admin_verbs_sounds
		if(rights & R_SPAWN)
			verbs += admin_verbs_spawn

		for(var/path in holder.rank.adds)
			verbs += path
		for(var/path in holder.rank.subs)
			verbs -= path

/client/proc/remove_admin_verbs()
	verbs.Remove(
		admin_verbs_default,
		/client/proc/togglebuildmodeself,
		admin_verbs_admin,
		admin_verbs_ban,
		admin_verbs_fun,
		admin_verbs_server,
		admin_verbs_debug,
		admin_verbs_possess,
		admin_verbs_permissions,
		/client/proc/stealth,
		admin_verbs_rejuv,
		admin_verbs_sounds,
		admin_verbs_spawn,
		/*Debug verbs added by "show debug verbs"*/
		/client/proc/Cell,
		/client/proc/do_not_use_these,
		/client/proc/camera_view,
		/client/proc/sec_camera_report,
		/client/proc/intercom_view,
		/client/proc/air_status,
		/client/proc/atmosscan,
		/client/proc/powerdebug,
		/client/proc/count_objects_on_z_level,
		/client/proc/count_objects_all,
		/client/proc/cmd_assume_direct_control,
		/client/proc/startSinglo,
		/client/proc/set_fps,
		/client/proc/cmd_admin_grantfullaccess,
		/client/proc/cmd_admin_areatest,
		/client/proc/readmin
		)
	if(holder)
		verbs.Remove(holder.rank.adds)

/client/proc/hide_most_verbs()//Allows you to keep some functionality while hiding some verbs
	set name = "Adminverbs - Hide Most"
	set category = "Admin"

	verbs.Remove(/client/proc/hide_most_verbs, admin_verbs_hideable)
	verbs += /client/proc/show_verbs

	to_chat(src, "<span class='interface'>Most of your adminverbs have been hidden.</span>")
	feedback_add_details("admin_verb","HMV") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/hide_verbs()
	set name = "Adminverbs - Hide All"
	set category = "Admin"

	remove_admin_verbs()
	verbs += /client/proc/show_verbs

	to_chat(src, "<span class='interface'>Almost all of your adminverbs have been hidden.</span>")
	feedback_add_details("admin_verb","TAVVH") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/show_verbs()
	set name = "Adminverbs - Show"
	set category = "Admin"

	verbs -= /client/proc/show_verbs
	add_admin_verbs()

	to_chat(src, "<span class='interface'>All of your adminverbs are now visible.</span>")
	feedback_add_details("admin_verb","TAVVS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!




/client/proc/admin_ghost()
	set category = "Admin"
	set name = "Aghost"
	if(!holder)
		return
	if(istype(mob,/mob/dead/observer))
		//re-enter
		var/mob/dead/observer/ghost = mob
		if(!ghost.mind || !ghost.mind.current) //won't do anything if there is no body
			return
		if(!ghost.can_reenter_corpse)
			log_admin("[key_name(usr)] re-entered corpse")
			message_admins("[key_name_admin(usr)] re-entered corpse")
		ghost.can_reenter_corpse = 1 //force re-entering even when otherwise not possible
		ghost.reenter_corpse()
		feedback_add_details("admin_verb","P") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else if(istype(mob,/mob/new_player))
		to_chat(src, "<font color='red'>Error: Aghost: Can't admin-ghost whilst in the lobby. Join or Observe first.</font>")
	else
		//ghostize
		log_admin("[key_name(usr)] admin ghosted.")
		message_admins("[key_name_admin(usr)] admin ghosted.")
		var/mob/body = mob
		body.ghostize(1)
		if(body && !body.key)
			body.key = "@[key]"	//Haaaaaaaack. But the people have spoken. If it breaks; blame adminbus
		feedback_add_details("admin_verb","O") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/proc/invisimin()
	set name = "Invisimin"
	set category = "Admin"
	set desc = "Toggles ghost-like invisibility (Don't abuse this)"
	if(holder && mob)
		if(mob.invisibility == INVISIBILITY_OBSERVER)
			mob.invisibility = initial(mob.invisibility)
			to_chat(mob, "<span class='boldannounce'>Invisimin off. Invisibility reset.</span>")
		else
			mob.invisibility = INVISIBILITY_OBSERVER
			to_chat(mob, "<span class='adminnotice'><b>Invisimin on. You are now as invisible as a ghost.</b></span>")

/client/proc/player_panel_new()
	set name = "Player Panel"
	set category = "Admin"
	if(holder)
		holder.player_panel_new()
	feedback_add_details("admin_verb","PPN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/check_antagonists()
	set name = "Check Antagonists"
	set category = "Admin"
	if(holder)
		holder.check_antagonists()
		log_admin("[key_name(usr)] checked antagonists.")	//for tsar~
		if(!isobserver(usr))
			message_admins("[key_name_admin(usr)] checked antagonists.")
	feedback_add_details("admin_verb","CHA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/unban_panel()
	set name = "Unban Panel"
	set category = "Admin"
	if(holder)
		if(config.ban_legacy_system)
			holder.unbanpanel()
		else
			holder.DB_ban_panel()
	feedback_add_details("admin_verb","UBP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/game_panel()
	set name = "Game Panel"
	set category = "Admin"
	if(holder)
		holder.Game()
	feedback_add_details("admin_verb","GP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/secrets()
	set name = "Secrets"
	set category = "Admin"
	if (holder)
		holder.Secrets()
	feedback_add_details("admin_verb","S") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return


/client/proc/findStealthKey(txt)
	if(txt)
		for(var/P in stealthminID)
			if(stealthminID[P] == txt)
				return P
	txt = stealthminID[ckey]
	return txt

/client/proc/createStealthKey()
	var/num = (rand(0,1000))
	var/i = 0
	while(i == 0)
		i = 1
		for(var/P in stealthminID)
			if(num == stealthminID[P])
				num++
				i = 0
	stealthminID["[ckey]"] = "@[num2text(num)]"

/client/proc/stealth()
	set category = "Admin"
	set name = "Stealth Mode"
	if(holder)
		if(holder.fakekey)
			holder.fakekey = null
			if(isobserver(mob))
				mob.invisibility = initial(mob.invisibility)
				mob.alpha = initial(mob.alpha)
				mob.name = initial(mob.name)
				mob.mouse_opacity = initial(mob.mouse_opacity)
		else
			var/new_key = ckeyEx(input("Enter your desired display name.", "Fake Key", key) as text|null)
			if(!new_key)
				return
			if(length(new_key) >= 26)
				new_key = copytext(new_key, 1, 26)
			holder.fakekey = new_key
			createStealthKey()
			if(isobserver(mob))
				mob.invisibility = INVISIBILITY_ABSTRACT //JUST IN CASE
				mob.alpha = 0 //JUUUUST IN CASE
				mob.name = " "
				mob.mouse_opacity = 0
		log_admin("[key_name(usr)] has turned stealth mode [holder.fakekey ? "ON" : "OFF"]")
		message_admins("[key_name_admin(usr)] has turned stealth mode [holder.fakekey ? "ON" : "OFF"]")
	feedback_add_details("admin_verb","SM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/drop_bomb()
	set category = "Special Verbs"
	set name = "Drop Bomb"
	set desc = "Cause an explosion of varying strength at your location."

	var/list/choices = list("Small Bomb", "Medium Bomb", "Big Bomb", "Custom Bomb")
	var/choice = input("What size explosion would you like to produce?") in choices
	var/turf/epicenter = mob.loc
	switch(choice)
		if(null)
			return 0
		if("Small Bomb")
			explosion(epicenter, 1, 2, 3, 3)
		if("Medium Bomb")
			explosion(epicenter, 2, 3, 4, 4)
		if("Big Bomb")
			explosion(epicenter, 3, 5, 7, 5)
		if("Custom Bomb")
			var/devastation_range = input("Devastation range (in tiles):") as null|num
			if(devastation_range == null)
				return
			var/heavy_impact_range = input("Heavy impact range (in tiles):") as null|num
			if(heavy_impact_range == null)
				return
			var/light_impact_range = input("Light impact range (in tiles):") as null|num
			if(light_impact_range == null)
				return
			var/flash_range = input("Flash range (in tiles):") as null|num
			if(flash_range == null)
				return
			epicenter = mob.loc //We need to reupdate as they may have moved again
			explosion(epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range)
	message_admins("<span class='adminnotice'>[ckey] creating an admin explosion at [epicenter.loc].</span>")
	feedback_add_details("admin_verb","DB") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/give_spell(mob/T in mob_list)
	set category = "Fun"
	set name = "Give Spell"
	set desc = "Gives a spell to a mob."

	var/list/spell_list = list()
	var/type_length = length("/obj/effect/proc_holder/spell") + 2
	for(var/A in spells)
		spell_list[copytext("[A]", type_length)] = A
	var/obj/effect/proc_holder/spell/S = input("Choose the spell to give to that guy", "ABRAKADABRA") as null|anything in spell_list
	if(!S)
		return
	S = spell_list[S]
	feedback_add_details("admin_verb","GS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(usr)] gave [key_name(T)] the spell [S].")
	message_admins("<span class='adminnotice'>[key_name_admin(usr)] gave [key_name(T)] the spell [S].</span>")
	if(T.mind)
		T.mind.AddSpell(new S)
	else
		T.AddSpell(new S)
		message_admins("<span class='danger'>Spells given to mindless mobs will not be transferred in mindswap or cloning!</span>")


/client/proc/give_disease(mob/T in mob_list)
	set category = "Fun"
	set name = "Give Disease"
	set desc = "Gives a Disease to a mob."
	var/datum/disease/D = input("Choose the disease to give to that guy", "ACHOO") as null|anything in diseases
	if(!D) return
	T.ForceContractDisease(new D)
	feedback_add_details("admin_verb","GD") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(usr)] gave [key_name(T)] the disease [D].")
	message_admins("<span class='adminnotice'>[key_name_admin(usr)] gave [key_name(T)] the disease [D].</span>")

/client/proc/object_say(obj/O in world)
	set category = "Special Verbs"
	set name = "OSay"
	set desc = "Makes an object say something."
	var/message = input(usr, "What do you want the message to be?", "Make Sound") as text | null
	if(!message)
		return
	var/templanguages = O.languages_spoken
	O.languages_spoken |= ALL
	O.say(message)
	O.languages_spoken = templanguages
	log_admin("[key_name(usr)] made [O] at [O.x], [O.y], [O.z] say \"[message]\"")
	message_admins("<span class='adminnotice'>[key_name_admin(usr)] made [O] at [O.x], [O.y], [O.z]. say \"[message]\"</span>")
	feedback_add_details("admin_verb","OS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/client/proc/togglebuildmodeself()
	set name = "Toggle Build Mode Self"
	set category = "Special Verbs"
	if(src.mob)
		togglebuildmode(src.mob)
	feedback_add_details("admin_verb","TBMS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggle_log_hrefs()
	set name = "Toggle href logging"
	set category = "Server"
	if(!holder)
		return
	if(config)
		if(config.log_hrefs)
			config.log_hrefs = 0
			to_chat(src, "<b>Stopped logging hrefs</b>")
		else
			config.log_hrefs = 1
			to_chat(src, "<b>Started logging hrefs</b>")

/client/proc/check_ai_laws()
	set name = "Check AI Laws"
	set category = "Admin"
	if(holder)
		src.holder.output_ai_laws()

/client/proc/deadmin()
	set name = "Deadmin"
	set category = "Admin"
	set desc = "Shed your admin powers."

	if(!holder)
		return

	holder.disassociate()
	qdel(holder)

	deadmins += ckey
	admin_datums -= ckey
	verbs += /client/proc/readmin

	to_chat(src, "<span class='interface'>You are now a normal player.</span>")
	log_admin("[src] deadmined themself.")
	message_admins("[src] deadmined themself.")
	feedback_add_details("admin_verb","DAS")

/client/proc/readmin()
	set name = "Readmin"
	set category = "Admin"
	set desc = "Regain your admin powers."

	load_admins(ckey)

	if(!holder) // Something went wrong...
		return

	deadmins -= ckey
	verbs -= /client/proc/readmin

	to_chat(src, "<span class='interface'>You are now an admin.</span>")
	message_admins("[src] re-adminned themselves.")
	log_admin("[src] re-adminned themselves.")
	feedback_add_details("admin_verb","RAS")

/client/proc/populate_world(amount = 50 as num)
	set name = "Populate World"
	set category = "Debug"
	set desc = "(\"Amount of mobs to create\") Populate the world with test mobs."

	if (amount > 0)
		var/area/area
		var/list/candidates
		var/turf/open/floor/tile
		var/j,k
		var/mob/living/carbon/human/mob

		for (var/i = 1 to amount)
			j = 100

			do
				area = pick(the_station_areas)

				if (area)

					candidates = get_area_turfs(area)

					if (candidates.len)
						k = 100

						do
							tile = pick(candidates)
						while ((!tile || !istype(tile)) && --k > 0)

						if (tile)
							mob = new/mob/living/carbon/human/interactive(tile)

							testing("Spawned test mob with name \"[mob.name]\" at [tile.x],[tile.y],[tile.z]")
			while (!area && --j > 0)

/client/proc/toggle_AI_interact()
 	set name = "Toggle Admin AI Interact"
 	set category = "Admin"
 	set desc = "Allows you to interact with most machines as an AI would as a ghost"

 	AI_Interact = !AI_Interact
 	log_admin("[key_name(usr)] has [AI_Interact ? "activated" : "deactivated"] Admin AI Interact")
 	message_admins("[key_name_admin(usr)] has [AI_Interact ? "activated" : "deactivated"] their AI interaction")

/client/proc/toggle_afreeze(mob/target as mob)
	set name = "Afreeze"
	set category = "Admin"
	set desc = "Allows you to quickly freeze a player to prevent them from doing things like griefing."

	if(!check_rights(R_ADMIN))
		return
	target.toggleafreeze(usr)

/client/proc/create_ship()
	set name = "Generate Ships (Current System)"
	set category = "FTL"
	set desc = "Quickly create ships and add them to the world."

	var/datum/starship/s_type = input("Choose a ship type to create.","Creating Ships") in SSship.ship_types

	var/datum/star_faction/faction = input("Choose a faction for the selected ship.","Creating Ships") in SSship.star_factions

	var/num = input("How many ships to spawn?","Creating Ships",1) as num

	for(var/i in 1 to num)
		var/datum/starship/S = SSship.create_ship(s_type,faction.cname,SSstarmap.current_system)
		S.mission_ai = new /datum/ship_ai/guard //so they don't fuck off and run home
		S.mission_ai:assigned_system = SSstarmap.current_system

/client/proc/create_wingmen()
	set name = "Generate Wingmen (Current System)"
	set category = "FTL"
	set desc = "Create ships and assigns them to protect the player ship."

	var/datum/starship/s_type = input("Choose a ship type to create.","Creating Ships") in SSship.ship_types

	var/num = input("How many ships to spawn?","Creating Ships",1) as num

	for(var/i in 1 to num)
		var/datum/starship/S = SSship.create_ship(s_type,"nanotrasen",SSstarmap.current_system,SSstarmap.current_planet)
		S.mission_ai = new /datum/ship_ai/escort
		S.flagship = "ship"

/client/proc/create_fleet()
	set name = "Generate Fleet (Current System)"
	set category = "FTL"
	set desc = "Quickly create ships and assigns them to a flagship."

	var/datum/starship/s_type = input("Choose a flagship type to create.","Creating Ships") in SSship.ship_types

	var/datum/star_faction/faction = input("Choose a faction for the selected flagship.","Creating Ships") in SSship.star_factions

	var/datum/star_system/system = input("Choose a system to spawn the fleet in.","Creating Ships") in SSstarmap.star_systems

	var/datum/starship/flagship = SSship.create_ship(s_type,faction.cname,system)
	flagship.mission_ai = new /datum/ship_ai/patrol

	var/is_done = 0

	while(!is_done)

		var/list/options = SSship.ship_types + "Cancel"

		var/datum/starship/e_type = input("Choose a escort type to create.","Creating Ships") in options

		if(!istype(e_type))
			return

		var/num = input("How many escorts of this type to spawn?","Creating Ships",1) as num

		for(var/i in 1 to num)
			var/datum/starship/S = SSship.create_ship(e_type,faction.cname,system)
			S.mission_ai = new /datum/ship_ai/escort
			S.flagship = flagship

/client/proc/create_boarding()
	set name = "Call Boarding Event"
	set category = "FTL"
	set desc = "Quickly create boarding event"

	var/list/allowed_ships = list()
	if(SSstarmap.mode)
		log_admin("Boarding event was already called, don't bother, scrub.")
		return

	for(var/datum/starship/s_type in SSship.ship_types)
		if (s_type.boarding_map)
			allowed_ships += s_type

	var/datum/starship/ship = input("Choose a ship type to create.","Creating Ships") in allowed_ships
	if(!istype(ship))
		return
	ship.planet = SSstarmap.current_planet
	SSstarmap.init_boarding(ship, 1)

/client/proc/check_economy()
	set name = "View Economy Info"
	set category = "FTL"
	set desc = "Provides info on the economy of the factions in the game."

	var/dat = "<B><FONT SIZE=3>Economy Info</B></FONT><HR>"
	dat += "<BR><BR><B>Ore Prices:</B><BR><BR>"
	for(var/datum/star_resource/resource in SSstarmap.star_resources)
		var/price = SSstarmap.galactic_prices[resource.cname]
		dat += "<BR>([resource.cname]) [price]k Cr / ton"

	dat += "<BR><BR><B><FONT SIZE=3>Faction Data</FONT></B>:<HR>"
	for(var/datum/star_faction/faction in SSship.star_factions)
		if(faction.abstract)
			continue
		dat += "<BR><BR><FONT SIZE=2><B><U>[faction.name]</U></B></FONT>"
		var/gdp = 0
		var/total_money = faction.money + faction.s_money + faction.b_money
		for(var/resource in faction.resources)
			gdp += SSstarmap.galactic_prices[resource] * faction.resources[resource]
			gdp += total_money
		dat += "<BR><B>Gross Domestic Product</B>: [gdp]k Cr"

		dat += "<BR><BR><B>Total Funds</B>: [total_money]k Cr"
		dat += "<BR>Starting Funds: [faction.starting_funds]k Cr"
		dat += "<BR>Unreserved Funds: [faction.money]k Cr"
		dat += "<BR>Funds Reserved for Buying Resources: [faction.b_money]k Cr"
		dat += "<BR>Funds Reserved for Trade: [faction.s_money]k Cr"

		var/total_revenue = faction.tax_income + faction.trade_taxes + faction.trade_income
		dat += "<BR><BR><B>Total Revenue</B>: [total_revenue]k Cr"
		dat += "<BR>Tax Income: [faction.tax_income]k Cr"
		dat += "<BR>Trade Taxes: [faction.trade_taxes]k Cr"
		dat += "<BR>Trade Surplus: [faction.trade_income]k Cr"

		var/total_expenses = faction.building_fee + faction.trade_costs + faction.resource_costs
		dat += "<BR><BR><B>Total Expenses</B>: [total_expenses]k Cr"
		dat += "<BR>Ship Building Costs: [faction.building_fee]k Cr"
		dat += "<BR>Resource Costs: [faction.resource_costs]k Cr"
		dat += "<BR>Trade Deficit: [faction.trade_costs]k Cr"

		dat += "<BR><BR>Systems: [faction.systems.len]"
		dat += "<BR>Warships: [faction.num_warships]"
		dat += "<BR>Merchant Ships: [faction.num_merchants]"

	var/datum/browser/popup = new(usr, "economy info", "Economic Info", 800, 660)

	popup.set_content(dat)
	popup.open(0)

/client/proc/check_ships()
	set name = "Check Ship Info"
	set category = "FTL"
	set desc = "Provides info on all active ships in the world."

	var/dat = "<B><FONT SIZE=3>Economy Info</B></FONT><HR>"
	var/datum/star_faction/chosen = input("Choose a faction.","Ship Info") in SSship.star_factions
	dat += "<BR><BR><B><FONT SIZE=2>[chosen.name]</FONT></B>"

	for(var/datum/starship/S in chosen.ships)
		dat += "<BR><BR><B>[S.name]</B> <A href='?_src_=vars;Vars=\ref[S]'>(VV)</A>"
		dat += "<BR>Health: [S.hull_integrity]"
		dat += "<BR>Shields: [S.shield_strength]"

		dat += "<BR><BR>Location: [S.planet ? S.planet : "Hyperspace"]"

		dat += "<BR><BR>Target: [S.attacking_player ? station_name : S.attacking_target]"
		dat += "<BR>Combat Module: [S.combat_ai.cname]"
		dat += "<BR>Operations Module: [S.operations_ai.cname]"
		dat += "<BR>Mission Module: [S.mission_ai.cname]"
		dat += "<BR>Target System: [S.target_system ? S.target_system : "None"]"
		dat += "<BR>Current Vector: [S.ftl_vector ? S.ftl_vector : "None"]"

		if(S.escort_player || S.flagship)
			dat += "<BR>Flagship: [S.escort_player ? station_name : S.flagship]"

		if(S.operations_type)
			dat += "<BR>Cargo: [S.cargo ? S.cargo : "None"]: [S.cargo ? S.cargo_limit : ""]"

	var/datum/browser/popup = new(usr, "ship info", "Ship Info", 800, 660)

	popup.set_content(dat)
	popup.open(0)
