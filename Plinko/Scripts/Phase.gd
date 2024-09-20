class_name Phase extends Panel

@onready var phaseMessage: Label = get_node("Message") as Label
@onready var phaseAnim: AnimationPlayer = get_node("Anim") as AnimationPlayer

var stateChange: int

func _ready() -> void:
	Events.OnPhaseChange.connect(changePhase)

func changePhase(phaseName, newState) -> void:
	phaseMessage.text = phaseName
	visible = true
	stateChange = newState
	phaseAnim.play("fadeIn")
	Global.gameState = Game.GAME_STATE.PHASE_CHANGE
	Events.OnGameStateChanged.emit(Global.gameState)

func phaseAnimFinished(anim) -> void:
	if anim == "fadeIn":
		phaseAnim.play("fadeOut")

	if anim == "fadeOut":
		visible = false
		Global.gameState = stateChange
		Events.OnGameStateChanged.emit(Global.gameState)
