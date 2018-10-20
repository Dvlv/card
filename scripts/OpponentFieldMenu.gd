extends Node2D

func _on_Cancel_pressed():
	visible = false


func _on_Select_pressed():
	get_parent().emit_card_selected()
