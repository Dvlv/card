extends Node2D

signal card_output

var CARDS = []

func add_card(card):
	CARDS.append(card)

func fuse():
	pass
	
func output(result):
	# add result to board
	self.CARDS = []
	emit_signal("card_output", result)
	
func remove_card(card):
	CARDS.remove(card)