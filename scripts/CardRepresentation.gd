extends Node2D

signal active_card
signal card_played
signal card_selected
signal damage_opponent_card
signal damage_opponent
signal declare_attack


export(Resource) var CARD_RESOURCE = null

var is_on_field = false
var is_in_hand = false
var is_opponent_card = false
var my_slot = null

onready var my_card_script_node = Node2D.new()

func _ready():
	CARD_RESOURCE = CARD_RESOURCE.duplicate()
	$TextureButton.texture_normal = CARD_RESOURCE.CARD_IMAGE
	
	set_card_power_and_health()
	connect_attack_and_effect_signals()
		
	$HandMenu.visible = false
	$FieldMenu.visible = false
	$OpponentFieldMenu.visible = false


func _on_TextureButton_pressed():
	emit_signal("active_card", CARD_RESOURCE)
	
	if is_on_field and not is_opponent_card:
		$FieldMenu.visible = true
	elif is_on_field and is_opponent_card and globals.is_in_attack_choose_state:
		$OpponentFieldMenu.visible = true
	elif is_in_hand:
		$HandMenu.visible = true


func set_card_power_and_health():
	if CARD_RESOURCE.POWER > 0:
		$Info/Power.text = "P: " + str(CARD_RESOURCE.POWER)
	else:
		$Info/Power.text = ""
		
	if CARD_RESOURCE.HP > 0:
		$Info/Health.text = "H: " + str(CARD_RESOURCE.HP)
	else:
		$Info/Health.text = ""


func connect_attack_and_effect_signals():
	if CARD_RESOURCE.CARD_TYPE == CARD_RESOURCE.TYPES.Creature:
		var my_card_script = CARD_RESOURCE.SCRIPT_FILE if CARD_RESOURCE.SCRIPT_FILE else load("res://scripts/card_functionality/card_functionality_base.gd")
		
		my_card_script_node.set_script(my_card_script)
		my_card_script_node.connect("damage_opponent_card", self, "emit_damage_opponent_card")
		my_card_script_node.connect("damage_opponent", self, "emit_damage_opponent")
		my_card_script_node.connect("declare_attack", self, "emit_declare_attack")
	

func close_menus():
	$FieldMenu.visible = false
	$HandMenu.visible = false
	$OpponentFieldMenu.visible = false


func set_on_field():
	is_on_field = true
	is_in_hand = false


func set_in_hand():
	is_in_hand = true
	is_on_field = false


func play_card():
	emit_signal("card_played", my_slot)
	
	
func emit_damage_opponent_card():
	emit_signal("damage_opponent_card", CARD_RESOURCE.POWER)


func emit_damage_opponent():
	emit_signal("damage_opponent", CARD_RESOURCE.POWER)


func emit_declare_attack():
	emit_signal("declare_attack", self)
	

func emit_card_selected():
	emit_signal("card_selected", self)


func attack():
	if my_card_script_node.get_script():
		my_card_script_node.attack()


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