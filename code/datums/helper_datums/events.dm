/*
 * WARRANTY VOID IF CODE USED
 */


/datum/events
	var/list/events

/datum/events/New()
	..()
	events = new

/datum/events/Destroy()
	for(var/elist in events)
		for(var/e in events[elist])
			qdel(e)
	events = null
	return ..()

/datum/events/proc/addEventType(event_type as text)
	if(!(event_type in events) || !islist(events[event_type]))
		events[event_type] = list()
		return TRUE
	return FALSE

//	Arguments: event_type as text, proc_holder as datum, proc_name as text
//	Returns: New event, null on error.
/datum/events/proc/addEvent(event_type as text, datum/callback/cb)
	if(!event_type || !cb)
		return
	addEventType(event_type)
	var/list/event = events[event_type]
	event += cb
	return cb

//  Arguments: event_type as text, any number of additional arguments to pass to event handler
//  Returns: null
<<<<<<< HEAD
/datum/events/proc/fireEvent(eventName, ...)
	var/list/event = listgetindex(events,eventName)
=======
/datum/events/proc/fireEvent()
	//to_chat(world, "Events in [args[1]] called")
	var/list/event = listgetindex(events,args[1])
>>>>>>> master
	if(istype(event))
		for(var/E in event)
			var/datum/callback/cb = E
			cb.InvokeAsync(arglist(args.Copy(2)))

// Arguments: event_type as text, E as /datum/event
// Returns: TRUE if event cleared, FALSE on error

/datum/events/proc/clearEvent(event_type as text, datum/callback/cb)
	if(!event_type || !cb)
		return FALSE
	var/list/event = listgetindex(events,event_type)
<<<<<<< HEAD
	event -= cb
	qdel(cb)
	return TRUE
=======
	event -= E
	return 1


/datum/event
	var/listener
	var/proc_name

/datum/event/New(tlistener,tprocname)
	listener = tlistener
	proc_name = tprocname
	return ..()

/datum/event/proc/Fire()
	//to_chat(world, "Event fired")
	if(listener)
		call(listener,proc_name)(arglist(args))
		return 1
	return
>>>>>>> master
