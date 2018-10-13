extends Node2D


func _ready():
	pass
	
func set_deck(deck_card_resources):
	for res in deck_card_resources:
		$Deck.add_card(res)
		$Deck.shuffle()
		
func fill_hand():
	while $Hand.get_next_empty_slot():
		$Hand.add_card($Deck.draw())
	connect_all_hand_card_reps()

func connect_all_hand_card_reps():
	$Hand.connect_active_signal_to_all_children(self)
	$Hand.connect_play_signal_to_all_children(self)
	
func connect_all_board_card_reps():
	$Board.connect_active_signal_to_all_children(self)
	
func update_active_card(card_res):
	$Hand.close_all_menus()
	$Board.close_all_menus()
	$ActiveCard.set_new_resource(card_res)
	
func play_card(slot):
	var card_in_slot = slot.get_card()
	slot.remove_card()
	$Board.add_player_card(card_in_slot.CARD_RESOURCE)
	connect_all_board_card_reps()

