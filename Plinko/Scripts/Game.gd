class_name Game extends Node2D

enum GAME_STATE {
	# beginning each dropping session
	BEGIN,
	# spawn the ball/balls that will be dropped by the player
	SPAWN,
	# player drops the ball
	DROPPING,
	# while the ball is dropping
	FALLING,
	# after the ball is dropped, calculate the damage etc
	CALCULATING,
	SCORE,
	PEG_RESET,
	# after a current round is finished open the shop
	SHOP,
	PERK,
	# player has run out of health and lost
	GAMEOVER,
}

var impactPrefab: PackedScene = preload('res://Prefabs/Impact.tscn') as PackedScene
var damagePrefab: PackedScene = preload('res://Prefabs/Damage.tscn') as PackedScene
var alertPrefab: PackedScene = preload('res://Prefabs/Alert.tscn') as PackedScene



# UI Elements
@onready var totalScoreLabel: WackyLabel = get_node('UI/HUD/Top/Margin/List/Scores/TotalScore') as WackyLabel
@onready var multiplyLabel: WackyLabel = get_node('UI/HUD/Top/Margin/List/Frame/Calculate/Mult') as WackyLabel
@onready var pointLabel: WackyLabel = get_node('UI/HUD/Top/Margin/List/Frame/Calculate/Points') as WackyLabel
@onready var screenClip: Clip = get_node('UI/HUD/Top/Margin/List/Clip') as Clip

var currentState: GAME_STATE = GAME_STATE.BEGIN
var roundGoal: int
var totalScore: int
var calculatedTotal: int
var dropMultiply: int = 1
var dropPoints: int
var chosenPerks: Array = []



func _ready() -> void:
	connect_events()
	Events.OnAlertMessage.connect(spawn_alert_message)
	Events.OnLoadingComplete.connect(func(): Events.OnScreenChange.emit('Main'))

func _process(delta: float) -> void:
	match Global.gameState:
		GAME_STATE.CALCULATING:
			calculate_drop_score()

func _physics_process(delta: float) -> void:
	pass





func on_state_changed(state: GAME_STATE) -> void:
	match state:
		GAME_STATE.SCORE:
			Events.OnGameRoundFinished.emit(totalScore)
			Events.OnScreenChange.emit('Score')
			Events.OnHideHUD.emit()
		GAME_STATE.BEGIN:
			setup_round()
			reset_points()
			if screenClip:
				screenClip.reload_balls()
			await get_tree().create_timer(1.0).timeout
			Global.gameState = GAME_STATE.SPAWN
			Events.OnGameStateChanged.emit(Global.gameState)

func connect_events() -> void:
	Events.OnGameStateChanged.connect(on_state_changed)
	Events.OnPegCollided.connect(calculate_peg_hit)
	Events.OnBallDestroyed.connect(calculate_drop_totals)

func setup_round() -> void:
	roundGoal = Utils.calculate_level_points(Global.currentRound)

func reset_points() -> void:
	totalScore = 0
	dropMultiply = 1
	dropPoints = 0
	calculatedTotal = 0
	update_score(false)

func update_score(animate: bool) -> void:
	totalScoreLabel.set_label_text(str(totalScore), not animate)
	multiplyLabel.set_label_text(str(dropMultiply), animate)
	pointLabel.set_label_text(str(dropPoints), animate)




# spawning methods
func spawn_hit_effects(impactPoint: Vector2, value: String = '10', color: Color = Color.WHITE) -> void:
	var impact: Impact = impactPrefab.instantiate() as Impact
	var damage: Damage = damagePrefab.instantiate() as Damage
	get_tree().root.get_node("Game").add_child(damage)
	get_tree().root.get_node("Game").add_child(impact)
	impact.position = impactPoint
	damage.text = value
	damage.position = impactPoint
	damage.modulate = color

func spawn_alert_message(message: String, color: Color = Color.WHITE) -> void:
	var spawnedAlert: Alert = alertPrefab.instantiate() as Alert
	spawnedAlert.OnAlert(message, color)
	get_tree().root.add_child(spawnedAlert)



func calculate_peg_hit(peg: Peg, impactPoint: Vector2) -> void:
	if peg is Mult:
		dropMultiply += 1
		spawn_hit_effects(impactPoint, String('+ 1') , Color.PURPLE)
	elif peg is Refresh:
		Events.OnResetBoard.emit()
	else:
		dropPoints += 10
		spawn_hit_effects(impactPoint, String('+ 10'))

	update_score(true)

func calculate_drop_score() -> void:
	totalScore = move_toward(totalScore, calculatedTotal, 5 if calculatedTotal < 1000 else 50)
	update_score(false)
	if is_equal_approx(totalScore, calculatedTotal):
		Global.gameState = Game.GAME_STATE.SPAWN
		Events.OnGameStateChanged.emit(Global.gameState)

func calculate_drop_totals() -> void:
	calculatedTotal += dropMultiply * dropPoints
	dropMultiply = 1
	dropPoints = 0
