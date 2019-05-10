//This is where I will store things used for the endgame 

//######################## MOOD LIGHTING
/obj/machinery/light/red
  icon_state = "tube-burned"
  light_color = LIGHT_COLOR_RED

/area/no_entry/boarding
  dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
  requires_power = TRUE
  
  //######################## High cap mag for the L6
/obj/item/ammo_box/magazine/mm195x129/highcap
  name = "high capacity box magazine (1.95x129mm)"
  max_ammo = 200

/obj/item/ammo_box/magazine/mm195x129/update_icon()
  ..()
  icon_state = "a762-[round(ammo_count(),(max_ammo/5))]"

/obj/item/weapon/gun/ballistic/automatic/l6_saw/nopin
  pin = null

/obj/item/weapon/gun/ballistic/automatic/l6_saw/update_icon()
  icon_state = "l6[cover_open ? "open" : "closed"][magazine ? round(get_ammo(0)*100/magazine.max_ammo,25) : "-empty"][suppressed ? "-suppressed" : ""]"
  item_state = "l6[cover_open ? "openmag" : "closedmag"]"
  
//######################## Barriers to block player progress 
/obj/machinery/beamgen
  name = "energy beam generator"
  desc = "The source of the energy beams blocking your passage through the ship."
  icon = 'icons/obj/machines/antimatter.dmi'
  icon_state = "core2"
  anchored = 1
  density = 1
  var/beamid = 1
  var/list/obj/effect/energybeam/connectedbeams = list()

/obj/machinery/beamgen/New()
  . = ..()
  if(SSstarmap.mode)
    SSstarmap.mode.beam_generators += src

/obj/machinery/beamgen/Destroy()
  GLOB.machines.Remove(src)
  loc.loc << sound('sound/weapons/ship_hit_shields_down.ogg',0,0,null,100)
  //playsound(loc, 'sound/weapons/ship_hit_shields_down.ogg', 100, 1)
  for(var/i in connectedbeams)
    var/obj/effect/energybeam/beam = i
    qdel(beam,TRUE)
  explosion(loc,2,3,5,10)
  if(!speed_process)
    STOP_PROCESSING(SSmachines, src)
  else
    STOP_PROCESSING(SSfastprocess, src)
  dropContents()
  return ..()
  

/obj/machinery/beamgen/id_2
  beamid = 2

/obj/machinery/beamgen/id_3
  beamid = 3

/obj/effect/energybeam
  name = "energy beam"
  desc = "A beam of energy used to block passage. Perhaps there is a way to disable the beam?"
  icon = 'icons/obj/machines/heavy_fiber.dmi'
  icon_state = "3"
  anchored = 1
  opacity = 0
  density = 1
  resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
  var/beamid = 1

/obj/effect/energybeam/Initialize()
  . = ..()
  if(SSstarmap.mode)
    for(var/bg in SSstarmap.mode.beam_generators)
      var/obj/machinery/beamgen/beamgen = bg
      if(beamgen.beamid == beamid)
        beamgen.connectedbeams += src
        break
    
/obj/effect/energybeam/Destroy(force)
  if(force)
    ..()
    . = QDEL_HINT_HARDDEL_NOW
  else
    return QDEL_HINT_LETMELIVE

/obj/effect/energybeam/CanPass(atom/movable/mover) //using lava code as it does the same thing
  var/thing_to_check = src
  if (mover)
    thing_to_check = list(mover)
  for(var/thing in thing_to_check)
    if(isobj(thing))
      var/obj/O = thing
      if((O.resistance_flags & (LAVA_PROOF|INDESTRUCTIBLE)) || O.throwing)
        continue
      . = 1
      if((O.resistance_flags & (ON_FIRE)))
        continue
      if(!(O.resistance_flags & FLAMMABLE))
        O.resistance_flags |= FLAMMABLE //Even fireproof things burn up in lava
      if(O.resistance_flags & FIRE_PROOF)
        O.resistance_flags &= ~FIRE_PROOF
      if(O.armor["fire"] > 50) //obj with 100% fire armor still get slowly burned away.
        O.armor["fire"] = 50
      O.fire_act(50000, 1000)

    else if (isliving(thing))
      . = 1
      var/mob/living/L = thing
      if(L.movement_type & FLYING)
        continue	//YOU'RE FLYING OVER IT
      if("lava" in L.weather_immunities)
        continue
      if(L.buckled)
        if(isobj(L.buckled))
          var/obj/O = L.buckled
          if(O.resistance_flags & LAVA_PROOF)
            continue
        if(isliving(L.buckled)) //Goliath riding
          var/mob/living/live = L.buckled
          if("lava" in live.weather_immunities)
            continue

      L.adjustFireLoss(20)
      if(L) //mobs turning into object corpses could get deleted here.
        L.adjust_fire_stacks(30)
        L.IgniteMob()

  
/obj/effect/energybeam/ew
  icon_state = "12"

/obj/effect/energybeam/id_2
  beamid = 2
  
/obj/effect/energybeam/ew/id_2
  beamid = 2

/obj/effect/energybeam/id_3
  beamid = 3
  
/obj/effect/energybeam/ew/id_3
  beamid = 3

/obj/effect/energybeam/ne
  icon_state = "5"

/obj/effect/energybeam/se
  icon_state = "6"

/obj/effect/energybeam/sw
  icon_state = "9"

/obj/effect/energybeam/nw
  icon_state = "10"
  
//######################## Extra OP weapon for the crew to use against the Unknown ship

/obj/item/weapon_chip/ecoli
  name = "Enhanced Charge Of Laser Induction cannon chip"
  weapon_name = "E.C.O.L.I. Cannon"
  weapon_desc = "An experimental weapon designed to annihilate the plasma stored in a ship's sheilds. A single round requires an extreme amount of energy."
  icon_name = "ion_cannon"

  projectile_type = /obj/item/projectile/ship_projectile/phase_blast/ecoli
  fire_sound = 'sound/weapons/beam_sniper.ogg'

  attack_data = new /datum/ship_attack/laser/ecoli

  charge_to_fire = 20000
  
/datum/ship_attack/laser/ecoli
  cname = "ecoli phase cannon"

  shot_accuracy = 2
  hull_damage = 50
  shield_damage = 300000
  charge_to_fire = 20000

/obj/item/projectile/ship_projectile/phase_blast/ecoli
  name = "ecoli cannon blast"
  icon = 'icons/effects/effects.dmi'
  icon_state = "shield2"

  hitsound = 'sound/weapons/beam_sniper.ogg'
  hitsound_wall = 'sound/weapons/beam_sniper.ogg'
  
//######################## Objective to force the target to be the Unknown Ship
/datum/objective/ftl/boardship/endgame
  endgame = TRUE