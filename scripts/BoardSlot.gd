extends Node2D

var my_card = null

func add_card(card):
	if not my_card:
		my_card = card
	else:
		print("adding card to full slot. Oops!")

func get_card():
	return my_card