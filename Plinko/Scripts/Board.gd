@tool
class_name Board extends Node2D



func resetPegs() -> void:
	for child in get_node("Pegs").get_children():
		if child is PegGroup:
			child.clearPegs()
