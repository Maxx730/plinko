class_name Mult extends Peg

func hidePeg() -> void:
	super()
	var typeSprite: Sprite2D = get_node('Mult') as Sprite2D
	typeSprite.visible = false
