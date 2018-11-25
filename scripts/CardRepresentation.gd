extends Node2D

signal active_card
signal card_played
signal card_added_to_fusebox
signal card_removed_from_fusebox

export(Resource) var CARD_RESOURCE = null

var my_slot = null
var is_on_field = false
var is_in_hand = false
var is_in_fusebox = false
var is_opponent_card = false

onready var my_card_script_node = Node2D.new()

func _ready():
	if not is_in_fusebox:
		CARD_RESOURCE = CARD_RESOURCE.duplicate()
	$TextureButton.texture_normal = CARD_RESOURCE.CARD_IMAGE

	set_card_power_and_health()

	$HandMenu.visible = false
	$FieldMenu.visible = false
	$OpponentFieldMenu.visible = false


func _on_TextureButton_pressed():
	emit_signal("active_card", CARD_RESOURCE)

	if is_in_hand:
		$HandMenu.visible = true
		$HandMenu/Control/VBoxContainer/Play.visible = false


func animate_move(from, to, time=0.3):
	$Tween.interpolate_property(self, "position", from, to, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()


func connect_button_press_to_remove_from_fusebox(logic):
	if $TextureButton.is_connected("pressed", self, "_on_TextureButton_pressed"):
		$TextureButton.disconnect("pressed", self, "_on_TextureButton_pressed")

	if not $TextureButton.is_connected("pressed", self, "on_button_pressed_remove_from_fusebox"):
		$TextureButton.connect("pressed", self, "on_button_pressed_remove_from_fusebox")

	if not is_connected("card_removed_from_fusebox", logic, "on_rep_removed_from_fusebox"):
		connect("card_removed_from_fusebox", logic, "on_rep_removed_from_fusebox")


func on_button_pressed_remove_from_fusebox():
	emit_signal("card_removed_from_fusebox", self)


func add_card_to_fusebox():
	emit_signal("card_added_to_fusebox", my_slot)


func set_card_power_and_health():
	if CARD_RESOURCE.POWER > 0:
		$Info/Power.text = "P: " + str(CARD_RESOURCE.POWER)
	else:
		$Info/Power.text = ""

	if CARD_RESOURCE.HP > 0:
		$Info/Health.text = "H: " + str(CARD_RESOURCE.HP)
	else:
		$Info/Health.text = ""


func set_on_field():
	is_on_field = true
	is_in_hand = false


func set_in_hand():
	is_in_hand = true
	is_on_field = false


func close_menus():
	$FieldMenu.visible = false
	$HandMenu.visible = false
	$OpponentFieldMenu.visible = false