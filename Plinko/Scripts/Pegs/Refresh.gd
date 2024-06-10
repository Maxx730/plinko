class_name Refresh extends Peg

@onready var typeSprite: Sprite2D = get_node('Refresh') as Sprite2D

func hidePeg() -> void:
	spriteRef.visible = false
	typeSprite.visible = false
	collideRef.disabled = true
