class_name Perks extends Panel

func _ready() -> void:
	var bounceButton: WackyButton = get_node('Vert/Bounce') as WackyButton
	var powerButton: WackyButton = get_node('Vert/Power') as WackyButton
	var amountButton: WackyButton = get_node('Vert/Amount') as WackyButton

	bounceButton.pressed.connect(func(): applyPerk(func(): Global.ballBounciness += 0.05))


func applyPerk(callback: Callable) -> void:
	callback.call()
	Global.gameState = Game.GAME_STATE.DROPPING
	Events.OnGameStateChanged.emit(Global.gameState)
