extends "res://scripts/card_functionality/card_functionality_base.gd"


func effect():
	emit_signal("damage_opponent_card", 5)