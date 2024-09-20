@tool
class_name StylizedButton extends Panel

signal OnButtonPressed()

@export var buttonLabel: String = "Default":
	set(val):
		buttonLabel = val
		updateLabel()

func _ready() -> void:
	var button: Button = get_node("Margin/Button") as Button
	button.pressed.connect(func(): OnButtonPressed.emit())

func updateLabel() -> void:
	var label: Label = get_node("Margin/Button/Label") as Label
	label.text = buttonLabel
