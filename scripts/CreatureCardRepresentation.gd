extends "res://scripts/CardRepresentation.gd"

signal card_selected
signal damage_opponent_card
signal damage_opponent
signal declare_attack
signal buff_same_element
signal heal_self


var is_inactive = false


func _ready():
	connect_attack_and_effect_signals()
	hide_effect_if_none()


func _on_TextureButton_pressed():
	emit_signal("active_card", CARD_RESOURCE)

	if not is_inactive:
		if is_on_field and not is_opponent_card and not globals.get_turn_number() == 1:
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
	my_card_script_node.connect("buff_same_element", self, "emit_buff_same_element")
	my_card_script_node.connect("heal_self", self, "emit_heal_self")
	my_card_script_node.connect("go_inactive", self, "set_inactive")

	my_card_script_node._ready()


func hide_effect_if_none():
	if my_card_script_node.get_script() and not my_card_script_node.has_effect:
		$FieldMenu/Control/VBoxContainer/Effect.visible = false
	elif not my_card_script_node.get_script():
		$FieldMenu/Control/VBoxContainer/Effect.visible = false


func set_attacking_state():
	$TextureButton.modulate = "ff3300"


func set_inactive():
	is_inactive = true
	$TextureButton.modulate = "333333"


func set_active():
	is_inactive = false
	show_effect_button()
	$TextureButton.modulate = "ffffff"


func hide_effect_button():
	$FieldMenu/Control/VBoxContainer/Effect.visible = false


func show_effect_button():
	$FieldMenu/Control/VBoxContainer/Effect.visible = true


func get_center_of_button():
	var origin = $TextureButton.get_global_transform().get_origin()
	origin.x += 70  # half sprite width

	return origin


func play_card():
	emit_signal("card_played", my_slot)


func emit_damage_opponent_card(dmg):
	emit_signal("damage_opponent_card", self, dmg)


func emit_damage_opponent(dmg):
	emit_signal("damage_opponent", self, dmg)


func emit_declare_attack():
	emit_signal("declare_attack", self)


func emit_card_selected():
	emit_signal("card_selected", self)


func emit_buff_same_element(power, hp):
	emit_signal("buff_same_element", self, self.CARD_RESOURCE.CARD_ELEMENT, power, hp)


func emit_heal_self(healing):
	emit_signal("heal_self", self, healing)


func attack():
	if my_card_script_node.get_script():
		my_card_script_node.attack()


func post_attack():
	if my_card_script_node.get_script():
		my_card_script_node.post_attack()

	set_inactive()


func effect():
	if my_card_script_node.get_script():
		my_card_script_node.effect()


func post_effect():
	if my_card_script_node.get_script():
		my_card_script_node.post_effect()

	hide_effect_button()


func buff(power, hp):
	CARD_RESOURCE.POWER += power
	CARD_RESOURCE.HP += hp

	set_card_power_and_health()


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