extends Node2D

export(Resource) var CARD_RESOURCE = null


func _ready():
	if CARD_RESOURCE:
		set_up()

func set_up():
	$CardImage.texture = CARD_RESOURCE.CARD_IMAGE
	$CardText.text = CARD_RESOURCE.CARD_TEXT
	$CardName.text = CARD_RESOURCE.CARD_NAME

	$CardPower.text = str(CARD_RESOURCE.POWER)
	$CardHP.text = str(CARD_RESOURCE.HP)

	_set_card_background()
	_hide_nums_if_needed()

func move_to_fuse_box():
	pass

func on_play():
	pass

func on_destroy():
	pass

func on_attack():
	pass

func on_receive_damage():
	pass

func on_attacked():
	pass

func set_new_resource(card_res):
	CARD_RESOURCE = card_res
	set_up()


func _set_card_background():
	if CARD_RESOURCE.CARD_TYPE == CARD_RESOURCE.TYPES.Creature:
		$Background.texture = load("res://assets/cards/creature.png")
	elif CARD_RESOURCE.CARD_TYPE == CARD_RESOURCE.TYPES.Equip:
		$Background.texture = load("res://assets/cards/equip.png")
	elif CARD_RESOURCE.CARD_TYPE == CARD_RESOURCE.TYPES.Element:
		$Background.texture = load("res://assets/cards/element.png")

func _hide_nums_if_needed():
	if CARD_RESOURCE.CARD_TYPE == CARD_RESOURCE.TYPES.Element:
		$CardPower.visible = false
		$CardHP.visible = false
	else:
		$CardPower.visible = true
		$CardHP.visible = true
