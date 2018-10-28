enum TYPES { Creature, Equip, Element, }
enum ELEMENTS { Plain, Fire, Air, Earth, Water, Electricity, }
enum FACTIONS { None, Forest, Orc, Human, Sea, Pole }
enum CREATURE_TYPE { NotCreature, Bird, Bear, Fish, Magic, Melee, Passive, Aggressive }

export(Script) var SCRIPT_FILE = null

export(String) var CARD_NAME = "Card Name"
export(Texture) var CARD_IMAGE = null
export(TYPES) var CARD_TYPE = TYPES.Creature
export(String) var CARD_TEXT = "Card Text"

export(int) var POWER = 0
export(int) var HP = 0

export(ELEMENTS) var CARD_ELEMENT = ELEMENTS.Plain
export(FACTIONS) var CARD_FACTION = FACTIONS.None
export(CREATURE_TYPE) var CARD_CREATURE_TYPE = CREATURE_TYPE.NotCreature

static func get_element_adjectives():
	return {
	ELEMENTS.Fire: "Flaming",
	ELEMENTS.Air: "Windy",
	ELEMENTS.Earth: "Muddy",
	ELEMENTS.Water: "Tidal",
	ELEMENTS.Electricity: "Shocking",
}


func is_equip():
	return CARD_TYPE == TYPES.Equip


func is_creature():
	return CARD_TYPE == TYPES.Creature


func is_element():
	return CARD_TYPE == TYPES.Element