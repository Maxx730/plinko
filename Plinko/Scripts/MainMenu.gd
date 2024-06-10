class_name MainMenu extends Node

func quitGame() -> void:
	get_tree().quit()

func startRun() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")
