class_name Despawn extends Area2D

var ballDestroyedPrefab: PackedScene = preload("res://Prefabs/BallDestroyed.tscn") as PackedScene

func _process(delta: float) -> void:
	match Global.gameState:
		Game.GAME_STATE.FALLING:
			pass

func AllBallsDestroyed() -> bool:
	var spawnedBalls: Array = get_tree().get_nodes_in_group('Ball')
	return spawnedBalls.size() == 0

func OnDespawnEntered(body) -> void:
	if body.is_in_group('PleaseDestroy'):
		body.queue_free()
	else:
		if body is Ball:
			var destroyedParticle: GPUParticles2D = ballDestroyedPrefab.instantiate() as GPUParticles2D
			get_tree().root.get_node("Game").add_child(destroyedParticle)
			destroyedParticle.position = Vector2(body.position.x, position.y)
			destroyedParticle.finished.connect(func(): destroyedParticle.queue_free())
			destroyedParticle.restart()

			if body.trailRef:
				body.trailRef.queue_free()

			body.queue_free()

			Events.OnBallDestroyed.emit()
			await get_tree().create_timer(0.5).timeout
			Global.gameState = Game.GAME_STATE.CALCULATING
			Events.OnGameStateChanged.emit(Global.gameState)

