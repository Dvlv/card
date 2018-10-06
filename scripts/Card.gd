extends Node2D

enum TYPES { Creature, Equip, Element, }
enum ELEMENTS { Plain, Fire, Air, Earth, Water, Electricity, }
enum FACTIONS { None, Forest, Orc, Human, Sea, Pole }
enum CREATURE_TYPE { NotCreature, Bird, Bear, Fish, Magic, Melee, Passive, Aggressive }

export(Texture) var CARD_IMAGE = null
export(TYPES) var CARD_TYPE = TYPES.Creature
export(String) var CARD_TEXT = "Card Text"

export(int) var POWER = 0
export(int) var HP = 0

export(ELEMENTS) var CARD_ELEMENT = ELEMENTS.Plain
export(FACTIONS) var CARD_FACTION = FACTIONS.None
export(CREATURE_TYPE) var CARD_CREATURE_TYPE = CREATURE_TYPE.NotCreature


func _ready():
	$CardImage.texture = CARD_IMAGE
	$CardText.text = CARD_TEXT
	
	$CardPower.text = str(POWER) if POWER > 0 else ""
	$CardHP.text = str(HP) if HP > 0 else ""
	
	_set_card_background()

func move_to_fuse_box():
	pass
	
func on_play():
	pass
	
func on_destroy():
	pass
	
func on_attack():
	pass
	
func on_receive_damage():
	pass
	
func on_attacked():
	pass
	
func _set_card_background():
	if CARD_TYPE == TYPES.Creature:
		$Background.texture = load("res://assets/cards/creature.png")
	elif CARD_TYPE == TYPES.Equip:
		$Background.texture = load("res://assets/cards/equip.png")
	elif CARD_TYPE == TYPES.Element:
		$Background.texture = load("res://assets/cards/element.png")
	