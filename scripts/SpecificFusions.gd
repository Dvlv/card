# This class is to hold the mess of specific card fusions
# This includes
# - Plain Dragon + element = Elemental Dragon
# - Bear + food = Sleepy Bear
# Food + Food = Rat or Cockroach
extends Node2D

var CARD_RESOURCE = preload("res://CardResource.tres")

func specific_creature_creature_fusions(creature_one, creature_two):
	# Alphabetise the two creatures for convenience?
	var card_to_create = null

	if creature_one.CARD_NAME.to_lower() == "small fox" and creature_two.CARD_NAME.to_lower() == "small fox":
		card_to_create = "FierceFox"

	return make_card_to_create(card_to_create)


func specific_creature_element_fusions(creature, element):
	var card_to_create = null

	if creature.CARD_NAME.to_lower() == "plain dragon":
		if element.CARD_ELEMENT == CARD_RESOURCE.ELEMENTS.Fire:
			card_to_create = "FireDragon"
		elif element.CARD_ELEMENT == CARD_RESOURCE.ELEMENTS.Water:
			card_to_create = "WaterDragon"
		elif element.CARD_ELEMENT == CARD_RESOURCE.ELEMENTS.Air:
			card_to_create = "SkyDragon"
		elif element.CARD_ELEMENT == CARD_RESOURCE.ELEMENTS.Earth:
			card_to_create = "GroundDragon"
		elif element.CARD_ELEMENT == CARD_RESOURCE.ELEMENTS.Electricity:
			card_to_create = "ElectricDragon"

	return make_card_to_create(card_to_create)



func specific_equip_equip_fusions(equip_one, equip_two):
	var card_to_create = null

	if equip_one.CARD_NAME.to_lower() == "food" and equip_two.CARD_NAME.to_lower() == "food":
		randomize()
		var possibilities = ["Rat", "Cockroach"]
		card_to_create = possibilities[randi() % 2]

	return make_card_to_create(card_to_create)


func specific_creature_equip_fusions(creature, equip):
	var card_to_create = null

	if creature.CARD_CREATURE_TYPE == CARD_RESOURCE.CREATURE_TYPE.Bear and equip.CARD_NAME.to_lower() == "food":
		card_to_create = "SleepyBear"

	return make_card_to_create(card_to_create)





func make_card_to_create(card_to_create):
	var resource = null

	if card_to_create:
		resource = load("res://resources/" + card_to_create + ".tres")

	return resource
