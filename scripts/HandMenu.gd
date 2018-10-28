extends Node2D

signal card_played


func _on_Cancel_pressed():
	visible = false


func _on_Play_pressed():
	get_parent().play_card()


func _on_Fuse_pressed():
	get_parent().add_card_to_fusebox()