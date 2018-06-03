#define ALARM_SOUND_OFF 0
#define ALARM_SOUND_FIRED 1

#define COUNTDOWN10MIN 1
#define COUNTDOWN5MIN 2
#define COUNTDOWN2MIN 3
#define COUNTDOWN1MIN 4

/datum/round_event/ghost_role/boarding/proc/spawnTerminal(var/new_loc)
  if(mission_datum)
    var/obj/machinery/def_terminal/blackbox/Terminal = new /obj/machinery/def_terminal/blackbox(new_loc)
    Terminal.mode = src
  else
    var/obj/machinery/def_terminal/Terminal = new /obj/machinery/def_terminal(new_loc)
    Terminal.mode = src

  return 1

//TODO:here comes the terminal code itself

// ######### SELF DESTRUCT TERMINAL #########

/obj/machinery/def_terminal
  name = "Self Destruct Terminal"
  desc = "Self Destruct components recalibrating..."
  icon = 'icons/obj/machines/nuke_terminal.dmi'
  icon_state = "nuclearbomb_timing"
  anchored = 1
  resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
  density = TRUE
  var/datum/round_event/ghost_role/boarding/mode = null
  var/isactive = 1
  var/soundchecker = ALARM_SOUND_OFF
  var/lastcountdowngiven = 0
  var/isnuke = TRUE


/obj/machinery/def_terminal/process()
  if(isactive)
    if(!mode.shield_down_announced) //No point running all this when the shield is down
      mode.shield_countdown = mode.shield_timer - world.time
      if(mode.shield_countdown <= 0 && !mode.shield_down_announced)
        minor_announce("[mode.shipname]'s anti-boarding shield has weakened enough to let most physical objects pass.","Ship sensor automatic announcement")
        mode.shield_down_announced = TRUE
      for(var/obj/effect/defence/D in world)
        if(D.z != src.z)
          continue
        else
          if(mode.shield_countdown >= 0 && !D.istime)
            D.desc = "Shield going down in [(mode.shield_countdown)/10] seconds"
            //
          else
            D.desc = "The shield is weakened, but still holds enough power to prevent cowards from running or cyborgs to pass!"
            D.icon_state = "shieldsparkles"
            D.callTime()
    if(isnuke)
      mode.detonation_countdown = mode.detonation_timer - world.time //I figure its better to calc it one rather than for each if loop
      desc = "ALERT! SELF-DESTRUCTION ACTIVATED. TIME LEFT: [time2text(mode.detonation_countdown, "mm:ss")]"
      if(mode.detonation_countdown <= 6000 && lastcountdowngiven == 0)
        minor_announce("Warning! Ten minutes untill [mode.shipname]'s Self-Destruct Mechanism activates.","Ship sensor automatic announcement")
        lastcountdowngiven = COUNTDOWN10MIN
      else if(mode.detonation_countdown <= 3000 && lastcountdowngiven == COUNTDOWN10MIN)
        minor_announce("Warning! Five minutes untill [mode.shipname]'s Self-Destruct Mechanism activates.","Ship sensor automatic announcement")
        lastcountdowngiven = COUNTDOWN5MIN
      else if(mode.detonation_countdown <= 1200 && lastcountdowngiven == COUNTDOWN5MIN)
        minor_announce("Warning! Two minutes [mode.shipname]'s Self-Destruct Mechanism activates.","Ship sensor automatic announcement")
        lastcountdowngiven = COUNTDOWN2MIN
      else if(mode.detonation_countdown <= 600 && lastcountdowngiven == COUNTDOWN2MIN)
        minor_announce("Warning! One minute untill [mode.shipname]'s Self-Destruct Mechanism activates.","Ship sensor automatic announcement")
        lastcountdowngiven = COUNTDOWN1MIN
      else if (!soundchecker && mode.detonation_countdown <= 120)
        soundchecker = ALARM_SOUND_FIRED
        icon_state = "nuclearbomb_exploding"
        for(var/mob/M in GLOB.player_list)
          if(M.z == src.z)
            M << 'sound/machines/alarm.ogg'
      else if(mode.detonation_countdown < 0)
        callExplosion()
        for(var/obj/effect/defence/D in world)
          if(D.z == src.z)
            qdel(D,TRUE)
        qdel(src)
  else
    for(var/obj/effect/defence/D in world)
      if(D.z == src.z) //Crew wins, now they can take the pirates prisoner
        qdel(D,TRUE)


/obj/machinery/def_terminal/attack_hand(mob/user)
  if(ishuman(user) && isactive)
    if(user.mind.special_role != "Defender")
      if(do_after(user,300,target = src)) //30 seconds
        mode.victory()
        isactive = 0
        icon_state = "nuclearbomb_base"
        desc = "ALL SYSTEMS DEACTIVATED"

/obj/machinery/def_terminal/ex_act()
  return

/obj/machinery/def_terminal/proc/callExplosion()
  if(mode.defeat(loc.z) && isactive)
   	explosion(src.loc,5,50,70,100,TRUE,TRUE) //KABOOM. We did warn them to leave...
  for(var/obj/effect/landmark/L in world)
    if(L.z != src.z || L.name != "explosive")
      continue
    else
      explosion(L.loc,2,10,20,30) //kaboom
  mode = null
  qdel(src)

// ######### SHIP BLACKBOX #########

/obj/machinery/def_terminal/blackbox
  name = "Ship blackbox recorder"
  desc = "A Blackbox Recorder, storing crutical data from the ship. All stored on a trusty tape reel!"
  icon = 'icons/obj/stationobjs.dmi'
  icon_state = "blackbox"
  isnuke = FALSE


/obj/machinery/def_terminal/attack_hand(mob/user)
  if(ishuman(user) && isactive)
    if(user.mind.special_role != "Defender")
      if(do_after(user,300,target = src)) //30 seconds
        mode.victory()
        new /obj/item/weapon/tapereel(loc)
        isactive = 0
        icon_state = "blackbox_empty"
        desc = "The recorder seems to be missing it's tape reel..."

// ######### SHIP BLACKBOX TAPE REEL #########

/obj/item/weapon/tapereel
  name = "tape reel"
  desc = "A huge tape reel containing information from a ship. You feel a strong urge to pull the tape out."
  icon = 'icons/obj/items.dmi'
  icon_state = "tape_reel"
  item_state = "tape_reel"
  force = 1
