extends Node2D

func add_opponent_card(card):
	var next_empty_slot = get_next_empty_card_slot(true)
	if not next_empty_slot:
		return false
		
	next_empty_slot.add_card(card)
	return true

func add_player_card(card):
	var next_empty_slot = get_next_empty_card_slot()
	if not next_empty_slot:
		return false
		
	next_empty_slot.add_card(card)
	return true
	
func get_next_empty_card_slot(is_opponent):
	var slots_container = null
	if is_opponent:
		slots_container = $OpponentSlots
	else:
		slots_container = $PlayerSlots
		
	for board_slot in slots_container.children:
		if not board_slot.get_card():
			return board_slot
			
	return null
	

	