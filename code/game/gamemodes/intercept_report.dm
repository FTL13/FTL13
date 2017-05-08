//Intercept reports are sent to the station every round to warn the crew of possible threats. They consist of five possibilites, one of which is always correct.

/datum/intercept_text
	var/text

/datum/intercept_text/proc/build(mode_type)
	text = "<hr>"
	switch(mode_type)
		if("blob")
			text += "A CMP scientist by the name of [pick("Griff", "Pasteur", "Chamberland", "Buist", "Rivers", "Stanley")] boasted about his corporation's \"finest creation\" - a macrobiological \
			virus capable of self-reproduction and hellbent on consuming whatever it touches. He went on to query Cybersun for permission to utilize the virus in biochemical warfare, to which \
			CMP subsequently gained. Be vigilant for any large organisms rapidly spreading across the station, as they are classified as a level 5 biohazard and critically dangerous. Note that \
			this organism seems to be weak to extreme heat; concentrated fire (such as welding tools and lasers) will be effective against it."
		if("changeling")
			text += "The Gorlex Marauders have announced the successful raid and destruction of Central Command containment ship #S-[rand(1111, 9999)]. This ship housed only a single prisoner - \
			codenamed \"Thing\", and it was highly adaptive and extremely dangerous. We have reason to believe that the Thing has allied with the Syndicate, and you should note that likelihood \
			of the Thing being sent to a station in this sector is highly likely. It may be in the guise of any crew member. Trust nobody - suspect everybody. Do not announce this to the crew, \
			as paranoia may spread and inhibit workplace efficiency."
		if("clock_cult")
			text += "We have lost contact with multiple stations in your sector. They have gone dark and do not respond to all transmissions, although they appear intact and the crew's life \
			signs remain uninterrupted. Those that have managed to send a transmission or have had some of their crew escape tell tales of a machine cult creating sapient automatons and seeking \
			to brainwash the crew to summon their god, Ratvar. If evidence of this cult is dicovered aboard your station, extreme caution and extreme vigilance must be taken going forward, and \
			all resources should be devoted to stopping this cult. Note that holy water seems to weaken and eventually return the minds of cultists that ingest it, and mindshield implants will \
			prevent conversion altogether."
		if("cult")
			text += "Some stations in your sector have reported evidence of blood sacrifice and strange magic. Ties to the Wizards' Federation have been proven not to exist, and many employees \
			have disappeared; even Central Command employees light-years away have felt strange presences and at times hysterical compulsions. Interrogations point towards this being the work of \
			the cult of Nar-Sie. If evidence of this cult is discovered aboard your station, extreme caution and extreme vigilance must be taken going forward, and all resources should be \
			devoted to stopping this cult. Note that holy water seems to weaken and eventually return the minds of cultists that ingest it, and mindshield implants will prevent conversion \
			altogether."
		if("extended")
			text += "The transmission mostly failed to mention your sector. It is possible that there is nothing in the Syndicate that could threaten your station during this shift."
		if("gang")
			text += "Cybersun Industries representatives claimed that they, in joint research with the Tiger Cooperative, have made a major breakthrough in brainwashing technology, and have \
			made the nanobots that apply the \"conversion\" very small and capable of fitting into usually innocent objects - namely, pens. While they refused to outsource this technology for \
			months to come due to its flaws, they reported some as missing but passed it off to carelessness. At Central Command, we don't like mysteries, and we have reason to believe that this \
			technology was stolen for anti-Nanotrasen use. Be on the lookout for territory claims and unusually violent crew behavior, applying mindshield implants as necessary."
		if("malf")
			text += "A large ionospheric anomaly recently passed through your sector. Although physically undetectable, ionospherics tend to have an extreme effect on telecommunications equipment \
			as well as artificial intelligence units. Closely observe the behavior of artificial intelligence, and treat any machine malfunctions as purposeful. If necessary, termination of the \
			artificial intelligence is advised; assuming that it activates the station's self-destruct, your pinpointer has been configured to constantly track it, wherever it may be."
		if("nuclear")
			text += "One of Central Command's trading routes was recently disrupted by a raid carried out by the Gorlex Marauders. They seemed to only be after one ship - a highly-sensitive \
			transport containing a nuclear fission explosive, although it is useless without the proper code and authorization disk. While the code was likely found in minutes, the only disk that \
			can activate this explosive is on your station. Ensure that it is protected at all times, and remain alert for possible intruders."
		if("revolution")
			text += "Employee unrest has spiked in recent weeks, with several attempted mutinies on heads of staff. Some crew have been observed using flashbulb devices to blind their colleagues, \
			who then follow their orders without question and work towards dethroning departmental leaders. Watch for behavior such as this with caution. If the crew attempts a mutiny, you and \
			your heads of staff are fully authorized to execute them using lethal weaponry - they will be later cloned and interrogated at Central Command."
		if("traitor")
<<<<<<< HEAD
			text += "Although more specific threats are commonplace, you should always remain vigilant for Syndicate agents aboard your station. Syndicate communications have implied that many \
			Nanotrasen employees are Syndicate agents with hidden memories that may be activated at a moment's notice, so it's possible that these agents might not even know their positions."
		if("wizard")
			text += "A dangerous Wizards' Federation individual by the name of [pick(GLOB.wizard_first)] [pick(GLOB.wizard_second)] has recently escaped confinement from an unlisted prison facility. This \
			man is a dangerous mutant with the ability to alter himself and the world around him by what he and his leaders believe to be magic. If this man attempts an attack on your station, \
			his execution is highly encouraged, as is the preservation of his body for later study."
	return text
=======
			src.text = ""
			src.build_traitor(correct_person)
			return src.text
		if("changeling","traitorchan")
			src.text = ""
			src.build_changeling(correct_person)
			return src.text
		else
			return null

// NOTE: Commentted out was the code which showed the chance of someone being an antag. If you want to re-add it, just uncomment the code.

/*
/datum/intercept_text/proc/pick_mob()
	var/list/dudes = list()
	for(var/mob/living/carbon/human/man in player_list)
		if (!man.mind) continue
		if (man.mind.assigned_role=="MODE") continue
		dudes += man
	if(dudes.len==0)
		return null
	return pick(dudes)


/datum/intercept_text/proc/pick_fingerprints()
	var/mob/living/carbon/human/dude = src.pick_mob()
	//if (!dude) return pick_fingerprints() //who coded that is totally crasy or just a traitor. -- rastaf0
	if(dude)
		return num2text(md5(dude.dna.uni_identity))
	else
		return num2text(md5(num2text(rand(1,10000))))
*/

/datum/intercept_text/proc/build_traitor(datum/mind/correct_person)
	var/name_1 = pick(src.org_names_1)
	var/name_2 = pick(src.org_names_2)

	/*
	var/fingerprints
	var/traitor_name
	var/prob_right_dude = rand(prob_correct_person_lower, prob_correct_person_higher)
	if(prob(prob_right_dude) && ticker.mode == "traitor")
		if(correct_person:assigned_role=="MODE")
			traitor_name = pick_mob()
		else
			traitor_name = correct_person:current
	else if(prob(prob_right_dude))
		traitor_name = pick_mob()
	else
		fingerprints = pick_fingerprints()
	*/

	src.text += "<BR><BR>The <B><U>[name_1] [name_2]</U></B> implied an undercover operative was acting on their behalf on the station currently."
	src.text += "It would be in your best interests to suspect everybody, as these undercover operatives could have implants which trigger them to have their memories removed until they are needed. He, or she, could even be a high ranking officer."
	src.text += "<BR><HR>"
	/*
	src.text += "After some investigation, we "
	if(traitor_name)
		src.text += "are [prob_right_dude]% sure that [traitor_name] may have been involved, and should be closely observed."
		src.text += "<BR>Note: This group are known to be untrustworthy, so do not act on this information without proper discourse."
	else
		src.text += "discovered the following set of fingerprints ([fingerprints]) on sensitive materials, and their owner should be closely observed."
		src.text += "However, these could also belong to a current Centcom employee, so do not act on this without reason."
	*/


/datum/intercept_text/proc/build_cult(datum/mind/correct_person)
	var/name_1 = pick(src.org_names_1)
	var/name_2 = pick(src.org_names_2)
	/*
	var/traitor_name
	var/traitor_job
	var/prob_right_dude = rand(prob_correct_person_lower, prob_correct_person_higher)
	var/prob_right_job = rand(prob_correct_job_lower, prob_correct_job_higher)
	if(prob(prob_right_job) && is_convertable_to_cult(correct_person))
		if (correct_person)
			if(correct_person:assigned_role=="MODE")
				traitor_job = pick(get_all_jobs())
			else
				traitor_job = correct_person:assigned_role
	else
		var/list/job_tmp = get_all_jobs()
		job_tmp.Remove("Captain", "Chaplain", "AI", "Cyborg", "Security Officer", "Detective", "Head Of Security", "Executive Officer", "Chief Engineer", "Research Director", "Chief Medical Officer")
		traitor_job = pick(job_tmp)
	if(prob(prob_right_dude) && ticker.mode == "cult")
		if(correct_person:assigned_role=="MODE")
			traitor_name = src.pick_mob()
		else
			traitor_name = correct_person:current
	else
		traitor_name = pick_mob()
	*/
	src.text += "<BR><BR>It has been brought to our attention that the <B><U>[name_1] [name_2]</U></B> have stumbled upon some dark secrets. They apparently want to spread the dangerous knowledge onto as many stations as they can."
	src.text += "Watch out for the following: praying to an unfamilar god, preaching the word of \[REDACTED\], sacrifices, magical dark power, living constructs of evil and a portal to the dimension of the underworld."
	src.text += "<BR><HR>"
	/*
	src.text += "Based on our intelligence, we are [prob_right_job]% sure that if true, someone doing the job of [traitor_job] on your station may have been converted "
	src.text += "and instilled with the idea of the flimsiness of the real world, seeking to destroy it. "
	if(prob(prob_right_dude))
		src.text += "<BR> In addition, we are [prob_right_dude]% sure that [traitor_name] may have also some in to contact with this "
		src.text += "organisation."
	src.text += "<BR>However, if this information is acted on without substantial evidence, those responsible will face severe repercussions."
	*/


/datum/intercept_text/proc/build_rev(datum/mind/correct_person)
	var/name_1 = pick(src.org_names_1)
	var/name_2 = pick(src.org_names_2)
	/*
	var/traitor_name
	var/traitor_job
	var/prob_right_dude = rand(prob_correct_person_lower, prob_correct_person_higher)
	var/prob_right_job = rand(prob_correct_job_lower, prob_correct_job_higher)
	if(prob(prob_right_job) && is_convertable_to_rev(correct_person))
		if (correct_person)
			if(correct_person.assigned_role=="MODE")
				traitor_job = pick(get_all_jobs())
			else
				traitor_job = correct_person.assigned_role
	else
		var/list/job_tmp = get_all_jobs()
		job_tmp-=nonhuman_positions
		job_tmp-=command_positions
		job_tmp.Remove("Security Officer", "Detective", "Master-at-Arms", "MODE")
		traitor_job = pick(job_tmp)
	if(prob(prob_right_dude) && ticker.mode.config_tag == "revolution")
		if(correct_person.assigned_role=="MODE")
			traitor_name = src.pick_mob()
		else
			traitor_name = correct_person.current
	else
		traitor_name = src.pick_mob()
	*/
	src.text += "<BR><BR>It has been brought to our attention that the <B><U>[name_1] [name_2]</U></B> are attempting to stir unrest on one of our stations in your sector."
	src.text += "Watch out for suspicious activity among the crew and make sure that all heads of staff report in periodically."
	src.text += "<BR><HR>"
	/*
	src.text += "Based on our intelligence, we are [prob_right_job]% sure that if true, someone doing the job of [traitor_job] on your station may have been brainwashed "
	src.text += "at a recent conference, and their department should be closely monitored for signs of mutiny. "
	if(prob(prob_right_dude))
		src.text += "<BR> In addition, we are [prob_right_dude]% sure that [traitor_name] may have also some in to contact with this "
		src.text += "organisation."
	src.text += "<BR>However, if this information is acted on without substantial evidence, those responsible will face severe repercussions."
	*/

/datum/intercept_text/proc/build_gang(datum/mind/correct_person)
	src.text += "<BR><BR>We have reports of criminal activity in close proximity to our operations within your sector."
	src.text += "Ensure law and order is maintained on the station and be on the lookout for territorial aggression within the crew."
	src.text += "In the event of a full-scale criminal takeover threat, sensitive research items are to be secured and the station evacuated ASAP."
	src.text += "<BR><HR>"

/datum/intercept_text/proc/build_wizard(datum/mind/correct_person)
	var/SWF_desc = pick(SWF_names)

	src.text += "<BR><BR>The evil Space Wizards Federation have recently broke their most feared wizard, known only as <B>\"[SWF_desc]\"</B> out of space jail. "
	src.text += "He is on the run, last spotted in a system near your present location. If anybody suspicious is located aboard, please "
	src.text += "approach with EXTREME caution. Centcom also recommends that it would be wise to not inform the crew of this, due to their fearful nature."
	src.text += "Known attributes include: Brown sandals, a large blue hat, a voluptous white beard, and an inclination to cast spells."
	src.text += "<BR><HR>"

/datum/intercept_text/proc/build_nuke(datum/mind/correct_person)
	src.text += "<BR><BR>Centcom recently received a report of a plot to destroy one of our stations in your area. We believe the Nuclear Authentication Disc "
	src.text += "that is standard issue aboard your vessel may be a target. We recommend removal of this object, and it's storage in a safe "
	src.text += "environment. As this may cause panic among the crew, all efforts should be made to keep this information a secret from all but "
	src.text += "the most trusted crew-members."
	src.text += "<BR><HR>"

/datum/intercept_text/proc/build_changeling(datum/mind/correct_person)
	var/cname = pick(src.changeling_names)
	var/orgname1 = pick(src.org_names_1)
	var/orgname2 = pick(src.org_names_2)
	/*
	var/changeling_name
	var/changeling_job
	var/prob_right_dude = rand(prob_correct_person_lower, prob_correct_person_higher)
	var/prob_right_job = rand(prob_correct_job_lower, prob_correct_job_higher)
	if(prob(prob_right_job))
		if(correct_person)
			if(correct_person:assigned_role=="MODE")
				changeling_job = pick(get_all_jobs())
			else
				changeling_job = correct_person:assigned_role
	else
		changeling_job = pick(get_all_jobs())
	if(prob(prob_right_dude) && ticker.mode == "changeling")
		if(correct_person:assigned_role=="MODE")
			changeling_name = correct_person:current
		else
			changeling_name = src.pick_mob()
	else
		changeling_name = src.pick_mob()
	*/

	src.text += "<BR><BR>We have received a report that a dangerous alien lifeform known only as <B><U>\"[cname]\"</U></B> may have infiltrated your crew.  "
	/*
	src.text += "Our intelligence suggests a [prob_right_job]% chance that a [changeling_job] on board your station has been replaced by the alien.  "
	src.text += "Additionally, the report indicates a [prob_right_dude]% chance that [changeling_name] may have been in contact with the lifeform at a recent social gathering.  "
	*/
	src.text += "These lifeforms are associated with the <B><U>[orgname1] [orgname2]</U></B> and may be attempting to acquire sensitive materials on their behalf.  "
	src.text += "Please take care not to alarm the crew, as <B><U>[cname]</U></B> may take advantage of a panic situation. Remember, they can be anybody, suspect everybody!"
	src.text += "<BR><HR>"
>>>>>>> master
