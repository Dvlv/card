extends Node2D



static func create(card_resource):
	var creature_card_rep_scene = preload("res://scenes/CreatureCardRepresentation.tscn")
	var equip_card_rep_scene = preload("res://scenes/EquipCardRepresentation.tscn")
	var element_card_rep_scene = preload("res://scenes/ElementCardRepresentation.tscn")
	
	var rep = null
	
	if card_resource.CARD_TYPE == card_resource.TYPES.Creature:
		rep = creature_card_rep_scene.instance()
	elif card_resource.CARD_TYPE == card_resource.TYPES.Equip:
		rep = equip_card_rep_scene.instance()
	else:
		rep = element_card_rep_scene.instance()
		
	rep.CARD_RESOURCE = card_resource
	return rep