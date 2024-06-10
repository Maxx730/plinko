class_name Impact extends AnimatedSprite2D

func _ready() -> void:
	play()

func despawnImpact() -> void:
	queue_free.call_deferred()
