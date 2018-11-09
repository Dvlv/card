extends "res://scripts/card_functionality/card_functionality_base.gd"


func post_attack():
	emit_signal("damage_opponent", 1)
