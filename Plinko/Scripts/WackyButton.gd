class_name WackyButton extends Button

signal OnPressed()

func _ready() -> void:
	pivot_offset = Vector2(size.x / 2, size.y / 2)

func _process(delta: float) -> void:
	scale = lerp(scale, Vector2.ONE, delta * 15.0)
	rotation = lerp_angle(rotation, 0.0, delta * 15.0)

func OnHover() ->  void:
	scale = Vector2(1.25, 1.25)
	rotation_degrees = randf_range(-30, 30)
