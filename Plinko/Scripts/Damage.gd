class_name Damage extends Label

var damageAmount: int = 1
var floatDirection: Vector2
var floatSpeed: float

func _ready() -> void:
	floatDirection = Vector2(
		randf_range(-0.25, 0.25),
		-1.0
	)
	pivot_offset = Vector2(0.5, 0.5)
	scale = Vector2(1.75, 1.75)

func _process(delta) -> void:
	position += floatDirection
	modulate.a = lerp(modulate.a, 0.0, delta * 2.0)
	scale = lerp(scale, Vector2.ONE, delta * 6.0)
	if is_zero_approx(modulate.a):
		queue_free.call_deferred()
