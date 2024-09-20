@tool
class_name Aim extends Node2D

@export var clawClosedSprite: Texture2D
@export var clawOpenSprite: Texture2D



var elapsedTime: float


func _draw() -> void:
	draw_line(Vector2.ZERO, Vector2(0, 1) * 25.0, Color.RED)

func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		if Global.gameSpeed == Game.GAME_SPEED.NORMAL:
			if Global.gameState == Game.GAME_STATE.DROPPING:
				var sinVal: float = sin(elapsedTime * 2.5)
				position.x = sinVal * 100.0
				elapsedTime += delta

				rotation_degrees = sinVal * -12
				queue_redraw()
			else:
				position.x = lerp(position.x, 0.0, delta * 5.0)
				rotation_degrees = lerp(rotation_degrees, 0.0, delta)

			update_sprite(not Global.gameState == Game.GAME_STATE.DROPPING)


func update_sprite(open: bool) -> void:
	var clawSprite: Sprite2D = get_node("Claw") as Sprite2D
	if clawSprite:
		clawSprite.texture = clawOpenSprite if open else clawClosedSprite
