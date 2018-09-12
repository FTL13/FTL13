SUBSYSTEM_DEF(ast)
	name = "Bot Comms"
	flags = SS_NO_FIRE

/datum/controller/subsystem/ast/Initialize(timeofday)
	if(config && GLOB.bot_ip)
		var/query = "http://[GLOB.bot_ip]/?serverStart=1&key=[global.comms_key]"
		world.Export(query)

/datum/controller/subsystem/ast/proc/send_discord_message(var/channel, var/message, var/priority_type)
	if(!config || !GLOB.bot_ip)
		return
	if(priority_type && !total_admins_active())
		send_discord_message(channel, "@here - A new [priority_type] requires/might need attention, but there are no admins online.")
	var/list/data = list()
	data["key"] = global.comms_key
	data["announce_channel"] = channel
	data["announce"] = message
	world.Export("http://[GLOB.bot_ip]/?[list2params(data)]")
