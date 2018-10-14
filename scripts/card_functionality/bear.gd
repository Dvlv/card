extends "res://scripts/card_functionality/card_functionality_base.gd"

static func attack():
	print("bear attack")
	emit_signal("damage_opponent")