extends Node2D

signal card_output

var CARDS = []
var CARD_REPS = []
var FUSE_HAPPENED = false

onready var CARD_RESOURCE = preload("res://scripts/CardResource.gd")
onready var card_rep_factory = preload("res://scripts/CardRepFactory.gd")
onready var specific_fusions = preload("res://scripts/SpecificFusions.gd").new()
var adjectives = null


func _ready():
	$TextureButton/Menu.visible = false
	adjectives = CARD_RESOURCE.get_element_adjectives()

func add_card(card_res):
	CARDS.append(card_res)
	var container = MarginContainer.new()
	container.rect_min_size = Vector2(60,60)

	var rep = card_rep_factory.create(card_res)
	rep.is_in_fusebox = true
	rep.scale.x = 0.5
	rep.scale.y = 0.5

	container.add_child(rep)
	$Reps.add_child(container)

	CARD_REPS.append(rep)


func connect_remove_signal_to_all_cards(logic):
	for rep in CARD_REPS:
		rep.connect_button_press_to_remove_from_fusebox(logic)

func fuse():
	while len(CARDS) > 1:
		fuse_two(CARDS.pop_front(), CARDS.pop_front())

	output(CARDS.pop_front())


func fuse_two(card_one, card_two):
	if card_one.is_equip():
		if card_two.is_equip():
			fuse_two_equips(card_one, card_two)
		elif card_two.is_creature():
			equip_creature(card_two, card_one)
		elif card_two.is_element():
			add_element_to_equip(card_one, card_two)

	elif card_one.is_creature():
		if card_two.is_creature():
			fuse_two_creatures(card_one, card_two)
		elif card_two.is_equip():
			equip_creature(card_one, card_two)
		elif card_two.is_element():
			add_element_to_creature(card_one, card_two)

	elif card_one.is_element():
		if card_two.is_element():
			fuse_two_elements(card_one, card_two)
		elif card_two.is_equip():
			add_element_to_equip(card_two, card_one)
		elif card_two.is_creature():
			add_element_to_creature(card_two, card_one)


func fuse_two_elements(element_one, element_two):
	# Fusing two elements does not work.
	CARDS.push_front(element_two)


func fuse_two_equips(equip_one, equip_two):
	# Fusing two equips does not work unless specific.
	var result = specific_fusions.specific_equip_equip_fusions(equip_one, equip_two)

	if result:
		FUSE_HAPPENED
	else:
		result = equip_two

	CARDS.push_front(result)


func fuse_two_creatures(creature_one, creature_two):
	var result = specific_fusions.specific_creature_creature_fusions(creature_one, creature_two)

	if result:
		FUSE_HAPPENED = true
		return CARDS.push_front(result)
	else:
		result = creature_two

	# Bird + Bear = Scouts
	if ((creature_one.CARD_CREATURE_TYPE == CARD_RESOURCE.CREATURE_TYPE.Bird and creature_two.CARD_CREATURE_TYPE == CARD_RESOURCE.CREATURE_TYPE.Bear) or
	(creature_two.CARD_CREATURE_TYPE == CARD_RESOURCE.CREATURE_TYPE.Bird and creature_one.CARD_CREATURE_TYPE == CARD_RESOURCE.CREATURE_TYPE.Bear)):
		result = load("res://resources/Scouts.tres")
		FUSE_HAPPENED = true

	# Fish + Electric = Electric Eel
	elif ((creature_one.CARD_CREATURE_TYPE == CARD_RESOURCE.CREATURE_TYPE.Fish and creature_two.CARD_ELEMENT == CARD_RESOURCE.ELEMENTS.Electricity) or
	(creature_two.CARD_CREATURE_TYPE == CARD_RESOURCE.CREATURE_TYPE.Fish and creature_one.CARD_ELEMENT == CARD_RESOURCE.ELEMENTS.Electricity)):
		result = load("res://resources/ElectricEel.tres")
		FUSE_HAPPENED = true

	# Human x 2 = Family
	elif creature_one.CARD_FACTION == CARD_RESOURCE.FACTIONS.Human and creature_two.CARD_FACTION == CARD_RESOURCE.FACTIONS.Human:
		result = load("res://resources/Family.tres")
		FUSE_HAPPENED = true

	# Fish x 2 = Sharp Shark
	elif creature_one.CARD_CREATURE_TYPE == CARD_RESOURCE.CREATURE_TYPE.Fish and creature_two.CARD_CREATURE_TYPE == CARD_RESOURCE.CREATURE_TYPE.Fish:
		result = load("res://resources/SharpShark.tres")
		FUSE_HAPPENED = true

	CARDS.push_front(result)


func add_element_to_creature(creature, element):
	# If creature is plain, creature becomes elemental
	# Otherwise, if element matches creature's element, power up creature
	# Otherwise, fail, just return creature.
	var result = specific_fusions.specific_creature_element_fusions(creature, element)
	if result:
		FUSE_HAPPENED = true
		return CARDS.push_front(result)

	if creature.CARD_ELEMENT == CARD_RESOURCE.ELEMENTS.Plain:
		creature.CARD_ELEMENT = element.CARD_ELEMENT
		creature.CARD_NAME = adjectives[element.CARD_ELEMENT] + " " + creature.CARD_NAME
		FUSE_HAPPENED = true
	elif creature.CARD_ELEMENT == element.CARD_ELEMENT:
		creature.POWER += 1
		FUSE_HAPPENED = true

	CARDS.push_front(creature)


func add_element_to_equip(equip, element):
	# If equip is plain, become an elemental version
	# Otherise, if equip matches element, power it up
	# Otherwise, fail, just return equip
	if equip.CARD_ELEMENT == CARD_RESOURCE.ELEMENTS.Plain:
		equip.CARD_ELEMENT = element.CARD_ELEMENT
		equip.CARD_NAME = adjectives[element.CARD_ELEMENT] + " " + equip.CARD_NAME
		FUSE_HAPPENED = true
	elif equip.CARD_ELEMENT == element.CARD_ELEMENT:
		equip.POWER += 1
		FUSE_HAPPENED = true

	CARDS.push_front(equip)


func equip_creature(creature, equip):
	# If both have a non-plain element and elements dont match, fail
	# If creature is plain and equip is elemental, creature becomes elemental
	# Add equip's stats to creature
	var result = specific_fusions.specific_creature_equip_fusions(creature, equip)
	if result:
		FUSE_HAPPENED = true
		return CARDS.push_front(result)

	if equip.CARD_ELEMENT != CARD_RESOURCE.ELEMENTS.Plain:
		if ((creature.CARD_ELEMENT != CARD_RESOURCE.ELEMENTS.Plain and creature.CARD_ELEMENT == equip.CARD_ELEMENT)
			or creature.CARD_ELEMENT == CARD_RESOURCE.ELEMENTS.Plain):
			creature.POWER += equip.POWER
			creature.CARD_ELEMENT = equip.CARD_ELEMENT
			FUSE_HAPPENED = true
	else:
		creature.POWER += equip.POWER
		FUSE_HAPPENED = true

	CARDS.push_front(creature)


func output(result):
	# add result to board
	self.CARDS = []
	emit_signal("card_output", result, FUSE_HAPPENED)


func remove_card(card_rep):
	CARD_REPS.erase(card_rep)
	CARDS.erase(card_rep.CARD_RESOURCE)

	for container in $Reps.get_children():
		if container.get_child(0) == card_rep:
			container.queue_free()


func clear_all():
	for container in $Reps.get_children():
		container.queue_free()

	CARD_REPS = []
	FUSE_HAPPENED = false


func close_menu():
	$TextureButton/Menu.visible = false


func _on_Fuse_pressed():
	close_menu()
	fuse()
	clear_all()


func _on_TextureButton_pressed():
	if len(CARDS) > 1:
		$TextureButton/Menu.visible = true
