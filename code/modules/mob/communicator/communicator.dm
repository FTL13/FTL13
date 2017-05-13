// This is basically a communications hologram mob. It can exist in nullspace
// or it can be manifested on a communications holopad. It usually controls a
// ship, unless it's adminspawned, then it's just a CC hologram or something.
/mob/communicator
	name = "Communicator"
	desc = "A communications hologram. This person is somewhere else, but he is being projected here via a communications device."
	var/datum/starship/linked_ship
	var/obj/machinery/computer/communications/curr_console
	var/mob/original_ghost
	anchored = 1
	status_flags = GODMODE  // You can't damage it.

/mob/communicator/New()
	gender = pick(MALE,FEMALE)
	name = random_unique_name(gender)
	..()

/mob/communicator/admin/ClickOn(target)
	. = ..()
	if(!curr_console)
		if(original_ghost && ckey)
			original_ghost.ckey = ckey
		qdel(src)

/mob/communicator/ClickOn(target)
	if(curr_console && (target == curr_console || (curr_console.linked_comms_pad && target == curr_console.linked_comms_pad)))
		curr_console.close_channel()
	. = ..()

/mob/communicator/proc/update_hologram_to_outfit(datum/outfit/O)
	if(!O)
		return
	var/mob/living/carbon/human/dummy/mannequin = new()
	O.equip(mannequin, 1)
	CHECK_TICK
	var/icon/mob_icon = icon('icons/effects/effects.dmi', "nothing")
	CHECK_TICK
	// This is a bit of extra work, but I find it really annoying when sprites
	// permanently face south (I'm looking at you, Paradise)
	for(var/cdir in cardinal)
		mannequin.setDir(cdir)
		mob_icon.Insert(getFlatIcon(mannequin), dir=cdir)
		CHECK_TICK
	icon = getHologramIcon(mob_icon, 1, "green")

/mob/communicator/proc/admin_select_appearance()
	name = input("Select a name for your communications hologram", "Robust hologram creator") as text

	var/list/outfits = list("Custom","As Job...")
	var/list/paths = subtypesof(/datum/outfit) - typesof(/datum/outfit/job)
	for(var/path in paths)
		var/datum/outfit/O = path //not much to initalize here but whatever
		outfits[initial(O.name)] = path


	var/dresscode = input("Select dress for your hologram", "Robust hologram creator") as anything in outfits
	if (isnull(dresscode))
		return

	var/datum/job/jobdatum
	if (dresscode == "As Job...")
		var/jobname = input("Select job", "Robust hologram creator") as null|anything in get_all_jobs()
		if(isnull(jobname))
			return
		jobdatum = SSjob.GetJob(jobname)

	var/datum/outfit/custom = null
	if (dresscode == "Custom")
		var/list/custom_names = list()
		for(var/datum/outfit/D in custom_outfits)
			custom_names[D.name] = D
		var/selected_name = input("Select outfit", "Robust hologram creator") as null|anything in custom_names
		custom = custom_names[selected_name]
		if(isnull(custom))
			return
	switch(dresscode)
		if ("Naked")
			//do nothing
		if ("Custom")
			//use custom one
			update_hologram_to_outfit(custom)
		if ("As Job...")
			if(jobdatum && jobdatum.outfit)
				var/outfittype = jobdatum.outfit
				update_hologram_to_outfit(new outfittype)

		else
			var outfittype = outfits[dresscode]
			update_hologram_to_outfit(new outfittype)

/mob/communicator/Hear(message, atom/movable/speaker, message_langs, raw_message, radio_freq, list/spans)
	to_chat(src, "[message]")