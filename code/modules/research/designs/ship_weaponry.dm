//Here we dare store the few weapons we let the crew build

/datum/design/board/ion_cannon
  name = "Ion cannon board"
  desc = "Allows for the construction of an Ion cannon's main circuitry."
  id = "ion_cannon_board"
  req_tech = list("programming" = 4, "powerstorage" = 4, "combat" = 4, "engineering" = 3)
  materials = list(MAT_GLASS = 2000, MAT_GOLD = 10000) //all on the aer at roundstart
  build_path = /obj/item/weapon/circuitboard/machine/ion_cannon
  category = list("Ship Weaponry")
