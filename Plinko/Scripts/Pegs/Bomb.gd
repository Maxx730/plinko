class_name Bomb extends Peg

var explodePrefab: PackedScene = preload('res://Prefabs/Explosion.tscn') as PackedScene

func spawnEffects() -> void:
	super()
	var spawnedExplosion: Explosion = explodePrefab.instantiate() as Explosion
	spawnedExplosion.position = global_position
	get_tree().root.add_child.call_deferred(spawnedExplosion)
	spawnedExplosion.explode()

func hidePeg() -> void:
	super()
	var fuseRef: Node2D = get_node('Fuse') as Node2D
	if fuseRef:
		fuseRef.visible = false
