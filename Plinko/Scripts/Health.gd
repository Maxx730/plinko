class_name Health extends ProgressBar

func _process(delta) -> void:
	pass

func updateHealthValues() -> void:
	var label: Label = get_node("Label") as Label
	label.text = str(Global.currentHealth) + "/" + str(Global.playerHealth)
