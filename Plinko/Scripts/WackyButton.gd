@tool
class_name WackyButton extends Button

@export var rockSpeed: float = 3.0
@export var rockAngle: float = 3.0
@export var wackyText: String = "Default Button":
	set(val):
		wackyText = val
		get_node('Button/Label').text = wackyText

var isHovering: bool
var elapsedTime: float

signal OnPressed()

func _process(delta: float) -> void:
	if isHovering:
		scale = lerp(scale, Vector2(1.1, 1.1), delta * 15.0)
		rotation = deg_to_rad(sin(elapsedTime * rockSpeed) * rockAngle)
	else:
		scale = lerp(scale, Vector2.ONE, delta * 15.0)
		rotation = 0

	elapsedTime += delta

func OnBlur() -> void:
	isHovering = false

func OnHover() ->  void:
	isHovering = true
	elapsedTime = 0
	pivot_offset = Vector2(size.x / 2, size.y / 2)

func OnButtonPressed() -> void:
	OnPressed.emit()
