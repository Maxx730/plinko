class_name Platform extends StaticBody2D

@export var horizontalAmount: float = 50.0
@export var swayFrequency: float = 3.0
@export var toggleReset: float = 0.5
@export var platformTexture: Texture
@export var ghostTexture: Texture

var elapsedTime: float
var lastReset: float

@onready var platformSprite: Sprite2D = get_node('Sprite') as Sprite2D
@onready var platformCollider: CollisionShape2D = get_node('Collider') as CollisionShape2D


func _process(delta: float) -> void:
	elapsedTime += delta
	lastReset += delta

	position = Vector2(sin(elapsedTime * Global.platformSpeed) * horizontalAmount, position.y)
	if lastReset > toggleReset:
		toggleCollision(false)

func toggleCollision(val: bool) -> void:
	lastReset = 0
	platformCollider.disabled = val
	platformSprite.texture = platformTexture if not val else ghostTexture
