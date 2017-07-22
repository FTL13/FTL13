SUBSYSTEM_DEF(ast)
	name = "Bot Comms"
	flags = SS_NO_FIRE

/datum/controller/subsystem/ast/Initialize(timeofday)
	if(config && GLOB.bot_ip)
		var/query = "http://[GLOB.bot_ip]/?serverStart=1&key=[global.comms_key]"
		world.Export(query)

/datum/controller/subsystem/ast/proc/send_discord_message(var/channel, var/message)
	if(!config || !GLOB.bot_ip)
		return
	var/list/data = list()
	data["key"] = global.comms_key
	data["announce_channel"] = channel
	data["announce"] = message
	world.Export("http://[GLOB.bot_ip]/?[list2params(data)]")