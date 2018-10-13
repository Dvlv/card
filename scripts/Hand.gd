extends "res://scripts/SlotContainer.gd"

func connect_play_signal_to_all_children(logic):
	for child in get_children():
		child.connect_play_signal(logic)
	