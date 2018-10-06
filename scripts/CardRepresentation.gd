extends Node2D

export(Resource) var CARD_RESOURCE = null

func _ready():
	$TextureButton.texture_normal = CARD_RESOURCE.CARD_IMAGE