extends Node2D

signal damage_opponent
signal damage_player
signal damage_opponent_card
signal select_opponent_card
signal select_own_card
signal declare_attack

func attack():
	emit_signal("declare_attack")
	
func effect():
	pass