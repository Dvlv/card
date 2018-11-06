extends Node2D

var cards = []


func shuffle():
	randomize()

	var shuffledList = []
	var indexList = range(cards.size())
	for i in range(cards.size()):
	    var x = randi()%indexList.size()
	    shuffledList.append(cards[indexList[x]])
	    indexList.remove(x)

	cards = shuffledList

func draw():
	return cards.pop_front()

func add_card(card_res):
	cards.append(card_res)