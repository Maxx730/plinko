class_name Hits extends Label

const HIT_LABEL = ' Hits'
var currentHits: int

func _ready() -> void:
	Events.OnBallDestroyed.connect(resetCount)
	Events.OnPegCollided.connect(addHit)

func resetCount() -> void:
	currentHits = 0
	text = str(currentHits) + HIT_LABEL

func addHit(peg, impactPoint: Vector2 = Vector2.ZERO) -> void:
	currentHits += 1
	text = str(currentHits) + HIT_LABEL
