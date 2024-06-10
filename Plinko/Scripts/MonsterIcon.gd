class_name MonsterIcon extends Sprite2D

var elapsedTime: float

func _process(delta) -> void:
	elapsedTime += delta
	scale.x = 3.0 + (sin(elapsedTime * 5) * 0.1)
	scale.y = 3.0 + (sin(elapsedTime * 5) * 0.05)
