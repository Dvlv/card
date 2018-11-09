extends Node2D

signal damage_opponent
signal damage_player
signal damage_opponent_card
signal select_opponent_card
signal select_own_card
signal declare_attack
signal buff_same_element
signal go_inactive

var has_effect = false
var can_attack_after_effect = false


func _ready():
	pass


func attack():
	emit_signal("declare_attack")


func post_attack():
	pass


func effect():
	pass


func post_effect():
	if not can_attack_after_effect:
		emit_signal("go_inactive")

