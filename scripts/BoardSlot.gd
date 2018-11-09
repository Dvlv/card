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

	if my_card and not my_card.is_connected("buff_same_element", logic, "on_buff_same_element"):
		my_card.connect("buff_same_element", logic, "on_buff_same_element")


func connect_select_signal(logic, callback):
	if my_card and not my_card.is_connected("card_selected", logic, callback):
		my_card.connect("card_selected", logic, callback)


func disconnect_select_signal(logic, callback):
	if my_card and my_card.is_connected("card_selected", logic, callback):
		my_card.disconnect("card_selected", logic, callback)


func buff_same_element(element, power, hp):
	if my_card and my_card.CARD_RESOURCE.CARD_ELEMENT == element:
		my_card.buff(power, hp)