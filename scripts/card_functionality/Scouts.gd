extends "res://scripts/card_functionality/card_functionality_base.gd"

func _ready():
	has_effect = true


func effect():
	emit_signal("damage_opponent", 2)