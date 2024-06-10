@tool
class_name Perk extends BaseButton

var mouseHover: bool
var elapsedTime: float

@export var perkResource: Resource:
	set(pres):
		perkResource = pres
		updatePerkValues()


func _ready() -> void:
	mouse_entered.connect(onMouseEntered)
	mouse_exited.connect(onMouseExited)
	pressed.connect(func(): Events.OnScreenChange.emit('Begin'))

func _process(delta: float) -> void:
	elapsedTime += delta
	if mouseHover:
		modulate.r = (sin(elapsedTime * 5.0) * 0.5) + 1.0
	else:
		modulate = lerp(modulate, Color.WHITE, delta * 12.0)



func updatePerkValues() -> void:
	var titleNode: Label = get_node('List/Top/Name') as Label
	var descNode: Label = get_node('List/Bottom/Description') as Label

	if titleNode:
		titleNode.text = perkResource.perkName

	if descNode:
		descNode.text = perkResource.perkDescription

func onMouseEntered() -> void:
	mouseHover = true

func onMouseExited() -> void:
	mouseHover = false
