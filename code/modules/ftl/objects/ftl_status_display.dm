#define CHARS_PER_LINE 5
#define FONT_SIZE "5pt"
#define FONT_COLOR "#09f"
#define FONT_STYLE "Arial Black"
#define SCROLL_SPEED 2

/obj/machinery/status_display/ftl/update() //TODO: when we rebase get this running, since it has custom FTL functions. Won't include it right now because no reason to
	if(friendc && mode!=4) //Makes all status displays except supply shuttle timer display the eye -- Urist
		set_picture("ai_friend")
		return

	switch(mode)
		if(0)				//blank
			remove_display()
		if(1)				//emergency shuttle timer
			display_shuttle_status()
		if(2)				//custom messages
			var/line1
			var/line2

			if(!index1)
				line1 = message1
			else
				line1 = copytext(message1+"|"+message1, index1, index1+CHARS_PER_LINE)
				var/message1_len = length(message1)
				index1 += SCROLL_SPEED
				if(index1 > message1_len)
					index1 -= message1_len

			if(!index2)
				line2 = message2
			else
				line2 = copytext(message2+"|"+message2, index2, index2+CHARS_PER_LINE)
				var/message2_len = length(message2)
				index2 += SCROLL_SPEED
				if(index2 > message2_len)
					index2 -= message2_len
			update_display(line1, line2)
		if(4)				//Supply shuttle doesn't exist anymore
			remove_display()
		if(5)				//FTL shuttle timer
			var/line1 = "-FTL-"
			var/line2
			if(SSstarmap.in_transit || SSstarmap.in_transit_planet)
				line2 = SSstarmap.getTimerStr()
			else
				line2 = " N/A "
			update_display(line1, line2)

/obj/machinery/status_display/ftl/receive_signal(datum/signal/signal)
	if(supply_display)
		mode = 4
		return
	switch(signal.data["command"])
		if("blank")
			mode = 0
		if("shuttle")
			mode = 1
		if("message")
			mode = 2
			set_message(signal.data["msg1"], signal.data["msg2"])
		if("alert")
			mode = 3
			set_picture(signal.data["picture_state"])
		if("supply")
			if(supply_display)
				mode = 4
		if("ftl")
			mode = 5

#undef CHARS_PER_LINE
#undef FOND_SIZE
#undef FONT_COLOR
#undef FONT_STYLE
#undef SCROLL_SPEED
