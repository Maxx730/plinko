class_name GameCamera extends Camera2D

@export_category("Stats")
@export var shakeLength: float = 0.05;
@export var shakeAmount: float = 2.0

var shaking: bool
var lastShake: float
var targetPoint: Vector2

func _ready() -> void:
	Events.OnPegCollided.connect(Shake)
	Events.OnBallDestroyed.connect(Shake)
	Events.OnBoardSectionEntered.connect(on_ball_entered_section)

func _process(delta) -> void:
	if shaking and lastShake < shakeLength:
		offset = Vector2(
			randi_range(-shakeAmount, shakeAmount),
			randi_range(-shakeAmount, shakeAmount)
		)
		lastShake += delta
	else:
		offset = Vector2.ZERO

	position = lerp(position, targetPoint, delta * 10.0)

func Shake(peg: Peg = null, impactPoint: Vector2 = Vector2.ZERO) -> void:
	shaking = true
	lastShake = 0

func on_ball_entered_section(section: BoardSection) -> void:
	targetPoint = section.position
