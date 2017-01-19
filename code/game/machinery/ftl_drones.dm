/obj/machinery/drone
  name = "common drone"
  icon = 'icons/obj/drones.dmi'
  icon_state = "drone"
  density = 1
  anchored = 0
  var/is_orbiting = 0
  var/ammo_max
  var/ammo_remaining
  var/id = "drone_d_0"

/obj/machinery/drone/defence
  name = "Defence drone Mk.I"
  desc = "Standard defence drone for NT vessels"
  icon = 'icons/obj/drones.dmi'
  icon_state = "drone_def"
  ammo_max = 250
  var/hit_chance = 1

/obj/machinery/drone/defence/New()
	id = "drone_d_[rand(1,1000)]"

/obj/item/weapon/twohanded/required/shell_casing/bullet_pack_drone
	name = "defence drone ammo pack"
	desc = "Inject it into drone to reload it"
	icon = 'icons/obj/ammo.dmi'
	icon_state = ".50mag"
	item_state = ".50mag"
	var/ammo = 250

/obj/machinery/drone/defence/New()
  ammo_remaining = ammo_max

/obj/machinery/drone/defence/attack_hand(mob/user as mob)
	var/obj/item/weapon/twohanded/required/shell_casing/bullet_pack_drone/pack
	pack.ammo = ammo_remaining
	ammo_remaining = 0
	user.put_in_hands(pack)
	user << "You took the ammo from the drone!"

/obj/machinery/drone/defence/attackby(obj/item/weapon/twohanded/required/shell_casing/bullet_pack_drone/B, mob/user)
	ammo_remaining = B.ammo
	user << "You replaced the drone ammo!"
	qdel(B)

/obj/machinery/drone/defence/proc/can_fire()
  if(!ammo_remaining)    return 0
  else  return 1

/obj/machinery/drone/defence/proc/fire()
  ammo_remaining--

/obj/machinery/drone/defence/proc/any_success()
  if(prob(hit_chance))    return 1
  else  return 0




