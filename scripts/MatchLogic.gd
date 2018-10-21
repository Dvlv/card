extends Node2D


func set_deck(deck_card_resources):
	for res in deck_card_resources:
		$Deck.add_card(res)
		$Deck.shuffle()


func fill_hand():
	while $Hand.get_next_empty_slot():
		$Hand.add_card($Deck.draw(), false)
	connect_all_hand_card_reps()


func connect_all_hand_card_reps():
	$Hand.connect_active_signal_to_all_children(self)
	$Hand.connect_play_signal_to_all_children(self)


func connect_all_board_card_reps():
	$Board.connect_active_signal_to_all_children(self)
	$Board.connect_attack_signal_to_all_children(self)


func update_active_card(card_res):
	$Hand.close_all_menus()
	$Board.close_all_menus()
	$ActiveCard.set_new_resource(card_res)


func play_card(slot):
	var card_in_slot = slot.get_card()
	slot.remove_card()
	$Board.add_player_card(card_in_slot.CARD_RESOURCE)
	connect_all_board_card_reps()


func do_card_battle(player_card, opp_card):
	$Hand.close_all_menus()
	$Board.close_all_menus()
	opp_card.take_damage(player_card.CARD_RESOURCE.POWER)
	player_card.take_damage(opp_card.CARD_RESOURCE.POWER)


func post_attack(attacking_card_rep):
	attacking_card_rep.set_inactive()


func damage_opponent(dmg):
	print("opponent takes ", dmg, " damage")


func on_damage_opponent_card(dmg):
	print("damaging card for", dmg)


func on_damage_opponent(dmg):
	print("damaging opponent for ", dmg)
	damage_opponent(dmg)


func on_card_selected_for_attack(opp_card):
	do_card_battle(globals.card_attacking, opp_card)
	$Board.disconnect_opponent_select_signals(self, "on_card_selected_for_attack")
	
	post_attack(globals.card_attacking)
	globals.is_in_attack_choose_state = false
	globals.card_attacking = null


func on_declare_attack(attacker_card_rep):
	var opponent_creature_count = $Board.get_opponent_card_count() 
	if opponent_creature_count < 1:
		damage_opponent(attacker_card_rep.CARD_RESOURCE.POWER)
		post_attack(attacker_card_rep)
	elif opponent_creature_count == 1:
		var opponent_creature_card_rep = $Board.get_opponent_only_card()
		do_card_battle(attacker_card_rep, opponent_creature_card_rep)
		post_attack(attacker_card_rep)
	else:
		globals.is_in_attack_choose_state = true
		globals.card_attacking = attacker_card_rep
		$Board.connect_opponent_select_signals(self, "on_card_selected_for_attack")
		




func add_to_opponent_board(card_res):
	$Board.add_opponent_card(card_res)
