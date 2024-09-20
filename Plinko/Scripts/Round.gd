class_name Round extends Control

@onready var uniqueRef: Label = get_node("Vertical/Unique") as Label

const UNIQUE_LABEL = ' Unique Pegs'
var uniqueHits: Array

func _ready() -> void:
	Events.OnPegCollided.connect(addUnique)
	Events.OnBallDestroyed.connect(clearUnique)

func updateUniqueLabel() -> void:
	uniqueRef.text = str(uniqueHits.size()) + UNIQUE_LABEL

func addUnique(peg, impactPoint: Vector2 = Vector2.ZERO) -> void:
	if not uniqueHits.has(peg):
		uniqueHits.append(peg)
		updateUniqueLabel()

func clearUnique() -> void:
	uniqueHits.clear()
	updateUniqueLabel()
