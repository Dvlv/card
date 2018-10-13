extends "res://scripts/Slot.gd"



func set_location(card_rep):
	card_rep.set_in_hand()


func connect_play_signal(logic):
	if my_card:
		my_card.connect("card_played", logic, "play_card")