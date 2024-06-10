class_name Wound extends Node2D

@onready var redEffect: Panel = get_node("UI/Red") as Panel

func _ready() -> void:
	Events.OnPlayerDamaged.connect(visualizeWound)

func _process(delta) -> void:
	pass

func visualizeWound(amnt) -> void:
	var wounds: Node = get_node("Effects")
	var randId: int = randi_range(0, wounds.get_child_count() - 1)
	var chosenAnim: AnimatedSprite2D = wounds.get_child(randId) as AnimatedSprite2D
	await get_tree().create_timer(0).timeout
	chosenAnim.visible = true
	chosenAnim.play()
