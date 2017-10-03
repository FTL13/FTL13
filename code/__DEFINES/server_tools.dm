<<<<<<< HEAD
=======
// /tg/station 13 server tools API v3.1.0.1

//CONFIGURATION
//use this define if you want to do configuration outside of this file
#ifndef SERVER_TOOLS_EXTERNAL_CONFIGURATION
//Comment this out once you've filled in the below
//#error /tg/station server tools interface unconfigured

//Required interfaces (fill in with your codebase equivalent):

//create a global variable named `Name` and set it to `Value`
//These globals must not be modifiable from anywhere outside of the server tools
#define SERVER_TOOLS_DEFINE_AND_SET_GLOBAL(Name, Value) GLOBAL_VAR_INIT(##Name, ##Value); GLOBAL_PROTECT(##Name)
//Read the value in the global variable `Name`
#define SERVER_TOOLS_READ_GLOBAL(Name) GLOB.##Name
//Set the value in the global variable `Name` to `Value`
#define SERVER_TOOLS_WRITE_GLOBAL(Name, Value) GLOB.##Name = ##Value
//display an announcement `message` from the server to all players
#define SERVER_TOOLS_WORLD_ANNOUNCE(message) to_chat(world, "<span class='boldannounce'>[html_encode(##message)]</span>")
//Write a string `message` to a server log
#define SERVER_TOOLS_LOG(message) log_world("SERVICE: [##message]")
//Notify current in-game administrators of a string `event`
#define SERVER_TOOLS_NOTIFY_ADMINS(event) message_admins(##event)
//The current amount of connected clients
#define SERVER_TOOLS_CLIENT_COUNT GLOB.clients.len
#endif

//Required hooks:

//Put this somewhere in /world/New() that is always run
#define SERVER_TOOLS_ON_NEW ServiceInit()
//Put this somewhere in /world/Topic(T, Addr, Master, Keys) that is always run before T is modified
#define SERVER_TOOLS_ON_TOPIC var/service_topic_return = ServiceCommand(params2list(T)); if(service_topic_return) return service_topic_return
//Put at the beginning of world/Reboot(reason)
#define SERVER_TOOLS_ON_REBOOT ServiceReboot()

//Optional callable functions:

//Returns the string version of the API
#define SERVER_TOOLS_API_VERSION ServiceAPIVersion()
//Returns TRUE if the world was launched under the server tools and the API matches, FALSE otherwise
//No function below this succeed if this is FALSE
#define SERVER_TOOLS_PRESENT RunningService()
//Gets the current version of the service running the server
#define SERVER_TOOLS_VERSION ServiceVersion()
//Forces a hard reboot of BYOND by ending the process
//unlike del(world) clients will try to reconnect
//If the service has not requested a shutdown, the world will reboot shortly after
#define SERVER_TOOLS_REBOOT_BYOND world.ServiceEndProcess()
/*
	Gets the list of any testmerged github pull requests

	"[PR Number]" => list(
		"title" -> PR title
		"commit" -> Full hash of commit merged
		"author" -> Github username of the author of the PR
	)
*/
#define SERVER_TOOLS_PR_LIST GetTestMerges()
//Sends a message to connected game chats
#define SERVER_TOOLS_CHAT_BROADCAST(message) world.ChatBroadcast(message)
//Sends a message to connected admin chats
#define SERVER_TOOLS_RELAY_BROADCAST(message) world.AdminBroadcast(message)

//IMPLEMENTATION

#define SERVICE_API_VERSION_STRING "3.1.0.1"

>>>>>>> 4881c71... Merge pull request #31237 from Cyberboss/STAPIUpdate
#define REBOOT_MODE_NORMAL 0
#define REBOOT_MODE_HARD 1
#define REBOOT_MODE_SHUTDOWN 2

#define IRC_STATUS_THROTTLE 5

//keep these in sync with TGS3
#define SERVICE_WORLD_PARAM "server_service"
#define SERVICE_PR_TEST_JSON "..\\..\\prtestjob.json"

#define SERVICE_CMD_HARD_REBOOT "hard_reboot"
#define SERVICE_CMD_GRACEFUL_SHUTDOWN "graceful_shutdown"
#define SERVICE_CMD_WORLD_ANNOUNCE "world_announce"
<<<<<<< HEAD
#define SERVICE_CMD_IRC_CHECK "irc_check"
#define SERVICE_CMD_IRC_STATUS "irc_status"
#define SERVICE_CMD_ADMIN_MSG "adminmsg"
#define SERVICE_CMD_NAME_CHECK "namecheck"
#define SERVICE_CMD_ADMIN_WHO "adminwho"
=======
#define SERVICE_CMD_LIST_CUSTOM "list_custom_commands"
#define SERVICE_CMD_API_COMPATIBLE "api_compat"
#define SERVICE_CMD_PLAYER_COUNT "client_count"
>>>>>>> 4881c71... Merge pull request #31237 from Cyberboss/STAPIUpdate

//#define SERVICE_CMD_PARAM_KEY //defined in __compile_options.dm
#define SERVICE_CMD_PARAM_COMMAND "command"
#define SERVICE_CMD_PARAM_MESSAGE "message"
#define SERVICE_CMD_PARAM_TARGET "target"
#define SERVICE_CMD_PARAM_SENDER "sender"
<<<<<<< HEAD
=======
#define SERVICE_CMD_PARAM_CUSTOM "custom"

#define SERVICE_JSON_PARAM_HELPTEXT "help_text"
#define SERVICE_JSON_PARAM_ADMINONLY "admin_only"
#define SERVICE_JSON_PARAM_REQUIREDPARAMETERS "required_parameters"
>>>>>>> 4881c71... Merge pull request #31237 from Cyberboss/STAPIUpdate

#define SERVICE_REQUEST_KILL_PROCESS "killme"
#define SERVICE_REQUEST_IRC_BROADCAST "irc"
#define SERVICE_REQUEST_IRC_ADMIN_CHANNEL_MESSAGE "send2irc"
