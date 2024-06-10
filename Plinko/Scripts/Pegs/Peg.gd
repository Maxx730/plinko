class_name Peg extends StaticBody2D

var breakPrefab: PackedScene = preload('res://Prefabs/PegBreak.tscn') as PackedScene

@onready var spriteRef: Sprite2D = get_node("Sprite") as Sprite2D
@onready var collideRef: CollisionShape2D = get_node("Collider") as CollisionShape2D
@onready var soundRef: AudioStreamPlayer2D = get_node("HitSound") as AudioStreamPlayer2D

var spawnedBreak: GPUParticles2D

func processCollision() -> void:
	hidePeg()
	spawnEffects()

func hidePeg() -> void:
	spriteRef.visible = false
	collideRef.set_disabled.call_deferred(true)

func spawnEffects() -> void:
	if breakPrefab:
		spawnedBreak = breakPrefab.instantiate() as GPUParticles2D
		spawnedBreak.finished.connect(destroyPeg)
		spawnedBreak.modulate = modulate
		get_tree().root.add_child(spawnedBreak)
		spawnedBreak.position = global_position
		spawnedBreak.restart()

func destroyPeg() -> void:
	if spawnedBreak:
		spawnedBreak.queue_free()
	queue_free.call_deferred()
