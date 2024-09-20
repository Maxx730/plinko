@tool
class_name Background extends Sprite2D

enum MOVEMENT {
	STATIC,
	STRAIGHT,
	ROTATE
}

@export_subgroup('Movement')
@export var backgroundMovementType: MOVEMENT
@export var backgroundMovementSpeed: float = 0.5

@export_subgroup('Color')
@export var backgroundBaseColor: Color = Color.WHITE

var elapsedTime: float

func _ready() -> void:
	Events.OnPegCollided.connect(flash_background)

func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		elapsedTime += delta
		if Global.gameSpeed == Game.GAME_SPEED.NORMAL:
			match backgroundMovementType:
				MOVEMENT.STRAIGHT:
					region_rect.position += Vector2.ONE * backgroundMovementSpeed
				MOVEMENT.ROTATE:
					pass

	modulate = lerp(modulate, backgroundBaseColor, delta * 5.0)


func flash_background(peg: Peg, impactPoint: Vector2) -> void:
	if peg is Refresh:
		modulate = Color.GREEN
	elif peg is Mult:
		modulate = Color.PURPLE
	else:
		modulate = Color.RED
