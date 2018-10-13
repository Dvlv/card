extends Node2D

var my_card = null

onready var card_rep_scene = preload("res://scenes/CardRepresentation.tscn")

func add_card(card_res):
	if not my_card:
		var card_rep = card_rep_scene.instance()
		card_rep.CARD_RESOURCE = card_res
		card_rep.position = Vector2(0,0)
		set_location(card_rep)
		add_child(card_rep)
		my_card = card_rep
		card_rep.my_slot = self
		
	else:
		print("adding card to full slot. Oops!")

func get_card():
	return my_card
	
func remove_card():
	if my_card:
		my_card.queue_free()
		my_card = null
		
func close_card_menu():
	if my_card:
		my_card.close_menus()
		
func connect_active_signal(logic):
	if my_card:
		my_card.connect("active_card", logic, "update_active_card")
		

	
