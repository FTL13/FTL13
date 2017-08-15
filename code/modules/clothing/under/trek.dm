//Just some alt-uniforms themed around Star Trek - Pls don't sue, Mr Roddenberry ;_;


/obj/item/clothing/under/trek
	can_adjust = 0


//TOS
/obj/item/clothing/under/trek/command
	name = "command uniform"
	desc = "The uniform worn by command officers"
	icon_state = "trek_command"
	item_color = "trek_command"
	item_state = "y_suit"

/obj/item/clothing/under/trek/engsec
	name = "engsec uniform"
	desc = "The uniform worn by engineering/security officers"
	icon_state = "trek_engsec"
	item_color = "trek_engsec"
	item_state = "r_suit"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0, fire = 0, acid = 0) //more sec than eng, but w/e.
	strip_delay = 50

/obj/item/clothing/under/trek/medsci
	name = "medsci uniform"
	desc = "The uniform worn by medical/science officers"
	icon_state = "trek_medsci"
	item_color = "trek_medsci"
	item_state = "b_suit"


//TNG
/obj/item/clothing/under/trek/command/next
	icon_state = "trek_next_command"
	item_color = "trek_next_command"
	item_state = "r_suit"

/obj/item/clothing/under/trek/engsec/next
	icon_state = "trek_next_engsec"
	item_color = "trek_next_engsec"
	item_state = "y_suit"

/obj/item/clothing/under/trek/medsci/next
	icon_state = "trek_next_medsci"
	item_color = "trek_next_medsci"


//ENT
/obj/item/clothing/under/trek/command/ent
	icon_state = "trek_ent_command"
	item_color = "trek_ent_command"
	item_state = "bl_suit"

/obj/item/clothing/under/trek/engsec/ent
	icon_state = "trek_ent_engsec"
	item_color = "trek_ent_engsec"
	item_state = "bl_suit"

/obj/item/clothing/under/trek/medsci/ent
	icon_state = "trek_ent_medsci"
	item_color = "trek_ent_medsci"
	item_state = "bl_suit"


//Q
/obj/item/clothing/under/trek/Q
	name = "french marshall's uniform"
	desc = "something about it feels off..."
	icon_state = "trek_Q"
	item_color = "trek_Q"
	item_state = "r_suit"


//BONUS TREK STUFF MOVED
/obj/item/clothing/under/trek/captrek
	name = "captain's suit"
	desc = "A stylish jumpsuit worn by the captain, waaaaait a minute you've seen this before somewhere."
	icon_state = "capttrek"
	item_color = "capttrek_s"
	item_state = "r_suit"

/obj/item/clothing/under/trek/hostrek
	name = "security officer's jumpsuit"
	desc = "A stylish jumpsuit worn by the security team, waaaaait a minute you've seen this before somewhere."
	icon_state = "hostrek"
	item_color = "hostrek_s"
	item_state = "y_suit"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0, fire = 0, acid = 0) //
	strip_delay = 50

/obj/item/clothing/under/trek/medtrek
	name = "medical officer's jumpsuit"
	desc = "A stylish jumpsuit worn by the medical and science staff, waaaaait a minute you've seen this before somewhere."
	icon_state = "scitrek"
	item_color = "scitrek_s"
	item_state = "b_suit"

/obj/item/clothing/under/trek/greytrek
	name = "cadet jumpsuit"
	desc = "A stylish jumpsuit given to those officers still in training, otherwise known as assistants, waaaaait a minute you've seen this before somewhere."
	icon_state = "greytrek"
	item_color = "greytrek_s"
	item_state = "g_suit"

/obj/item/clothing/under/trek/comttrek
	name = "command officer's jumpsuit"
	desc = "A stylish jumpsuit worn by the heads of staff, waaaaait a minute you've seen this before somewhere."
	icon_state = "comttrek"
	item_color = "comttrek_s"
	item_state = "r_suit"

///////end trek stuff///////