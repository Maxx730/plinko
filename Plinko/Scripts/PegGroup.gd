@tool
class_name PegGroup extends Node2D

@export var pegRows: int = 3:
	set(amnt):
		pegRows = amnt
		if Engine.is_editor_hint():
			clearPegs()
			generatePegs()
@export var pegCols: int = 3:
	set(amnt):
		pegCols = amnt
		if Engine.is_editor_hint():
			clearPegs()
			generatePegs()
@export var pegSpacing: int = 24:
	set(space):
		pegSpacing = space
		if Engine.is_editor_hint():
			clearPegs()
			generatePegs()


func _ready() -> void:
	Events.OnGameStateChanged.connect(handle_state_change)
	Events.OnGameRestart.connect(clearPegs)
	Events.OnResetBoard.connect(resetGroup)


func handle_state_change(state: Game.GAME_STATE) -> void:
	match state:
		Game.GAME_STATE.BEGIN:
			resetGroup()

func clearPegs() -> void:
	for child in get_children():
		child.queue_free.call_deferred()

func generatePegs() -> void:
	var pegPrefab: PackedScene = load("res://Prefabs/Peg.tscn") as PackedScene
	var rowHalf: int = pegRows / 2
	var colHalf: int = pegCols / 2

	for	row in range(-rowHalf, rowHalf):
		for col in range(-colHalf, colHalf):
			var isOdd: int = row % 2
			var pegInst: Peg = PegManager.pegPrefabs[0].instantiate() as Peg
			add_child.call_deferred(pegInst)
			pegInst.name = "Peg-" + str(randi())
			pegInst.position = Vector2(col * pegSpacing - (isOdd * (pegSpacing / 2)), row * pegSpacing)

	await get_tree().process_frame
	# add different peg types for each peg
	addPegType(PegManager.pegPrefabs[1], Global.bombPegAmount)
	addPegType(PegManager.pegPrefabs[2], Global.multiPegAmount)
	addPegType(PegManager.pegPrefabs[3], Global.refreshPegAmount)

func addPegType(type: PackedScene, amnt: int = 1) -> void:
	var added: int
	var totalPegs: int = get_child_count()

	while added < amnt:
		var randomPeg: Peg = get_child(randi_range(0, totalPegs - 1)) as Peg
		if randomPeg is Standard:
			var spawnedPeg: Peg = type.instantiate() as Peg
			spawnedPeg.name = "Peg-" + str(randi())
			spawnedPeg.position = randomPeg.position
			add_child(spawnedPeg)
			randomPeg.queue_free()
			added += 1

func resetGroup() -> void:
	clearPegs()
	generatePegs()
