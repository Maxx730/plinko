class_name Monster extends Node

@export var spriteTexture: Texture2D
@export var monsterName: String
@export_multiline var monsterDescription: String

# stats
@export var maxHitpoints: int
@export var attackMin: int = 1
@export var attackMax: int = 5

var currentHitpoints: int = maxHitpoints

func  _ready() -> void:
	currentHitpoints = maxHitpoints
	Events.OnGameStateChanged.connect(gameStateChanged)

func gameStateChanged(state) -> void:
	pass

func takeDamage(amnt: int) -> void:
	if currentHitpoints - amnt < 0:
		queue_free.call_deferred()
		Events.OnMonsterDestroyed.emit()
	else:
		currentHitpoints -= amnt

func attackPlayer() -> void:
	pass
