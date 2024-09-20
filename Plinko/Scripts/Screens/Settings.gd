class_name Settings extends ScreenContents

@onready var desktopModeToggle: CheckButton = get_node("Layout/Frame/Margin/Vert/List/Item/Margin/Hor/Toggle") as CheckButton
@onready var backButton: WackyButton = get_node("Layout/Back") as WackyButton

func RenderScreen() -> void:
	desktopModeToggle.toggled.connect(on_desktop_mode_changed)
	desktopModeToggle.button_pressed = Config.get_config_value('general', 'desktop_mode', false)
	
	Config.debug_config_values()
	
func on_desktop_mode_changed(mode) -> void:
	if mode:
		DisplayServer.window_set_size(Vector2(1600, 1560), 0)
		get_tree().root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
	else:
		DisplayServer.window_set_size(Vector2(720, 1560), 0)
		get_tree().root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP_HEIGHT
		
	Events.OnDesktopModeChanged.emit(mode)
	Config.save_config_value('general', 'desktop_mode', mode)

func go_back() -> void:
	Events.OnScreenChange.emit('Main')
