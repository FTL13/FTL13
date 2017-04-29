/obj/item/stack/telecrystal
  name = "raw telecrystals"
  desc = "Highly rare and dangerous mineral. Can be inserted into uplink."
  singular_name = "raw telecrystal"
  icon = 'icons/obj/module.dmi'
  icon_state = "bluespacearray"
  amount = 1
  max_amount = 50
  throwforce = 0
  throw_speed = 2
  throw_range = 2
  w_class = 1

/obj/item/stack/telecrystal/afterattack(obj/O, mob/user)
  if(istype(O,/obj/item))
    var/obj/item/I = O
    if(I.hidden_uplink && I.hidden_uplink.active)
      user << "<span class='notice'>You put [amount] [src] into [I].</span>"
      I.hidden_uplink.telecrystals += amount
      qdel(src)
      return

/obj/item/stack/telecrystal/five
  amount = 5

/obj/item/stack/telecrystal/ten
  amount = 10
