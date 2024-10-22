extends ScreenContents

@onready var goalScore: Label = get_node('List/Middle/Margin/Stats/Hor/Goal') as Label
@onready var actualScore: WackyLabel = get_node('List/Middle/Score') as WackyLabel
@onready var continueButton: WackyButton = get_node('List/Continue') as WackyButton
@onready var quitButton: WackyButton = get_node('List/Quit') as WackyButton
@onready var statusLabel: Label = get_node("List/Status") as Label
@onready var titleLabel: WackyTitle = get_node("List/Title") as WackyTitle

var targetScore: int

func _ready() -> void:
	continueButton.OnPressed.connect(ToBegin)
	quitButton.OnPressed.connect(ResetAndQuit)
	Events.OnGameRoundFinished.connect(func(score): targetScore = score)

func _process(delta: float) -> void:
	if actualScore:
		var scoreAmnt: int = int(actualScore.text)
		var valuesEqual: int = is_equal_approx(scoreAmnt, targetScore)
		if not valuesEqual:
			actualScore.set_label_text(str(
				move_toward(scoreAmnt, targetScore, targetScore / 100)
			), true)

		if continueButton:
			continueButton.disabled = not valuesEqual



func UpdateScreen() -> void:
	var goalRoundScore: int = int(
		floor(
			Utils.calculate_level_points(Global.currentRound)
		)
	)
	var hasPassed: bool = (targetScore >= goalRoundScore) as bool

	goalScore.text = str(goalRoundScore)
	actualScore.text = "000"
	titleLabel.wackyText = "SUCCESS" if hasPassed else "GAME OVER"
	titleLabel.clear_text()
	titleLabel.generate_text()

	if hasPassed:
		Global.currentRound += 1
	else:
		Events.OnGameRunEnd.emit()

	ToggleButtons(hasPassed)

func ToBegin() -> void:
	Events.OnScreenChange.emit('Perks')

func ToggleButtons(passed: bool) -> void:
	continueButton.visible = passed
	quitButton.visible = not passed

func ResetAndQuit() -> void:
	Global.currentRound = 1
	Events.OnGameRestart.emit()
	Events.OnScreenChange.emit('Main')
