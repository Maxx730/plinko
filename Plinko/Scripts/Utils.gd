extends Node

func calculate_level_points(lvl: int) -> float:
	var nextLvl = lvl + 1
	return log(nextLvl) * 100.0 * nextLvl

func print_success(message: String) -> void:
	print_rich('[color=green]SUCCESS: [/color]' + message)

func print_state(message: String) -> void:
	print_rich("[color=blue]STATE: [/color]" + message)

func print_fail(message: String) -> void:
	print_rich("[color=red]ERROR: [/color]" + message)
