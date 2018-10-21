extends Node2D

func _on_Cancel_pressed():
	visible = false


func _on_Attack_pressed():
	visible = false
	get_parent().attack()


func _on_Effect_pressed():
	get_parent().effect()
