@tool
class_name PegGroup extends Node2D

signal OnGroupGenerated()
signal OnGroupCleared()
signal OnUniqueAdded()

enum GROUP_SHAPE {
	STANDARD,
	CIRCLE,
	SQUARE,
	WAVE
}

@export_category("Shape")
@export var groupShape: GROUP_SHAPE

@export_category("General")
@export var pegAmount: int = 64
@export var selfGenerate: bool = false

@export_category("Movement")
@export var animate: bool = false

@export_subgroup("Circle")
@export var rotationSpeed: float = 0.5

@export_subgroup("Wave")
@export var waveAmplitude: float = 24.0
@export var waveFrequency: float = 5.0
@export var waveDepth: int = 6
@export var waveWidth: int = 1

@export_subgroup("Square")
@export var squareSize: int = 8


var elapsedTime: float
var uniqueGenerated: bool


# lifecycle
func _ready() -> void:
	Events.OnGameStateChanged.connect(handle_state_change)
	Events.OnGameRestart.connect(clearPegs)

	rotation = 0
	await PegManager.on_pegs_loaded
	if selfGenerate:
		resetGroup()


func _process(delta: float) -> void:
	elapsedTime += delta
	if animate:
		match groupShape:
			GROUP_SHAPE.CIRCLE:
				if uniqueGenerated:
					rotation += delta * rotationSpeed
			GROUP_SHAPE.WAVE:
				if uniqueGenerated:
					animate_wave()



# animation
func animate_wave() -> void:
	if Global.gameSpeed == Game.GAME_SPEED.NORMAL:
		for child in get_children():
			if child is Peg:
				var childIdx: int = get_children().find(child)
				var rowIdx: int = childIdx / waveDepth
				var colIdx: int = childIdx / waveWidth
				var childRowIdx: int = childIdx - (rowIdx * waveDepth)

				child.position.y = (sin(elapsedTime + (childRowIdx * waveFrequency)) * waveAmplitude) + (rowIdx * 32.0) - ((waveWidth * 32) / 2)


# general
func handle_state_change(state: Game.GAME_STATE) -> void:
	match state:
		Game.GAME_STATE.BEGIN:
			pass

func clearPegs() -> void:
	for child in get_children():
		child.queue_free.call_deferred()

func resetGroup(animate: bool = true) -> void:
	elapsedTime = 0.0
	uniqueGenerated = false
	clearPegs()
	#generatePegs(true, animate)



# generation methods
func generatePeg(point: Vector2, pegColor: Color = Color.WHITE) -> void:
	var pegInst: Peg = PegManager.pegPrefabs[0].instantiate() as Peg
	add_child.call_deferred(pegInst)
	pegInst.setSpriteScale(Vector2(1.5, 1.5))
	pegInst.name = "Peg-" + str(randi())
	pegInst.position = point
	pegInst.modulate = pegColor
	pegInst.toggleCollisions(true)

func generatePegs(uniqueTypes: bool = true, animate: bool = true) -> void:
	var pegPrefab: PackedScene = load("res://Prefabs/Peg.tscn") as PackedScene

	match groupShape:
		GROUP_SHAPE.STANDARD:
			generateStandard(animate)
		GROUP_SHAPE.CIRCLE:
			generateCircle(animate)
		GROUP_SHAPE.SQUARE:
			generateSquare(animate)
		GROUP_SHAPE.WAVE:
			generateWave(animate)

func generateUniqueTypes() -> void:
	# add different peg types for each peg
	addPegType(PegManager.pegPrefabs[1], Global.bombPegAmount)
	await get_tree().create_timer(0.025).timeout
	addPegType(PegManager.pegPrefabs[3], 1)
	await get_tree().create_timer(0.025).timeout
	addPegType(PegManager.pegPrefabs[2], Global.multiPegAmount)
	await get_tree().create_timer(0.025).timeout
	uniqueGenerated = true
	OnUniqueAdded.emit()

func generateRing(amount: int, radius: float, odd: bool = false) -> void:
	var degAmnt: float = 360.0 / amount
	var angleAmnt: float = deg_to_rad(degAmnt)
	for a in amount:
		var calcAngle: float = a * angleAmnt
		if odd:
			calcAngle += deg_to_rad(degAmnt / 2)
		await get_tree().create_timer(0.025).timeout
		generatePeg(Vector2(cos(calcAngle), sin(calcAngle)) * radius)

func generateStandard(animate: bool = true) -> void:
	pass

func generateCircle(animate: bool = true) -> void:
	var rings: int = 4
	var radius: float = 30.0
	var increment: int = pegAmount / (rings * (rings + 1) / 2)
	for i in range(rings):
		var idx: int = i + 1
		var ringAmount: int = (increment * (i + 1))
		await get_tree().create_timer(0.025).timeout
		generateRing(ringAmount, idx * radius, idx % 2 == 0)

	OnGroupGenerated.emit()

func generateSquare(animate: bool = true) -> void:
	var rowAmount: int = squareSize
	var colAmount: int = squareSize
	var spacing: float = 32.0
	var halfX: float = ((rowAmount - 1) * spacing) / 2
	var halfY: float = ((colAmount - 1) * spacing) / 2

	for r in rowAmount:
		for c in colAmount:
			if animate:
				await get_tree().create_timer(0.025).timeout
			generatePeg((Vector2(r, c) * spacing) + Vector2(-halfX, -halfY))

	await get_tree().create_timer(0.025).timeout
	generateUniqueTypes()
	await OnUniqueAdded
	OnGroupGenerated.emit()

func generateWave(animate: bool = true) -> void:
	var rows: int = waveDepth
	var width: int = waveWidth

	for col in range(ceil(-width / 2.0), ceil(width / 2.0)):
		var isOdd: bool = col % 2
		var rowAmount: int = rows + (2 if isOdd else 0)
		for row in range(ceil(-rowAmount / 2.0), ceil(rowAmount / 2.0)):
			if animate:
				await get_tree().create_timer(0.025).timeout
			generatePeg(Vector2(row * 32, col * 32), Color.RED if isOdd else Color.WHITE)

	await get_tree().create_timer(0.025).timeout
	generateUniqueTypes()
	await OnUniqueAdded
	OnGroupGenerated.emit()

# special pegs
func addPegType(type: PackedScene, amnt: int = 1) -> void:
	var added: int
	var totalPegs: int = get_child_count()

	while added < amnt:
		var randomPeg: Peg = get_child(randi_range(0, totalPegs - 1)) as Peg
		var pegIdx: int = get_children().find(randomPeg)

		if randomPeg is Standard:
			var spawnedPeg: Peg = type.instantiate() as Peg
			spawnedPeg.name = "Peg-" + str(randi())
			spawnedPeg.position = randomPeg.position
			add_child(spawnedPeg)
			move_child(spawnedPeg, pegIdx)
			randomPeg.queue_free()
			added += 1

