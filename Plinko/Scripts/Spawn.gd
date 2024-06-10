class_name Spawn extends Area2D

@export var ballClip: Clip

var ballPrefab: PackedScene = preload("res://Prefabs/Ball.tscn") as PackedScene
@onready var aimRef: Aim = get_node('Aim') as Aim

var ballRef: Ball
var targetPosition: Vector2

func _ready() -> void:
	Events.OnGameStateChanged.connect(on_state_changed)

func _process(delta: float) -> void:
	match Global.gameState:
		Game.GAME_STATE.DROPPING:
			if Input.is_action_just_released('DropBall'):
				if ballRef:
					ballRef.velocity = Vector2(1, 0).rotated(aimRef.rotation) * 300.0
				Global.gameState = Game.GAME_STATE.FALLING
				Events.OnGameStateChanged.emit(Global.gameState)





func on_state_changed(state: Game.GAME_STATE) -> void:
	match state:
		Game.GAME_STATE.SPAWN:
			var nextBall = ballClip.get_next_ball()
			if nextBall:
				spawn_ball()
			else:
				await get_tree().create_timer(1.0).timeout
				Global.gameState = Game.GAME_STATE.SCORE
				Events.OnGameStateChanged.emit(Global.gameState)

func spawn_ball() -> void:
	var spawnedBall: Ball = ballPrefab.instantiate() as Ball
	get_tree().root.add_child(spawnedBall)
	spawnedBall.position = position
	ballRef = spawnedBall
	Global.gameState = Game.GAME_STATE.DROPPING
	Events.OnGameStateChanged.emit(Global.gameState)
