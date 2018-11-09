extends "res://scripts/card_functionality/card_functionality_base.gd"

func _ready():
	has_effect = true
	can_attack_after_effect = true


func effect():
	emit_signal("buff_same_element", 1, 0)