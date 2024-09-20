@tool
class_name BoardSection extends Node2D

func _ready() -> void:
	var areaNode: Area2D = get_node("Entrance") as Area2D
	areaNode.body_entered.connect(on_ball_entered)

func get_height() -> float:
	var backgroundSprite: Sprite2D = get_node("Walls") as Sprite2D
	return backgroundSprite.get_rect().size.y

func on_ball_entered(body) -> void:
	if body is Ball:
		Events.OnBoardSectionEntered.emit(self)

func reset_pegs() -> void:
	if has_node("Pegs"):
		var pegSetNode: Node = get_node("Pegs") as Node
		for child in pegSetNode.get_children():
			if child is PegSet:
				child.reset_pegs()
