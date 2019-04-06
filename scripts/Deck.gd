extends Node2D

var cards = []


func shuffle():
	randomize()
	cards.shuffle()

func draw():
	return cards.pop_front()

func add_card(card_res):
	cards.append(card_res)