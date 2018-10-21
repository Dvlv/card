extends Node2D

signal player_lose


export(bool) var is_opponent = false

var HP = 20


func set_hp(hp):
	HP = hp
	$Label.text = str(HP)


func take_dmg(dmg):
	set_hp(HP - dmg)
	if HP < 1:
		emit_signal("player_lose", is_opponent)


func heal(healing):
	set_hp(HP + healing)
