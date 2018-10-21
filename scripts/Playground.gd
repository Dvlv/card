extends Node2D


func _ready():
	var owl = load("res://resources/Owl.tres")
	var bear = load("res://resources/Bear.tres")
	var bna = load("res://resources/BowAndArrow.tres")
	var fire = load("res://resources/Fire.tres")
	
	var deck = [owl, bear, bear, bna, owl, fire,]
	
	$MatchLogic.set_deck(deck)
	$MatchLogic.fill_hand()
	
	$MatchLogic.add_to_opponent_board(owl)
	$MatchLogic.add_to_opponent_board(bear)


