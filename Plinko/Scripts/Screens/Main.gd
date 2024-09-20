class_name Main extends ScreenContents

@onready var startButton: WackyButton = get_node('Frame/Vert/Begin') as WackyButton
@onready var quitButton: WackyButton = get_node('Frame/Vert/Quit') as WackyButton
@onready var settingsButton: WackyButton = get_node("Frame/Vert/Settings") as WackyButton

# lifecycle methods
func _ready() -> void:
	startButton.OnPressed.connect(StartRun)
	settingsButton.OnPressed.connect(OpenSettings)
	quitButton.OnPressed.connect(func(): get_tree().quit())



func RenderScreen() -> void:
	pass

func UpdateScreen() -> void:
	pass



func StartRun() -> void:
	Events.OnScreenChange.emit('Begin')

func OpenSettings() -> void:
	Events.OnScreenChange.emit('Settings')
