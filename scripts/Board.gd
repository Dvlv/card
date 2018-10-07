extends Node2D

func add_opponent_card(card):
	var next_empty_slot = get_next_empty_card_slot(true)
	if not next_empty_slot:
		return false
		
	next_empty_slot.add_card(card.CARD_RESOURCE)
	return true

func add_player_card(card):
	var next_empty_slot = get_next_empty_card_slot(false)
	if not next_empty_slot:
		return false
		
	next_empty_slot.add_card(card.CARD_RESOURCE)
	return true
	
func get_next_empty_card_slot(is_opponent):
	var slots_container = null
	if is_opponent:
		slots_container = $BoardBackground/OpponentSlots
	else:
		slots_container = $BoardBackground/PlayerSlots
		
	for board_slot in slots_container.get_children():
		if not board_slot.get_card():
			return board_slot
			
	return null
	



func _on_Button_pressed():
	var hand = $Hand
	var owl_card_scene = load("res://scenes/creaturecards/Owl.tscn")
	var owl_instance = owl_card_scene.instance()
	if not hand.add_card(owl_instance):
		add_opponent_card(owl_instance)