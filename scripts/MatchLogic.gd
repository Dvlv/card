extends Node2D

signal player_turn_ended
signal opponent_attack_finished

var turn_number = 1

onready var attack_anim_player = $AttackAnim/AnimationPlayer


func _ready():
	$Opponent.connect("player_lose", self, "on_player_lose")
	$Player.connect("player_lose", self, "on_player_lose")
	$FuseBox.connect("card_output", self, "on_fusebox_card_output")



func set_deck(deck_card_resources):
	for res in deck_card_resources:
		$Deck.add_card(res)
		$Deck.shuffle()


func fill_hand():
	while $Hand.get_next_empty_slot():
		var card = $Deck.draw()
		if not card:
			on_player_lose()
			break
		else:
			$Hand.add_card(card, false)
			connect_all_hand_card_reps()


func connect_all_hand_card_reps():
	$Hand.connect_active_signal_to_all_children(self)
	$Hand.connect_play_signal_to_all_children(self)
	$Hand.connect_fuse_signal_to_all_children(self)


func connect_all_board_card_reps():
	$Board.connect_active_signal_to_all_children(self)
	$Board.connect_attack_signal_to_all_children(self)


func connect_remove_to_all_fusebox_reps():
	$FuseBox.connect_remove_signal_to_all_cards(self)


func update_active_card(card_res):
	$Hand.close_all_menus()
	$Board.close_all_menus()
	$ActiveCard.set_new_resource(card_res)


func disconnect_anim_player():
	if attack_anim_player.is_connected("animation_finished", self, "post_do_attack_face"):
		attack_anim_player.disconnect("animation_finished", self, "post_do_attack_face")

	if attack_anim_player.is_connected("animation_finished", self, "post_do_battle"):
		attack_anim_player.disconnect("animation_finished", self, "post_do_battle")


func play_card(slot):
	var card_in_slot = slot.get_card()
	slot.remove_card()
	$Board.add_player_card(card_in_slot.CARD_RESOURCE)
	connect_all_board_card_reps()
	hide_hand()


func hide_hand():
	$Hand.visible = false


func add_card_to_fusebox(slot):
	var card_in_slot = slot.get_card()
	slot.remove_card()
	$FuseBox.add_card(card_in_slot.CARD_RESOURCE)
	connect_remove_to_all_fusebox_reps()


func pre_attack(attacker_card, player_is_attacker):
	$Hand.close_all_menus()
	$Board.close_all_menus()
	attacker_card.set_attacking_state()
	globals.card_attacking = attacker_card
	globals.player_is_attacker = player_is_attacker


func do_attack_face(attacker_card, player_is_attacker=false):
	pre_attack(attacker_card, player_is_attacker)

	$AttackAnim.position = attacker_card.get_center_of_button()
	attack_anim_player.connect("animation_finished", self, "post_do_attack_face")

	var anim = "backward"

	if player_is_attacker:
		anim = "forward"

	$AttackAnim/AnimationPlayer.play(anim)

func post_do_attack_face(anim):
	disconnect_anim_player()
	globals.player_defending.take_dmg(globals.card_attacking.get_power())

	post_attack()


func do_card_battle(attacker_card, defender_card, player_is_attacker=false):
	pre_attack(attacker_card, player_is_attacker)
	globals.card_defending = defender_card

	$AttackAnim.position = attacker_card.get_center_of_button()
	attack_anim_player.connect("animation_finished", self, "post_do_battle")

	var anim = "backward"

	if player_is_attacker:
		anim = "forward"

	$AttackAnim/AnimationPlayer.play(anim)


func post_do_battle(anim):
	disconnect_anim_player()
	globals.card_defending.take_damage(globals.card_attacking.get_power())
	globals.card_attacking.take_damage(globals.card_defending.get_power())

	post_attack()


func post_attack():
	globals.card_attacking.post_attack()
	var player_attacked = globals.player_is_attacker
	globals.reset_all()

	if not player_attacked:
		emit_signal("opponent_attack_finished")


func post_effect():
	globals.card_attacking.post_effect()
	globals.reset_all()


func damage_opponent(dmg):
	$Opponent.take_dmg(dmg)

func damage_player(dmg):
	$Player.take_dmg(dmg)


func add_to_opponent_board(card_res):
	$Board.add_opponent_card(card_res)


func begin_next_turn():
	$Board.set_all_cards_active()
	turn_number += 1
	$Hand.visible = true
	fill_hand()



func get_next_active_opponent_creature():
	return $Board.get_next_active_opponent_creature()


func get_player_creatures():
	return $Board.get_player_creatures()


func on_rep_removed_from_fusebox(card_rep):
	$FuseBox.remove_card(card_rep)
	$Hand.add_card(card_rep.CARD_RESOURCE, false)
	connect_all_hand_card_reps()
	card_rep.queue_free()

func on_fusebox_card_output(card_res, fuse_happened):
	if card_res.CARD_TYPE == card_res.TYPES.Creature:
		$Board.add_player_card(card_res)
		connect_all_board_card_reps()
		hide_hand()
	else:
		$Hand.add_card(card_res, false)
		connect_all_hand_card_reps()

	if fuse_happened:
		print("fuse successful")
	else:
		print("no fusion occurred")


func on_player_lose(is_opponent=false):
	if is_opponent:
		print("player_wins")
	else:
		print("opponent_wins")


func on_damage_opponent_card(attacker_card_rep, dmg):
	$Hand.close_all_menus()
	$Board.close_all_menus()

	var opponent_creature_count = $Board.get_opponent_card_count()
	if opponent_creature_count < 1:
		print("no card to damage")
	elif opponent_creature_count == 1:
		var opponent_creature_card_rep = $Board.get_opponent_only_card()
		opponent_creature_card_rep.take_damage(dmg)
		post_effect(attacker_card_rep)
	else:
		globals.is_in_attack_choose_state = true
		globals.card_attacking = attacker_card_rep
		globals.effect_dmg = dmg
		$Board.connect_opponent_select_signals(self, "on_card_selected_for_damage")


func on_damage_opponent(card_using_effect, dmg):
	$Hand.close_all_menus()
	$Board.close_all_menus()

	globals.card_attacking = card_using_effect
	damage_opponent(dmg)
	post_effect()


func on_card_selected_for_attack(opp_card):
	do_card_battle(globals.card_attacking, opp_card, true)
	$Board.disconnect_opponent_select_signals(self, "on_card_selected_for_attack")

func on_card_selected_for_damage(opp_card):
	opp_card.take_damage(globals.effect_dmg)
	$Board.disconnect_opponent_select_signals(self, "on_card_selected_for_damage")
	post_effect()



func on_declare_attack(attacker_card_rep):
	var opponent_creature_count = $Board.get_opponent_card_count()
	if opponent_creature_count < 1:
		globals.player_defending = $Opponent
		do_attack_face(attacker_card_rep, true)
	elif opponent_creature_count == 1:
		var opponent_creature_card_rep = $Board.get_opponent_only_card()
		do_card_battle(attacker_card_rep, opponent_creature_card_rep, true)
	else:
		globals.is_in_attack_choose_state = true
		globals.card_attacking = attacker_card_rep
		$Board.connect_opponent_select_signals(self, "on_card_selected_for_attack")


func on_opponent_attacks_face(creature):
	globals.player_defending = $Player
	do_attack_face(creature, false)


func on_opponent_attacks_creature(attacker, defender):
	do_card_battle(attacker, defender)

func _on_EndTurnButton_pressed():
	emit_signal("player_turn_ended", turn_number)






