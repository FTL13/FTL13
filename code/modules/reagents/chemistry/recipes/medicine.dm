
/datum/chemical_reaction/leporazine
	name = "Leporazine"
	id = "leporazine"
	results = list("leporazine" = 2)
	required_reagents = list("silicon" = 1, "copper" = 1)
	required_catalysts = list("plasma" = 5)
	mix_message = "The reagents grind together to form a light pink paste."

/datum/chemical_reaction/rezadone
	name = "Rezadone"
	id = "rezadone"
	results = list("rezadone" = 3)
	required_reagents = list("carpotoxin" = 1, "cryptobiolin" = 1, "copper" = 1)
	mix_message = "The mixture hardens into a fishy smelling powder."

/datum/chemical_reaction/spaceacillin
	name = "Spaceacillin"
	id = "spaceacillin"
	results = list("spaceacillin" = 2)
	required_reagents = list("cryptobiolin" = 1, "epinephrine" = 1)
	mix_message = "A light pink precipitate quickly forms from the mixing of the two reagents."

/datum/chemical_reaction/inacusiate
	name = "inacusiate"
	id = "inacusiate"
	results = list("inacusiate" = 2)
	required_reagents = list("water" = 1, "carbon" = 1, "charcoal" = 1)
	mix_message = "A pitch black paste forms from the mixing of the reagents."

/datum/chemical_reaction/synaptizine
	name = "Synaptizine"
	id = "synaptizine"
	results = list("synaptizine" = 3)
	required_reagents = list("sugar" = 1, "lithium" = 1, "water" = 1)
	mix_message = "A small red flame dances across the surface of the solution, leaving behind a pink powder."

/datum/chemical_reaction/charcoal
	name = "Charcoal"
	id = "charcoal"
	results = list("charcoal" = 2)
	required_reagents = list("ash" = 1, "sodiumchloride" = 1)
	mix_message = "A flickering orange fire quickly burns away the reagents, leaving behind a dusty black powder."
	required_temp = 380

/datum/chemical_reaction/silver_sulfadiazine
	name = "Silver Sulfadiazine"
	id = "silver_sulfadiazine"
	results = list("silver_sulfadiazine" = 5)
	required_reagents = list("ammonia" = 1, "silver" = 1, "sulfur" = 1, "oxygen" = 1, "chlorine" = 1)
	mix_message = "A faintly purple powder collects at the bottom of the container."

/datum/chemical_reaction/salglu_solution
	name = "Saline-Glucose Solution"
	id = "salglu_solution"
	results = list("salglu_solution" = 3)
	required_reagents = list("sodiumchloride" = 1, "water" = 1, "sugar" = 1)
	mix_message = "After a quick stir, a clear solution forms."

/datum/chemical_reaction/mine_salve
	name = "Miner's Salve"
	id = "mine_salve"
	results = list("mine_salve" = 3)
	required_reagents = list("oil" = 1, "water" = 1, "iron" = 1)

/datum/chemical_reaction/mine_salve2
	name = "Miner's Salve"
	id = "mine_salve"
	results = list("mine_salve" = 15)
	required_reagents = list("plasma" = 5, "iron" = 5, "sugar" = 1) // A sheet of plasma, a twinkie and a sheet of metal makes four of these

/datum/chemical_reaction/synthflesh
	name = "Synthflesh"
	id = "synthflesh"
	results = list("synthflesh" = 3)
	required_reagents = list("blood" = 1, "carbon" = 1, "styptic_powder" = 1)
	mix_message = "The mixture quickly solidifies into a skin colored mass."

/datum/chemical_reaction/styptic_powder
	name = "Styptic Powder"
	id = "styptic_powder"
	results = list("styptic_powder" = 4)
	required_reagents = list("aluminium" = 1, "hydrogen" = 1, "oxygen" = 1, "sacid" = 1)
	mix_message = "The solution yields an astringent powder."

/datum/chemical_reaction/calomel
	name = "Calomel"
	id = "calomel"
	results = list("calomel" = 2)
	required_reagents = list("mercury" = 1, "chlorine" = 1)
	mix_message = "Upon heating, the mixture transforms into a sour smelling sludge."
	required_temp = 374

/datum/chemical_reaction/potass_iodide
	name = "Potassium Iodide"
	id = "potass_iodide"
	results = list("potass_iodide" = 2)
	required_reagents = list("potassium" = 1, "iodine" = 1)
	mix_message = "A bright green fluid collects at the bottom of the container."

/datum/chemical_reaction/pen_acid
	name = "Pentetic Acid"
	id = "pen_acid"
	results = list("pen_acid" = 6)
	required_reagents = list("welding_fuel" = 1, "chlorine" = 1, "ammonia" = 1, "formaldehyde" = 1, "sodium" = 1, "cyanide" = 1)
	mix_message = "An increasing acidic smell wafts from the container."

/datum/chemical_reaction/sal_acid
	name = "Salicyclic Acid"
	id = "sal_acid"
	results = list("sal_acid" = 5)
	required_reagents = list("sodium" = 1, "phenol" = 1, "carbon" = 1, "oxygen" = 1, "sacid" = 1)
	mix_message = "The mixture forms a bubbling opaque gray solution."

/datum/chemical_reaction/oxandrolone
	name = "Oxandrolone"
	id = "oxandrolone"
	results = list("oxandrolone" = 6)
	required_reagents = list("carbon" = 3, "phenol" = 1, "hydrogen" = 1, "oxygen" = 1)
	mix_message = "After mixing, the solution clears to become a light yellow liquid."

/datum/chemical_reaction/salbutamol
	name = "Salbutamol"
	id = "salbutamol"
	results = list("salbutamol" = 5)
	required_reagents = list("sal_acid" = 1, "lithium" = 1, "aluminium" = 1, "bromine" = 1, "ammonia" = 1)
	mix_message = "A light blue mixture quickly forms upon mixing."

/datum/chemical_reaction/perfluorodecalin
	name = "Perfluorodecalin"
	id = "perfluorodecalin"
	results = list("perfluorodecalin" = 3)
	required_reagents = list("hydrogen" = 1, "fluorine" = 1, "oil" = 1)
	required_temp = 370
	mix_message = "The mixture rapidly turns into a dense pink liquid."

/datum/chemical_reaction/ephedrine
	name = "Ephedrine"
	id = "ephedrine"
	results = list("ephedrine" = 4)
	required_reagents = list("sugar" = 1, "oil" = 1, "hydrogen" = 1, "diethylamine" = 1)
	mix_message = "The solution fizzes and gives off toxic fumes."

/datum/chemical_reaction/diphenhydramine
	name = "Diphenhydramine"
	id = "diphenhydramine"
	results = list("diphenhydramine" = 4)
	required_reagents = list("oil" = 1, "carbon" = 1, "bromine" = 1, "diethylamine" = 1, "ethanol" = 1)
	mix_message = "The mixture dries into a pale blue powder."

/datum/chemical_reaction/oculine
	name = "Oculine"
	id = "oculine"
	results = list("oculine" = 3)
	required_reagents = list("charcoal" = 1, "carbon" = 1, "hydrogen" = 1)
	mix_message = "The mixture sputters loudly and becomes a pale pink color."

/datum/chemical_reaction/atropine
	name = "Atropine"
	id = "atropine"
	results = list("atropine" = 5)
	required_reagents = list("ethanol" = 1, "acetone" = 1, "diethylamine" = 1, "phenol" = 1, "sacid" = 1)
	mix_message = "A pitch black liquid forms from the mixture."

/datum/chemical_reaction/epinephrine
	name = "Epinephrine"
	id = "epinephrine"
	results = list("epinephrine" = 6)
	required_reagents = list("phenol" = 1, "acetone" = 1, "diethylamine" = 1, "oxygen" = 1, "chlorine" = 1, "hydrogen" = 1)
	mix_message = "A faintly blue compound forms within the mixture."

/datum/chemical_reaction/strange_reagent
	name = "Strange Reagent"
	id = "strange_reagent"
	results = list("strange_reagent" = 3)
	required_reagents = list("omnizine" = 1, "holywater" = 1, "mutagen" = 1)
	mix_message = "An unassuming green liquid seems to appear where the reagents once were."

/datum/chemical_reaction/mannitol
	name = "Mannitol"
	id = "mannitol"
	results = list("mannitol" = 3)
	required_reagents = list("sugar" = 1, "hydrogen" = 1, "water" = 1)
	mix_message = "The solution slightly bubbles, becoming thicker."

/datum/chemical_reaction/mutadone
	name = "Mutadone"
	id = "mutadone"
	results = list("mutadone" = 3)
	required_reagents = list("mutagen" = 1, "acetone" = 1, "bromine" = 1)
	mix_message = "An acidic blue powder precipitates from the solution."

/datum/chemical_reaction/antihol
	name = "antihol"
	id = "antihol"
	results = list("antihol" = 3)
	required_reagents = list("ethanol" = 1, "charcoal" = 1, "copper" = 1)
	mix_message = "A slimy blue fluid gathers at the bottom."

/datum/chemical_reaction/cryoxadone
	name = "Cryoxadone"
	id = "cryoxadone"
	results = list("cryoxadone" = 3)
	required_reagents = list("stable_plasma" = 1, "acetone" = 1, "mutagen" = 1)
	mix_message = "A deep blue liquid forms from the mixture."

/datum/chemical_reaction/clonexadone
	name = "Clonexadone"
	id = "clonexadone"
	results = list("clonexadone" = 2)
	required_reagents = list("cryoxadone" = 1, "sodium" = 1)
	required_catalysts = list("plasma" = 5)
	mix_message = "A deep blue powder forms from the evaporated mixture."

/datum/chemical_reaction/haloperidol
	name = "Haloperidol"
	id = "haloperidol"
	results = list("haloperidol" = 5)
	required_reagents = list("chlorine" = 1, "fluorine" = 1, "aluminium" = 1, "potass_iodide" = 1, "oil" = 1)
	mix_message = "The mixture slowly changes color to become predominantly green."

/datum/chemical_reaction/bicaridine
	name = "Bicaridine"
	id = "bicaridine"
	results = list("bicaridine" = 3)
	required_reagents = list("carbon" = 1, "oxygen" = 1, "sugar" = 1)
	mix_message = "The mixture bubbles before calming down into a vaguely pink solution."

/datum/chemical_reaction/kelotane
	name = "Kelotane"
	id = "kelotane"
	results = list("kelotane" = 2)
	required_reagents = list("carbon" = 1, "silicon" = 1)
	mix_message = "A pink liquid pools at the bottom of the container."

/datum/chemical_reaction/antitoxin
	name = "Antitoxin"
	id = "antitoxin"
	results = list("antitoxin" = 3)
	required_reagents = list("nitrogen" = 1, "silicon" = 1, "potassium" = 1)
	mix_message = "The mixture pops and a fizzles to life."

/datum/chemical_reaction/tricordrazine
	name = "Tricordrazine"
	id = "tricordrazine"
	results = list("tricordrazine" = 3)
	required_reagents = list("bicaridine" = 1, "kelotane" = 1, "antitoxin" = 1)
	mix_message = "The mixture passes through various colors of the rainbow before settling on a light pink."

/datum/chemical_reaction/corazone
	name = "Corazone"
	id = "corazone"
	results = list("corazone" = 3)
	required_reagents = list("phenol" = 2, "lithium" = 1)
	mix_message = "A distinctly white powder floats to the top of the mixture."
