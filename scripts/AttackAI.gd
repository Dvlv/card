extends Node2D

signal opponent_attacks_face
signal opponent_attacks_creature


# takes a rep of my creature, and a list of reps of all opponents
# attacks face if no opponent creatures
func perform_attack(my_creature, player_creatures):
	if not len(player_creatures):
		emit_signal("opponent_attacks_face", my_creature)
		return
		
	var perfect_target = find_perfect_target(my_creature, player_creatures)
	if perfect_target:
		emit_signal("opponent_attacks_creature", my_creature, perfect_target)
	else:
		var strongest = find_strongest_player_creature(player_creatures)
		emit_signal("opponent_attacks_creature", my_creature, strongest)




# A perfect target has exactly the attacker's attack as HP, and less
# than the attacker's HP as attack
# e.g. a 2/3 attacking would match perfectly with a 1/2 defender
# if multiple, return the one with the highest attack
func find_perfect_target(my_creature, player_creatures):
	var best_perfect_match = null
	
	for creature in player_creatures:
		if creature.get_hp() == my_creature.get_power() and creature.get_power() < my_creature.get_hp():
			if not best_perfect_match:
				best_perfect_match = creature
			else:
				if creature.get_power() > best_perfect_match.get_power():
					best_perfect_match = creature

	return best_perfect_match
	


# finds opponent's creature with highest total stats
# if a creature has 3 or less power than the strongest, 
# it is considered weaker.
# e.g. a 1/8 is considered weaker than a 4/4 
func find_strongest_player_creature(player_creatures):
	var strongest_creature = null
	
	for creature in player_creatures:
		if not strongest_creature:
			strongest_creature = creature
		else:
			var total_stats = creature.get_power() + creature.get_hp()
			var strongest_stats = strongest_creature.get_power() + strongest_creature.get_hp()
			
			if total_stats > strongest_stats and not creature.get_power() < strongest_creature.get_power() - 2:
				strongest_creature = creature
			elif total_stats == strongest_stats:
				if creature.get_power() > strongest_creature.get_power():
					strongest_creature = creature
	
	return strongest_creature
