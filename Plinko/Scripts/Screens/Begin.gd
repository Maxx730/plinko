class_name Begin extends ScreenContents

@onready var scoreLabel: Label = get_node('Vert/Bottom/List/Goal/Margin/Score') as Label
@onready var startButton: WackyButton = get_node('Vert/Begin') as WackyButton
@onready var roundLabel: Label = get_node('Vert/Top/Round') as Label

func _ready() -> void:
	startButton.OnPressed.connect(OnStartPressed)

func RenderScreen() -> void:
	pass

func UpdateScreen() -> void:
	roundLabel.text = "Round " + str(Global.currentRound)
	scoreLabel.text = str(floor(Utils.calculate_level_points(Global.currentRound)))

func OnStartPressed() -> void:
	Events.OnHideScreens.emit()
	Global.gameState = Game.GAME_STATE.BEGIN
	Events.OnGameStateChanged.emit(Global.gameState)
