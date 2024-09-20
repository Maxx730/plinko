class_name Clip extends Control

var ballResource: Resource = preload('res://Resources/BallResource.tres')
var currentClip: Array

@export var defaultBallTexture: Texture

signal OnBallsReloaded()

func _ready() -> void:
	clear_balls()


func add_ball(ballResource: Resource) -> void:
	currentClip.append(ballResource)
	var idx: int = currentClip.size() - 1
	get_child(idx).texture = ballResource.ballTexture

func clear_balls() -> void:
	currentClip.clear()


# ui
func clear_clip_ui() -> void:
	for child in get_children():
		if child is TextureRect:
			child.texture = defaultBallTexture

func update_clip_ui() -> void:
	clear_clip_ui()
	if currentClip.size() <= 8:
		for res in currentClip:
			var idx: int = currentClip.find(res)
			get_child(idx).texture = res.ballTexture


# util
func is_clip_empty() -> bool:
	return currentClip.size() == 0

func get_next_ball() -> Resource:
	var ballResource: Resource
	if not is_clip_empty():
		var ballIdx: int = currentClip.size() - 1
		ballResource = currentClip[ballIdx]
		currentClip.remove_at(ballIdx)
		get_child(ballIdx).texture = defaultBallTexture

	return ballResource

func reload_balls() -> void:
	clear_balls()
	await get_tree().create_timer(0.025).timeout
	for i in range(Global.ballAmount):
		add_ball(ballResource)

	OnBallsReloaded.emit()
