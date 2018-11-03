extends Node2D


var owl = preload("res://resources/Owl.tres")
var bear = preload("res://resources/Bear.tres")
var bna = preload("res://resources/BowAndArrow.tres")
var fire = preload("res://resources/Fire.tres")


func _ready():
	$MatchLogic.connect("player_turn_ended", self, "on_player_turn_ended")
	
	
	
	var deck = [owl, bear, bear, bna, owl, fire, fire, bna, fire, bna, fire, bna]
	
	$MatchLogic.set_deck(deck)
	$MatchLogic.fill_hand()
	
	$MatchLogic.add_to_opponent_board(owl)
	$MatchLogic.add_to_opponent_board(bear)


func on_player_turn_ended(turn_number):
	var turn_method_func = "do_turn_" + str(turn_number)
	if has_method(turn_method_func):
		call(turn_method_func)
	else:
		final_turn_method()
		
	$MatchLogic.begin_next_turn()


func do_turn_1():
	$MatchLogic.add_to_opponent_board(bear)


func final_turn_method():
	# will call AI for attacks here
	pass
	