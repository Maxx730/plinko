@tool
class_name Board extends Node2D

signal OnGroupsLoaded()
signal OnPegsReset()

@export var boardLength: int = 3:
	set(length):
		if Engine.is_editor_hint():
			boardLength = length
			clear_sections()
			await get_tree().create_timer(0.25).timeout
			build_sections()
			await get_tree().create_timer(0.25).timeout
			align_ends()
			await get_tree().create_timer(0.25).timeout
			align_bottom_spikes()
			await get_tree().create_timer(0.25).timeout
			update_background_size()


func _ready() -> void:
	connect_events()



func connect_events() -> void:
	pass

func resetPegs(animate: bool = true) -> void:
	var sectionNode: Node = get_node("Sections") as Node
	for child in sectionNode.get_children():
		if child is BoardSection:
			child.reset_pegs()

	OnPegsReset.emit()

func clear_sections() -> void:
	var sectionNode: Node = get_node("Sections")
	for section in sectionNode.get_children():
		section.queue_free()

func build_sections() -> void:
	var sectionPrefabs: Array[PackedScene] = [
		load("res://Prefabs/Board/Sections/Type3.tscn"),
		load("res://Prefabs/Board/Sections/Type2.tscn"),
		load("res://Prefabs/Board/Sections/Type1.tscn")
	]
	var sectionPrefab: PackedScene = load("res://Prefabs/Board/Sections/Type3.tscn") as PackedScene
	var sectionNode: Node = get_node("Sections")
	for i in boardLength:
		var spawnedSection: BoardSection = sectionPrefabs[randi_range(0, sectionPrefabs.size() - 1)].instantiate() as BoardSection

		spawnedSection.name = "Section-" + str(i)
		sectionNode.add_child(spawnedSection)
		spawnedSection.owner = get_tree().edited_scene_root
		spawnedSection.position.y = i * spawnedSection.get_height()

func align_ends() -> void:
	var spawnNode: Spawn = get_node("Colliders/Spawn") as Spawn
	var despawnNode: Despawn = get_node("Colliders/Despawn") as Despawn

	if get_node("Sections").get_children().size() > 0:
		var firstSection: BoardSection = get_node("Sections").get_children()[0] as BoardSection
		var lastSection: BoardSection = get_node("Sections").get_children()[get_node("Sections").get_child_count() - 1] as BoardSection
		spawnNode.position.y = -(firstSection.get_height() / 2) + 72
		despawnNode.position.y = (lastSection.get_height() * (get_node("Sections").get_child_count() - 1)) + (lastSection.get_height() / 2)

func align_bottom_spikes() -> void:
	var spikeNode: Node2D = get_node("Colliders/Spikes") as Node2D
	var sectionCount: int = get_node("Sections").get_child_count()

	if sectionCount > 0:
		var lastSection: BoardSection = get_node("Sections").get_children()[sectionCount - 1] as BoardSection
		spikeNode.position = lastSection.position + Vector2(0, -32)

func update_background_size() -> void:
	var topNode: Sprite2D = get_node("Top/Sprite") as Sprite2D
	var backgroundNode: Sprite2D = get_node("Top/Background") as Sprite2D
	var boardHeight: float = (boardLength * 648) + (topNode.get_rect().size.y / 2)
	backgroundNode.region_rect.size.y = boardHeight
	backgroundNode.position.y = (boardHeight / 2) - 324 - (topNode.get_rect().size.y / 2)
