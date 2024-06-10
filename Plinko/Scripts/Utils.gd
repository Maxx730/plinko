extends Node

func calculate_level_points(lvl: int) -> float:
	var nextLvl = lvl + 1
	return log(nextLvl) * 100.0 * nextLvl
