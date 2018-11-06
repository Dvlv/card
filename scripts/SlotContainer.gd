extends Node2D

func add_card(card_res, is_opponent):
	var slot = get_next_empty_slot()
	if slot:
		slot.add_card(card_res, is_opponent)

		return true

	return false

func get_next_empty_slot():
	for child in get_children():
		if not child.get_card():
			return child

	return null

func close_all_menus():
	for child in get_children():
		child.close_card_menu()

func connect_active_signal_to_all_children(logic):
	for child in get_children():
		child.connect_active_signal(logic)
