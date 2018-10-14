extends Node2D

signal active_card
signal card_played

export(Resource) var CARD_RESOURCE = null

var is_on_field = false
var is_in_hand = false
var my_slot = null

func _ready():
	$TextureButton.texture_normal = CARD_RESOURCE.CARD_IMAGE
	
	set_card_power_and_health()
		
	$HandMenu.visible = false
	$FieldMenu.visible = false


func _on_TextureButton_pressed():
	emit_signal("active_card", CARD_RESOURCE)
	
	if is_on_field:
		$FieldMenu.visible = true
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


func close_menus():
	$FieldMenu.visible = false
	$HandMenu.visible = false


func set_on_field():
	is_on_field = true
	is_in_hand = false


func set_in_hand():
	is_in_hand = true
	is_on_field = false


func play_card():
	emit_signal("card_played", my_slot)
	
	
func attack():
	if CARD_RESOURCE.SCRIPT_FILE:
		CARD_RESOURCE.SCRIPT_FILE.attack()
	else:
		print(CARD_RESOURCE.CARD_NAME, "has no script")
	