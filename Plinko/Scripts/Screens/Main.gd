class_name Main extends ScreenContents

@onready var startButton: TextureButton = get_node('Frame/Vert/Begin') as TextureButton
@onready var quitButton: TextureButton = get_node('Frame/Vert/Quit') as TextureButton

# lifecycle methods
func _ready() -> void:
	startButton.pressed.connect(StartRun)
	quitButton.pressed.connect(func(): get_tree().quit())



func RenderScreen() -> void:
	pass

func UpdateScreen() -> void:
	pass



func StartRun() -> void:
	Events.OnScreenChange.emit('Begin')
