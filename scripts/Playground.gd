extends Node2D


func _ready():
	var owl = load("res://resources/Owl.tres")
	var bear = load("res://resources/Bear.tres")
	var bna = load("res://resources/BowAndArrow.tres")
	var fire = load("res://resources/Fire.tres")
	
	var deck = [owl, bear, bna, fire, owl, owl, owl, owl, bear, bear, bear, bear, bear, bear, bna, bna, bna, fire,
	fire]
	
	$MatchLogic.set_deck(deck)
	$MatchLogic.fill_hand()
	
	$MatchLogic.add_to_opponent_board(owl)
	$MatchLogic.add_to_opponent_board(bear)


