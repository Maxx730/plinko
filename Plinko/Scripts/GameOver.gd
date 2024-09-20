class_name GameOver extends Panel

@onready var retryAction: StylizedButton = get_node("Window/Vertical/Margin/Items/Buttons/Retry") as StylizedButton
@onready var menuAction: StylizedButton = get_node("Window/Vertical/Margin/Items/Buttons/Menu") as StylizedButton

func _ready() -> void:
	connectInterface()
	Events.OnGameStateChanged.connect(gameOver)

func connectInterface() -> void:
	retryAction.OnButtonPressed.connect(restartGame)

func restartGame() -> void:
	Events.OnGameRestart.emit()
	visible = false

func gameOver(state) -> void:
	if state == Game.GAME_STATE.GAMEOVER:
		visible = true
