extends Node2D

var is_in_attack_choose_state = false
var card_attacking = null
var card_defending = null
var player_defending = null
var effect_dmg = 0
var player_is_attacker = false
var card_effecting = null

func reset_all():
	is_in_attack_choose_state = false
	card_attacking = null
	card_defending = null
	player_defending = null
	effect_dmg = 0
	player_is_attacker = false
	card_effecting = null


func get_turn_number():
	var logic = get_tree().get_root().find_node("MatchLogic", true, false)
	
	return logic.turn_number
	