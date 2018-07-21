/obj/machinery/power/shipweapon/ion
  name = "Ion cannon"
  desc = "An experimental weapon designed pierce shields and cause damage to the ship without leaving the hull in ruins.\n<span class='notice'>Alt-click to rotate it clockwise.</span>"
  icon_state = "ion_cannon_0"
  weapon_icon_path = "ion_cannon_"
  weapon_icon_max_states = 1

  charge_to_fire = 5000

  projectile_type = /obj/item/projectile/ship_projectile/phase_blast/ion
  projectile_sound = 'sound/weapons/emitter2.ogg'

/obj/machinery/power/shipweapon/ion/New()
	. = ..()
	var/obj/item/weapon/circuitboard/machine/B = new /obj/item/weapon/circuitboard/machine/ion_cannon(null)
	B.apply_default_parts(src)
	RefreshParts()

/obj/item/weapon/circuitboard/machine/ion_cannon
	name = "circuit board (Ion Cannon)"
	build_path = /obj/machinery/power/shipweapon/ion
	origin_tech = "programming=3;powerstorage=4;combat=4;engineering=3"
	req_components = list(
							/obj/item/weapon/stock_parts/micro_laser = 2,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/stock_parts/cell = 1)

/obj/machinery/power/shipweapon/ion/update_icon()
	if(can_fire())
		icon_state = "[weapon_icon_path]2"
	else if(powered)
		icon_state = "[weapon_icon_path]1"
	else
		icon_state = "[weapon_icon_path]0"

/obj/item/projectile/ship_projectile/phase_blast/ion
  name = "ion cannon blast"
  icon_state = "tesla_projectile"
  attack_data = /datum/ship_attack/ion

  hitsound = 'sound/weapons/zapbang.ogg'
  hitsound_wall = 'sound/weapons/zapbang.ogg'
