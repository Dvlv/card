extends "res://scripts/SlotContainer.gd"

func add_opponent_card(card_res):
	var next_empty_slot = get_next_empty_slot(true)
	if not next_empty_slot:
		return false

	next_empty_slot.add_card(card_res, true)
	return true


func add_player_card(card_res):
	var next_empty_slot = get_next_empty_slot(false)
	if not next_empty_slot:
		return false

	next_empty_slot.add_card(card_res, false)
	return true


func get_next_empty_slot(is_opponent):
	var slots_container = null
	if is_opponent:
		slots_container = $BoardBackground/OpponentSlots
	else:
		slots_container = $BoardBackground/PlayerSlots

	for board_slot in slots_container.get_children():
		if not board_slot.get_card():
			return board_slot

	return null


func get_next_active_opponent_creature():
	if get_opponent_card_count() == 0:
		return null

	for board_slot in $BoardBackground/OpponentSlots.get_children():
		var card = board_slot.get_card()
		if card and not card.is_inactive:
			return card

	return null


func get_player_creatures():
	var player_creatures = []
	for board_slot in $BoardBackground/PlayerSlots.get_children():
		if board_slot.get_card():
			player_creatures.append(board_slot.get_card())

	return player_creatures


func get_opponent_card_count():
	var count = 0
	for board_slot in $BoardBackground/OpponentSlots.get_children():
		if board_slot.get_card():
			count += 1

	return count


func get_opponent_only_card():
	for board_slot in $BoardBackground/OpponentSlots.get_children():
		if board_slot.get_card():
			return board_slot.get_card()


func set_all_cards_active():
	for board_slot in $BoardBackground/OpponentSlots.get_children():
		if board_slot.get_card():
			board_slot.get_card().set_active()

	for board_slot in $BoardBackground/PlayerSlots.get_children():
		if board_slot.get_card():
			board_slot.get_card().set_active()


func connect_active_signal_to_all_children(logic):
	for child in $BoardBackground/PlayerSlots.get_children():
		child.connect_active_signal(logic)

	for child in $BoardBackground/OpponentSlots.get_children():
		child.connect_active_signal(logic)


func connect_attack_signal_to_all_children(logic):
	for child in $BoardBackground/PlayerSlots.get_children():
		child.connect_attack_signal(logic)


func connect_opponent_select_signals(logic, callback):
	for child in $BoardBackground/OpponentSlots.get_children():
		child.connect_select_signal(logic, callback)


func disconnect_opponent_select_signals(logic, callback):
	for child in $BoardBackground/OpponentSlots.get_children():
		child.disconnect_select_signal(logic, callback)


func close_all_menus():
	for child in $BoardBackground/PlayerSlots.get_children():
		child.close_card_menu()

	for child in $BoardBackground/OpponentSlots.get_children():
		child.close_card_menu()


func add_card():
	print("Do not use add_card for the board, use add_opponent_card or add_player_card")


func _on_Button_pressed():
	var hand = $Hand
	var owl_card_scene = load("res://scenes/creaturecards/Owl.tscn")
	var owl_instance = owl_card_scene.instance()
	if not hand.add_card(owl_instance.CARD_RESOURCE):
		add_opponent_card(owl_instance.CARD_RESOURCE)