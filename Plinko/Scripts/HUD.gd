class_name HUD extends Node

@onready var pauseButton: TextureButton = get_node("Top/Pause") as TextureButton

func _ready() -> void:
	Events.OnHideScreens.connect(Show)
	Events.OnHideHUD.connect(Hide)
	pauseButton.pressed.connect(PauseGame)

func Show() -> void:
	var content: Panel = get_child(0) as Panel
	if content:
		content.visible = true

func Hide() -> void:
	var content: Panel = get_child(0) as Panel
	if content:
		content.visible = false

func PauseGame() -> void:
	print('pausing')
