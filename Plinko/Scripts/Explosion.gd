class_name Explosion extends Area2D


func _ready() -> void:
	body_entered.connect(on_body_exploded)


func despawn_exp() -> void:
	queue_free.call_deferred()

func explode() -> void:
	var particleEffect: GPUParticles2D = get_node('Center') as GPUParticles2D
	if particleEffect:
		particleEffect.restart()

func on_body_exploded(body) -> void:
	if body is Peg:
		if body is Bomb:
			body.hidePeg()
			body.destroyPeg()
		else:
			Events.OnPegCollided.emit(body, body.position)
			body.processCollision()

