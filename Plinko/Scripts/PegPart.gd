class_name PegPart extends RigidBody2D

var elapsedTime: float

func _process(delta: float) -> void:
	elapsedTime += delta
	if elapsedTime > 5.0:
		queue_free()
