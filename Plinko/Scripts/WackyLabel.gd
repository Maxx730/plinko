class_name WackyLabel extends Label

@export_category("Style Tweaks")
@export var animationSpeed: float = 5.0
@export var animationGradient: Gradient


func _ready() -> void:
	pivot_offset = Vector2(size.x / 2.0, size.y / 2.0)

func _process(delta: float) -> void:
	scale = lerp(scale, Vector2.ONE, delta * animationSpeed)
	rotation = lerp(rotation, 0.0, delta * animationSpeed)
	if animationGradient:
		pass



func set_label_text(newText: String, animate: bool = false) -> void:
	text = newText
	if animate:
		rotation_degrees = randf_range(-10.0, 10.0)
		var randomScaleSize: float = randf_range(1.1, 1.5)
		scale = Vector2(randomScaleSize, randomScaleSize)
