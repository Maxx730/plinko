class_name HUD extends Node

func _ready() -> void:
	Events.OnHideScreens.connect(Show)
	Events.OnHideHUD.connect(Hide)

func Show() -> void:
	var content: Panel = get_child(0) as Panel
	if content:
		content.visible = true

func Hide() -> void:
	var content: Panel = get_child(0) as Panel
	if content:
		content.visible = false
