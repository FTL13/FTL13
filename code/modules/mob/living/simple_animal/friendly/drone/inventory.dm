
///////////////////
//DRONE INVENTORY//
///////////////////
//Drone inventory
//Drone hands


<<<<<<< HEAD
/mob/living/simple_animal/drone/doUnEquip(obj/item/I, force)
	if(..())
=======


/mob/living/simple_animal/drone/activate_hand(selhand)

	if(istext(selhand))
		selhand = lowertext(selhand)

		if(selhand == "right" || selhand == "r")
			selhand = 0
		if(selhand == "left" || selhand == "l")
			selhand = 1

	if(selhand != src.hand)
		swap_hand()
	else
		mode()


/mob/living/simple_animal/drone/swap_hand()
	var/obj/item/held_item = get_active_hand()
	if(held_item)
		if(istype(held_item, /obj/item/weapon/twohanded))
			var/obj/item/weapon/twohanded/T = held_item
			if(T.wielded == 1)
				to_chat(usr, "<span class='warning'>Your other hand is too busy holding the [T.name].</span>")
				return

	hand = !hand
	if(hud_used && hud_used.inv_slots[slot_l_hand] && hud_used.inv_slots[slot_r_hand])
		var/obj/screen/inventory/hand/H
		H = hud_used.inv_slots[slot_l_hand]
		H.update_icon()
		H = hud_used.inv_slots[slot_r_hand]
		H.update_icon()


/mob/living/simple_animal/drone/unEquip(obj/item/I, force)
	if(..(I,force))
>>>>>>> master
		update_inv_hands()
		if(I == head)
			head = null
			update_inv_head()
		if(I == internal_storage)
			internal_storage = null
			update_inv_internal_storage()
		return 1
	return 0


/mob/living/simple_animal/drone/can_equip(obj/item/I, slot)
	switch(slot)
		if(slot_head)
			if(head)
				return 0
			if(!((I.slot_flags & SLOT_HEAD) || (I.slot_flags & SLOT_MASK)))
				return 0
			return 1
		if(slot_generic_dextrous_storage)
			if(internal_storage)
				return 0
			return 1
	..()


/mob/living/simple_animal/drone/get_item_by_slot(slot_id)
	switch(slot_id)
		if(slot_head)
			return head
		if(slot_generic_dextrous_storage)
			return internal_storage
	return ..()


/mob/living/simple_animal/drone/equip_to_slot(obj/item/I, slot)
	if(!slot)
		return
	if(!istype(I))
		return

	var/index = get_held_index_of_item(I)
	if(index)
		held_items[index] = null
	update_inv_hands()

	if(I.pulledby)
		I.pulledby.stop_pulling()

	I.screen_loc = null // will get moved if inventory is visible
	I.loc = src
	I.layer = ABOVE_HUD_LAYER
	I.plane = ABOVE_HUD_PLANE

	switch(slot)
		if(slot_head)
			head = I
			update_inv_head()
		if(slot_generic_dextrous_storage)
			internal_storage = I
			update_inv_internal_storage()
		else
			to_chat(src, "<span class='danger'>You are trying to equip this item to an unsupported inventory slot. Report this to a coder!</span>")
			return

	//Call back for item being equipped to drone
	I.equipped(src, slot)

/mob/living/simple_animal/drone/getBackSlot()
	return slot_generic_dextrous_storage

/mob/living/simple_animal/drone/getBeltSlot()
	return slot_generic_dextrous_storage
