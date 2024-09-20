@tool
class_name PegSet extends Node2D

enum SET_MOVEMENT {
	NONE,
	ROTATE,
	SWAY
}

@export_category("Movement")
@export var movement: SET_MOVEMENT

@export_subgroup("Rotation")
@export var clockwise: bool

var elapsedTime: float

func _ready() -> void:
	if not Engine.is_editor_hint():
		spawn_pegs()

func _draw() -> void:
	var markerNode: Node = get_node("Markers")
	for m in markerNode.get_children():
		if m is Marker2D:
			var markSize: float = 6.0
			draw_line(
				m.position + Vector2(-markSize, -markSize),
				m.position + Vector2(markSize, markSize),
				Color.RED,
				2.0
			)
			draw_line(
				m.position + Vector2(-markSize, markSize),
				m.position + Vector2(markSize, -markSize),
				Color.RED,
				2.0
			)

func _process(delta: float) -> void:
	queue_redraw()
	match movement:
		SET_MOVEMENT.ROTATE:
			rotation += delta if clockwise else -delta


func reset_pegs() -> void:
	clear_pegs()
	spawn_pegs()

func spawn_pegs() -> void:
	var pegPrefab: PackedScene = load("res://Prefabs/Pegs/Standard.tscn") as PackedScene
	var markerNode: Node = get_node("Markers")
	var pegNode: Node = get_node("Pegs")

	for marker in markerNode.get_children():
		var spawnedPeg: Peg = pegPrefab.instantiate() as Peg
		spawnedPeg.name = "Peg-" + str(markerNode.get_children().find(marker))
		pegNode.add_child(spawnedPeg)
		spawnedPeg.position = marker.position

func clear_pegs() -> void:
	var pegsNode: Node2D = get_node("Pegs") as Node2D
	for peg in pegsNode.get_children():
		peg.queue_free()
