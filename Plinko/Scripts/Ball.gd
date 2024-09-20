@tool
class_name Ball extends CharacterBody2D

const baseBounce: float = 250.0

enum IMPACT_TYPE {
	STANDARD,
	PIERCE,
	EXPLODE
}

var impactPrefab: PackedScene = preload("res://Prefabs/Impact.tscn") as PackedScene
var damagePrefab: PackedScene = preload("res://Prefabs/Damage.tscn") as PackedScene

var ballVelocity: Vector2 = Vector2(0, Global.ballGravity)
var lastHitPeg: Peg
var lastHitTime: float
var trailRef: Line2D
var trailLength: int = 7


# lifecycle
func _ready() -> void:
	spawn_trail()

func _integrate_forces(state) -> void:
	if not Engine.is_editor_hint():
		rotation = 0

func _process(delta) -> void:
	if not Engine.is_editor_hint():
		if Global.gameState == Game.GAME_STATE.FALLING:
			lastHitTime += delta

func _physics_process(_delta) -> void:
	if not Engine.is_editor_hint() and Global.gameSpeed == Game.GAME_SPEED.NORMAL:
		match Global.gameState:
			Game.GAME_STATE.FALLING:
				velocity += Vector2(0, Global.ballGravity)
				move_and_slide()
				handle_collisions()
				update_trail()




# collisions
func handle_collisions() -> void:
	if get_slide_collision_count() > 0:
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			handle_collision(collision)

func handle_collision(collision: KinematicCollision2D) -> void:
	if collision.get_collider() is Peg:
		var peg: Peg = collision.get_collider() as Peg
		var colDir: Vector2 = collision.get_normal()
		velocity = colDir * baseBounce * Global.ballBounciness
		if peg != lastHitPeg or (lastHitPeg == peg and lastHitTime > 0.05):
			var impactPoint: Vector2 = collision.get_position()
			peg.processCollision()
			lastHitPeg = peg
			lastHitTime = 0
			Events.OnPegCollided.emit(peg, impactPoint)

	if collision.get_collider().is_in_group('Wall'):
		var colDir: Vector2 = collision.get_normal()
		velocity = colDir * 175.0

	if collision.get_collider().is_in_group('Bumper'):
		var colDir: Vector2 = collision.get_normal()
		velocity = colDir * 520
		if collision.get_collider().get_parent() is Bumper:
			collision.get_collider().get_parent().on_ball_collided()

	if collision.get_collider().is_in_group('Platform'):
		var colDir: Vector2 = collision.get_normal()
		var platform: Platform = collision.get_collider() as Platform

		platform.toggleCollision(true)
		velocity = colDir * Global.platformPower

func handle_standard_collision() -> void:
	pass

func handle_pierce_collision() -> void:
	pass

func handle_explode_collision() -> void:
	pass


# util
func get_ball_texture() -> Texture:
	return $Sprite.texture


# trail
func spawn_trail() -> void:
	trailRef = Line2D.new()
	trailRef.default_color = Color(1.0, 1.0, 1.0, 0.25)
	trailRef.width = 13.0
	trailRef.end_cap_mode = Line2D.LINE_CAP_ROUND
	trailRef.begin_cap_mode = Line2D.LINE_CAP_ROUND
	get_tree().root.add_child(trailRef)

func update_trail() -> void:
	if trailRef:
		if trailRef.points.size() > trailLength:
			trailRef.remove_point(0)
		trailRef.add_point(position)

func toggle_fire(val: bool = false) -> void:
	var fireRef: GPUParticles2D = get_node('Fire') as GPUParticles2D
	if fireRef:
		fireRef.emitting = val
