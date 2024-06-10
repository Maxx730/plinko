@tool
class_name DamageEffect extends Control

@export var damageText: String:
	set(text):
		damageText = text
		if Engine.is_editor_hint():
			update_letters()
@export var damageColor: Color = Color.RED
@export var fadeSpeed: float = 1.0
@export var moveSpeed: float = 15.0
@export var bounceAmplitude: float = 5.0
@export var bounceFrequency: float = 5.0
@export_range(1.0, 10.0) var bounceOffset: float = 5.0
@export var textFont: FontFile

var elapsedTime: float


func _process(delta: float) -> void:
	elapsedTime += delta
	wiggle_letters(delta, elapsedTime)
	if not Engine.is_editor_hint():
		position.y -= moveSpeed * delta
		modulate = lerp(modulate, Color.TRANSPARENT, delta * fadeSpeed)
		if is_zero_approx(modulate.a):
			queue_free.call_deferred()




func update_letters() -> void:
	clear_letters()
	await get_tree().create_timer(0.1).timeout
	generate_letters()

func clear_letters() -> void:
	get_node('hor').queue_free()
	for child in get_children():
		child.queue_free()

func generate_letters() -> void:
	var horizontalBox: HBoxContainer = HBoxContainer.new()
	horizontalBox.name = 'hor'
	horizontalBox.add_theme_constant_override('separation', 0)
	add_child(horizontalBox)
	horizontalBox.owner = get_tree().edited_scene_root

	var letters: PackedStringArray = damageText.split()
	for letter in letters:
		var letterLabel: Label = Label.new()
		letterLabel.name = str(letters.find(letter))
		letterLabel.text = letter
		letterLabel.modulate = damageColor

		if textFont:
			letterLabel.add_theme_font_override('font', textFont)

		horizontalBox.add_child(letterLabel)
		letterLabel.owner = get_tree().edited_scene_root
		await get_tree().create_timer(0.1).timeout

func wiggle_letters(delta: float, elapsed: float) -> void:
	var horBox: HBoxContainer = get_node('hor') as HBoxContainer
	for letter in horBox.get_children():
		if letter is Label:
			letter.position.y = sin((elapsedTime + horBox.get_children().find(letter) * bounceOffset) * bounceFrequency) * bounceAmplitude
