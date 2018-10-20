extends "res://scripts/Slot.gd"

func set_location(card_rep):
	card_rep.set_on_field()


func connect_attack_signal(logic):
	if my_card and not my_card.is_connected("damage_opponent_card", logic, "on_damage_opponent_card"):
		my_card.connect("damage_opponent_card", logic, "on_damage_opponent_card")
		
	if my_card and not my_card.is_connected("damage_opponent", logic, "on_damage_opponent"):
		my_card.connect("damage_opponent", logic, "on_damage_opponent")
		
	if my_card and not my_card.is_connected("declare_attack", logic, "on_declare_attack"):
		my_card.connect("declare_attack", logic, "on_declare_attack")