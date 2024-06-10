class_name Goal extends Panel

func _ready() -> void:
	Events.OnGameStateChanged.connect(onStateChanged)

func updateGoalFields() -> void:
	var pointTotal: Label = get_node('Vert/Required') as Label

	if pointTotal:
		pointTotal.text = str(Global.currentRoundPoints)

func onStateChanged(state) -> void:
	updateGoalFields()

func onBeginPressed() -> void:
	Global.gameState = Game.GAME_STATE.BEGIN
	Events.OnGameStateChanged.emit(Global.gameState)
