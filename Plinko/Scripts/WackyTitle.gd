@tool
class_name WackyTitle extends HBoxContainer

@export_range(0.0, 1.0) var letterScaleSize: float = 0.5
@export var letterRockSpeed: float = 5.0
@export var letterRockAmount: float = 12.0
@export var wackyFont: Font:
	set(font):
		wackyFont = font
		if Engine.is_editor_hint():
			clear_text()
			await get_tree().create_timer(0.05).timeout
			generate_text()
@export var wackyText: String = "Default Text":
	set(text):
		wackyText = text
		if Engine.is_editor_hint():
			clear_text()
			await get_tree().create_timer(0.05).timeout
			generate_text()
		
var focusedChar: int
var elapsedTime: float
var currentScale: float
var targetScale: float = letterScaleSize



func _process(delta) -> void:
	elapsedTime += delta
	animate_text(delta, elapsedTime)

		
		
func clear_text() -> void:
	for child in get_children():
		child.queue_free()
	
func generate_text() -> void:
	add_theme_constant_override("separation", 0)
	for character in wackyText.length():
		var char: String = wackyText[character]
		var spawnedLabel: Label = Label.new()
		
		if wackyFont:
			spawnedLabel.add_theme_font_override("font", wackyFont)
			#spawnedLabel.add_theme_constant_override("outline_size", 24)
			spawnedLabel.add_theme_color_override("font_outline_color", Color.BLACK)
		
		spawnedLabel.name = str(character)
		spawnedLabel.text = char
		spawnedLabel.add_theme_font_size_override("font_size", 48)
		spawnedLabel.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		add_child(spawnedLabel)
		spawnedLabel.owner = get_tree().edited_scene_root

func animate_text(delta, elapsed) -> void:
	if get_child_count() > 0:
		for child in get_children():
			if child is Label:
				var childIdx: int = get_children().find(child)
				var isOdd: bool = childIdx % 2 == 0
				child.rotation_degrees = sin((elapsedTime + childIdx) * letterRockSpeed) * (letterRockAmount if isOdd else -letterRockAmount)
				child.pivot_offset = Vector2(8, 16)
