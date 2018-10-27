extends "res://scripts/Slot.gd"



func set_location(card_rep):
	card_rep.set_in_hand()


func connect_play_signal(logic):
	if my_card and not my_card.is_connected("card_played", logic, "play_card"):
		my_card.connect("card_played", logic, "play_card")


func connect_fuse_signal(logic):
	if my_card and not my_card.is_connected("card_added_to_fusebox", logic, "add_card_to_fusebox"):
		my_card.connect("card_added_to_fusebox", logic, "add_card_to_fusebox")