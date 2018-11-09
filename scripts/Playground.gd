extends Node2D


var owl = preload("res://resources/Owl.tres")
var bear = preload("res://resources/Bear.tres")
var bna = preload("res://resources/BowAndArrow.tres")
var fire = preload("res://resources/Fire.tres")
var fire_dragon = preload("res://resources/FireDragon.tres")
var electric_dragon = preload("res://resources/ElectricDragon.tres")


func _ready():
	$MatchLogic.connect("player_turn_ended", self, "on_player_turn_ended")

	$AttackAI.connect("opponent_attacks_face", $MatchLogic, "on_opponent_attacks_face")
	$AttackAI.connect("opponent_attacks_creature", $MatchLogic, "on_opponent_attacks_creature")



	var deck = [owl, bear, bear, bna, electric_dragon, electric_dragon, electric_dragon, electric_dragon]

	$MatchLogic.set_deck(deck)
	$MatchLogic.fill_hand()

	#$MatchLogic.add_to_opponent_board(owl)
	#$MatchLogic.add_to_opponent_board(bear)


func on_player_turn_ended(turn_number):
	var turn_method_func = "do_turn_" + str(turn_number)
	if has_method(turn_method_func):
		call(turn_method_func)
	else:
		final_turn_method()

	attack_with_all_creatures()


func attack_with_all_creatures():
	if $MatchLogic.get_next_active_opponent_creature():
		if not $MatchLogic.is_connected("opponent_attack_finished", self, "attack_with_all_creatures"):
			$MatchLogic.connect("opponent_attack_finished", self, "attack_with_all_creatures")

		var player_creatures = $MatchLogic.get_player_creatures()
		var my_creature = $MatchLogic.get_next_active_opponent_creature()

		$AttackAI.perform_attack(my_creature, player_creatures)
	else:
		$MatchLogic.disconnect("opponent_attack_finished", self, "attack_with_all_creatures")
		$MatchLogic.begin_next_turn()


func do_turn_1():
	$MatchLogic.add_to_opponent_board(bear)


func final_turn_method():
	# will call AI for attacks here
	pass
