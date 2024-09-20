class_name Refresh extends Peg

func hidePeg() -> void:
	super()
	var typeSprite: Sprite2D = get_node('Refresh') as Sprite2D
	typeSprite.visible = false
