/obj/item/weapon/shield/energy/defender/dropped(mob/user)
  active = 0
  force = 3
  throwforce = 3
  throw_speed = 3
  w_class = 1

/obj/item/weapon/shield/energy/defender/attack_self(mob/living/carbon/human/user)
  if(user.mind.special_role == "Defender")
    user << "Authorization failed"
    return
  ..()
