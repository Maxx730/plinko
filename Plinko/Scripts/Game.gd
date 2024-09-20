class_name Game extends Node2D

enum GAME_SPEED {
	NORMAL,
	PAUSE
}

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

signal OnGameSetupComplete()
signal OnRoundValuesReset()

# UI Elements
@onready var totalScoreLabel: Label = get_node('UI/HUD/Top/Margin/List/Scores/TotalScore') as Label
@onready var multiplyLabel: Label = get_node('UI/HUD/Top/Margin/List/Frame/Calculate/Mult') as Label
@onready var pointLabel: Label = get_node('UI/HUD/Top/Margin/List/Frame/Calculate/Points') as Label
@onready var goalLabel: Label = get_node('UI/HUD/Top/Margin/List/Scores/Target/Label') as Label
@onready var screenClip: Clip = get_node('UI/HUD/Top/Margin/List/Clip') as Clip
@onready var boardRef: Board = get_node("Board") as Board
@onready var spawnRef: Spawn = get_node("Board/Colliders/Spawn") as Spawn

var currentState: GAME_STATE = GAME_STATE.BEGIN
var currentSpeed: GAME_SPEED = GAME_SPEED.NORMAL
var roundGoal: int
var totalScore: int
var calculatedTotal: int
var dropMultiply: int = 1
var dropPoints: int
var chosenPerks: Array = []
var droppedBallRef: Ball



func _ready() -> void:
	connect_events()
	Config.load_config_file()

func _process(delta: float) -> void:
	match Global.gameState:
		GAME_STATE.CALCULATING:
			calculate_drop_score()

	match Global.gameSpeed:
		GAME_SPEED.NORMAL:
			if Input.is_action_just_pressed("TogglePauseMenu"):
				Global.gameSpeed = Game.GAME_SPEED.PAUSE
		GAME_SPEED.PAUSE:
			if Input.is_action_just_pressed("TogglePauseMenu"):
				Global.gameSpeed = Game.GAME_SPEED.NORMAL

func _physics_process(delta: float) -> void:
	pass





func on_state_changed(state: GAME_STATE) -> void:
	match state:
		GAME_STATE.SCORE:
			Events.OnGameRoundFinished.emit(totalScore)
			Events.OnScreenChange.emit('Score')
			Events.OnHideHUD.emit()
		GAME_STATE.BEGIN:
			Utils.print_state(GAME_STATE.find_key(Global.gameState))
			setup_round()
			reset_points()
			Utils.print_success('Round values reset!')
			screenClip.reload_balls()
			await screenClip.OnBallsReloaded
			Utils.print_success('Balls reset!')
			boardRef.resetPegs()


func start_spawn() -> void:
	if Global.gameState == GAME_STATE.BEGIN:
		Global.gameState = GAME_STATE.SPAWN
		Utils.print_state(GAME_STATE.find_key(Global.gameState))
		Events.OnGameStateChanged.emit(Global.gameState)

func start_drop() -> void:
	if Global.gameState == GAME_STATE.SPAWN:
		Global.gameState = GAME_STATE.DROPPING
		Events.OnGameStateChanged.emit(Global.gameState)

func connect_events() -> void:
	Events.OnGameStateChanged.connect(on_state_changed)
	Events.OnPegCollided.connect(calculate_peg_hit)
	Events.OnBallDestroyed.connect(calculate_drop_totals)
	Events.OnAlertMessage.connect(spawn_alert_message)
	Events.OnLoadingComplete.connect(func(): Events.OnScreenChange.emit('Main'))
	Events.OnBallDropped.connect(func(ball): droppedBallRef = ball)
	Events.OnBallDestroyed.connect(func(): droppedBallRef = null)
	Events.OnGameRunEnd.connect(reset_run)

	spawnRef.OnBallSpawned.connect(start_drop)
	boardRef.OnPegsReset.connect(start_spawn)

func setup_round() -> void:
	roundGoal = Utils.calculate_level_points(Global.currentRound)
	goalLabel.text = str(roundGoal)

func reset_points() -> void:
	totalScore = 0
	dropMultiply = 1
	dropPoints = 0
	calculatedTotal = 0
	update_score(false)

func reset_run() -> void:
	Utils.print_fail('FAILURE RUN ENDED')
	Global.ballAmount = 2
	Global.multiPegAmount = 2
	Global.refreshPegAmount = 2
	Global.pegDamagePower = 5

func update_score(animate: bool) -> void:
	totalScoreLabel.set_label_text(str(totalScore), not animate)
	multiplyLabel.set_label_text(str(dropMultiply), animate)
	pointLabel.set_label_text(str(dropPoints), animate)

func reset_global_values() -> void:
	Global.ballAmount = 2
	Global.multiPegAmount = 2
	Global.refreshPegAmount = 1
	Global.bombPegAmount = 1



# util methods
func has_beat_goal() -> bool:
	return calculatedTotal >= roundGoal



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


# calculations
func calculate_peg_hit(peg: Peg, impactPoint: Vector2) -> void:
	if peg is Mult:
		dropMultiply += 1
		spawn_hit_effects(impactPoint, String('+ 1') , Color.PURPLE)
	elif peg is Refresh:
		if boardRef:
			boardRef.resetPegs(false)
	else:
		var damageAmount: int = Global.pegDamagePower + randi_range(0, 3)
		dropPoints += damageAmount
		spawn_hit_effects(impactPoint, '+ ' + str(damageAmount))

	if droppedBallRef:
		droppedBallRef.toggle_fire((dropMultiply * dropPoints) > roundGoal)
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
