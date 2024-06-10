class_name Mult extends Peg

@onready var typeSprite: Sprite2D = get_node('Mult') as Sprite2D

func hidePeg() -> void:
	spriteRef.visible = false
	typeSprite.visible = false
	collideRef.set_disabled.call_deferred(true)
