extends "res://scripts/CardRepresentation.gd"

signal card_selected
signal damage_opponent_card
signal damage_opponent
signal declare_attack


var is_inactive = false


func _ready():
	connect_attack_and_effect_signals()


func _on_TextureButton_pressed():
	emit_signal("active_card", CARD_RESOURCE)
	
	if not is_inactive:
		if is_on_field and not is_opponent_card:
			$FieldMenu.visible = true
		elif is_on_field and is_opponent_card and globals.is_in_attack_choose_state:
			$OpponentFieldMenu.visible = true
		elif is_in_hand:
			$HandMenu.visible = true


func get_power():
	return CARD_RESOURCE.POWER
	
func get_hp():
	return CARD_RESOURCE.HP


func connect_attack_and_effect_signals():
	var my_card_script = CARD_RESOURCE.SCRIPT_FILE if CARD_RESOURCE.SCRIPT_FILE else load("res://scripts/card_functionality/card_functionality_base.gd")
	
	my_card_script_node.set_script(my_card_script)
	my_card_script_node.connect("damage_opponent_card", self, "emit_damage_opponent_card")
	my_card_script_node.connect("damage_opponent", self, "emit_damage_opponent")
	my_card_script_node.connect("declare_attack", self, "emit_declare_attack")


func set_inactive():
	is_inactive = true
	$TextureButton.modulate = "333333"


func set_active():
	is_inactive = false
	$TextureButton.modulate = "ffffff"


func play_card():
	emit_signal("card_played", my_slot)
	
	
func emit_damage_opponent_card(dmg):
	emit_signal("damage_opponent_card", self, dmg)


func emit_damage_opponent(dmg):
	emit_signal("damage_opponent", dmg)


func emit_declare_attack():
	emit_signal("declare_attack", self)
	

func emit_card_selected():
	emit_signal("card_selected", self)


func attack():
	if my_card_script_node.get_script():
		my_card_script_node.attack()


func effect():
	if my_card_script_node.get_script():
		my_card_script_node.effect()


func take_damage(dmg):
	CARD_RESOURCE.HP -= dmg
	set_card_power_and_health()
	if CARD_RESOURCE.HP < 1:
		if my_slot:
			my_slot.remove_card()
		else:
			CARD_RESOURCE.queue_free()
			queue_free()


func heal(healing):
	CARD_RESOURCE.HP += healing
	set_card_power_and_health()