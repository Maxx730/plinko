class_name Bumper extends Node2D


@onready var resetTimer: Timer = get_node('Reset') as Timer
@onready var bumperButton: StaticBody2D = get_node('Button') as StaticBody2D
@onready var buttonSprite: AnimatedSprite2D = get_node('Sprite') as AnimatedSprite2D
@onready var bumperCollider: CollisionShape2D = get_node('Button/Collider') as CollisionShape2D

var timeSinceCollision: float
var bumpResetTime: float = 1.0



func on_bumper_reset() -> void:
	bumperCollider.disabled = false
	buttonSprite.frame = 0

func on_ball_collided() -> void:
	resetTimer.start()
	bumperCollider.disabled = true
	buttonSprite.frame = 1
