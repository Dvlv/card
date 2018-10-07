extends Node2D

func add_card(card_res):
	var slot = get_next_empty_slot()
	if slot:
		slot.add_card(card_res)
		
		return true
	
	return false
	
func get_next_empty_slot():
	for child in get_children():
		if not child.get_card():
			return child
		
	return null
