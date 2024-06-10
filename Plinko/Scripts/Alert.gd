class_name Alert extends Node2D

var targetRotation: float


func _process(delta: float) -> void:
	rotation_degrees = move_toward(rotation_degrees, targetRotation, 5)
	modulate.a = move_toward(modulate.a, 0.0, 0.05)
	scale = lerp(scale, Vector2(2, 2), delta * 5.0)

	if is_equal_approx(modulate.a, 0.0):
		queue_free()


func OnAlert(message, color: Color = Color.WHITE) -> void:
	var alertLabel = get_node('Alert') as Label
	alertLabel.text = message
	alertLabel.modulate = color
	modulate.a = 1.0
	targetRotation = randf_range(-30.0, 30.0)
	scale = Vector2(0.25, 0.25)
	rotation_degrees = 0
