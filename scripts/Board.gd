extends "res://scripts/SlotContainer.gd"

func add_opponent_card(card_res):
	var next_empty_slot = get_next_empty_slot(true)
	if not next_empty_slot:
		return false
		
	next_empty_slot.add_card(card_res)
	return true


func add_player_card(card_res):
	var next_empty_slot = get_next_empty_slot(false)
	if not next_empty_slot:
		return false
		
	next_empty_slot.add_card(card_res)
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
	

func connect_active_signal_to_all_children(logic):
	for child in $BoardBackground/PlayerSlots.get_children():
		child.connect_active_signal(logic)
	
	for child in $BoardBackground/OpponentSlots.get_children():
		child.connect_active_signal(logic)

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