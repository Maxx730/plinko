@tool
class_name Aim extends Node2D

@onready var shotCheck: RayCast2D = get_node('Check') as RayCast2D
@onready var shotTrace: Line2D = get_tree().root.get_node('Game/Board/Effects/Preview') as Line2D
@onready var shotPoint: Sprite2D = get_node('X') as Sprite2D


var elapsedTime: float


func _draw() -> void:
	pass

func _process(delta: float) -> void:
	queue_redraw()
	if not Engine.is_editor_hint():
		elapsedTime += delta
		if Global.gameState == Game.GAME_STATE.DROPPING and Input.is_action_pressed('DropBall'):
			var mousePoint: Vector2 = get_global_mouse_position() as Vector2
			var direction: Vector2 = (mousePoint - position).normalized() as Vector2

			rotation = direction.angle()

			handle_check()
			var sizeScale = sin(elapsedTime * 5.0) * 0.5 + 1.0
			shotPoint.scale = Vector2(sizeScale, sizeScale)
		else:
			shotPoint.visible = false
			shotTrace.points = []







func handle_check() -> void:
	if shotTrace:
		shotTrace.points = emulate_points(global_position + Vector2(16, 0).rotated(rotation), 60)

func emulate_points(initialPosition: Vector2, frames: int) -> Array:
	var points: Array = []
	var time_step: float = 1.0 / 60.0
	var initialVelocity: Vector2 = Vector2(1, 0).rotated(rotation) * Global.launchPower

	for i in range(frames):
		var time = i * time_step
		var x = initialPosition.x + initialVelocity.x * time
		var y = initialPosition.y + initialVelocity.y * time + 0.5 * 100 * time * time
		points.append(Vector2(x, y))

	return points
