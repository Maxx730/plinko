class_name Screen extends Control

signal OnTransitionOut()
signal OnTransitionIn()

@export_category("Details")
@export var screenTitle: String = "Screen"

@export_category("Contents")
@export var screenContents: PackedScene

@onready var screenFrame: Control = get_node('Content') as Control


func _ready() -> void:
	AddContent()

func _process(delta: float) -> void:
	scale = lerp(scale, Vector2.ONE, delta * 5.0)


func UpdateContents() -> void:
	var contentsRef: ScreenContents = screenFrame.get_child(0) as ScreenContents
	if contentsRef:
		contentsRef.UpdateScreen()

func AddContent() -> void:
	if screenContents:
		var spawnedContents = screenContents.instantiate()
		spawnedContents.anchor_left = 0.5
		spawnedContents.anchor_right = 0.5
		spawnedContents.anchor_top = 0.5
		spawnedContents.anchor_bottom = 0.5
		if screenFrame:
			screenFrame.add_child(spawnedContents)
			if spawnedContents is ScreenContents:
				spawnedContents.RenderScreen()


