class_name MonsterDamage extends Node

@onready var damageSprite: AnimatedSprite2D = get_node("Sprite") as AnimatedSprite2D
@onready var monsterIconRef: Sprite2D = get_node('../Icon') as Sprite2D
@onready var damageSound: AudioStreamPlayer2D = get_node("Sound") as AudioStreamPlayer2D

var shakeStart: float = 0.26
var shakeTime: float = 0.25

func _ready() -> void:
	Events.OnMonsterDamaged.connect(animateDamage)

func _process(delta) -> void:
	if shakeStart < shakeTime:
		monsterIconRef.offset = Vector2(
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0)
		)

	shakeStart += delta

func onDamageComplete() -> void:
	damageSprite.visible = false

func animateDamage() -> void:
	shakeStart = 0.0
	damageSprite.visible = true
	damageSprite.play()
	damageSound.play()
