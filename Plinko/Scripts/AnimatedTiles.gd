@tool
class_name AnimatedTiles extends Sprite2D

@export_category("Look")
@export_range(0.1, 2.0) var offsetSpeed: float
@export var offsetDir: Vector2 = Vector2(-1, -1)

func _ready() -> void:
	Events.OnPegCollided.connect(randomizeDirection)

func _process(delta) -> void:
	region_rect.position += offsetDir * offsetSpeed

func randomizeDirection(peg, impactPoint: Vector2 = Vector2.ZERO) -> void:
	offsetDir = Vector2(
		randf_range(-2, 2),
		randf_range(-2, 2)
	)
