class_name ScreenManager extends Node

func _ready() -> void:
	Events.OnScreenChange.connect(TransitionToScreen)
	Events.OnHideScreens.connect(HideScreens)
	Events.OnScreenChange.emit('Loading')
	Events.OnDesktopModeChanged.connect(OnDesktopModeChanged)

func GetScreenByName(screenName: String) -> Screen:
	var foundScreen: Screen
	for screen in get_children():
		if screen is Screen:
			if screen.screenTitle == screenName:
				foundScreen = screen
	return foundScreen

func TransitionToScreen(screenName: String) -> void:
	HideScreens()
	if screenName != "Hide":
		var chosenScreen: Screen = GetScreenByName(screenName)
		chosenScreen.UpdateContents()
		chosenScreen.visible = true

func OnDesktopModeChanged(mode) -> void:
	await get_tree().create_timer(1.0).timeout
	for screen in get_children():
		if screen is Screen:
			screen.UpdateSize()

func HideScreens() -> void:
	for screen in get_children():
		if screen is Screen:
			screen.visible = false
