class_name Sandbox extends Node2D

@onready var pegGroup: PegGroup = get_node("PegGroup") as PegGroup

func _ready() -> void:
	PegManager.on_pegs_loaded.connect(setup_pegs)
	PegManager.load_peg_prefabs()
	
	pegGroup.OnGroupGenerated.connect(func(): pegGroup.generateUniqueTypes())

func _process(delta) -> void:
	if Input.is_action_just_pressed("TestResetPegGroup"):
		if pegGroup:
			pegGroup.clearPegs()
			await get_tree().create_timer(0.25).timeout
			pegGroup.generatePegs(true)
	
	

func setup_pegs(status: PegManager.PEG_STATUS) -> void:
	pegGroup.generatePegs(true)
