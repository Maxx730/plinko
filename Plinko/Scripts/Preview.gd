class_name Preview extends Line2D

@onready var aimCheck: RayCast2D = get_node('Check') as RayCast2D

func _draw() -> void:
	if points.size() > 0 and aimCheck:
		for point in points:
			var idx: int = points.find(point)
			if idx % 6 == 0:
				draw_circle(point, 2.0, Color(1.0, 1.0, 1.0, 0.25))

		if aimCheck.is_colliding():
			draw_circle(aimCheck.get_collision_point(), 3.0, Color.RED)

func _process(delta: float) -> void:
	if points.size() > 0:
		var lastPoint: Vector2 = points[points.size() - 1]
		var secondToLastPoint: Vector2 = points[points.size() - 2]
		var dir: Vector2 = secondToLastPoint - lastPoint
		aimCheck.position = lastPoint
		aimCheck.rotation = dir.rotated(rotation).angle() + deg_to_rad(90)
		queue_redraw()
