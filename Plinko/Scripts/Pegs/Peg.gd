class_name Peg extends StaticBody2D

var breakPrefab: PackedScene = preload('res://Prefabs/PegBreak.tscn') as PackedScene
var partPrefab: PackedScene = preload('res://Prefabs/PegPart.tscn') as PackedScene

var spawnedBreak: GPUParticles2D
var toggled: bool = true



func _draw() -> void:
	draw_circle(Vector2.ZERO, 14.0, Color(0, 0, 0, 0.5))

func _process(delta) -> void:
	var spriteRef: Sprite2D = get_node("Sprite") as Sprite2D
	if spriteRef:
		spriteRef.scale = lerp(spriteRef.scale, Vector2.ONE, delta * 5.0)



func processCollision() -> void:
	hidePeg()
	spawnEffects()

func hidePeg() -> void:
	var spriteRef: Sprite2D = get_node('Sprite') as Sprite2D
	var collideRef: CollisionShape2D = get_node('Collider') as CollisionShape2D
	spriteRef.visible = false
	collideRef.set_disabled.call_deferred(true)

func spawnEffects() -> void:
	if breakPrefab:
		spawnParts()
		
		var soundEffect: AudioStreamPlayer2D = get_node("HitSound") as AudioStreamPlayer2D
		if soundEffect:
			soundEffect.pitch_scale = randf_range(0.85, 1.15)
			soundEffect.play()

func spawnParts() -> void:
	if partPrefab:
		var	partAngle: float = 360.0 / 6.0
		for i in 6:
			var spawnedPart: RigidBody2D = partPrefab.instantiate() as RigidBody2D
			get_tree().root.add_child(spawnedPart)
			var spawnDir: Vector2 = Vector2(cos(partAngle * i), sin(partAngle * i))
			spawnedPart.position =	global_position + spawnDir * 12.0
			spawnedPart.apply_central_impulse(spawnDir * 200.0)

			

func destroyPeg() -> void:
	if spawnedBreak:
		spawnedBreak.queue_free()
	queue_free.call_deferred()

func toggleCollisions(collisionsOn: bool = true) -> void:
	var spriteRef: Sprite2D = get_node('Sprite') as Sprite2D
	var collideRef: CollisionShape2D = get_node('Collider') as CollisionShape2D
		
	if collideRef:
		collideRef.set_disabled.call_deferred(not collisionsOn)
		
	if spriteRef:
		spriteRef.modulate.a = 1.0 if collisionsOn else 0.25

func setSpriteScale(newScale: Vector2) -> void:
	var spriteRef: Sprite2D = get_node("Sprite") as Sprite2D
	if spriteRef:
		spriteRef.scale = newScale
