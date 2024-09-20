extends Node

signal OnConfigLoaded()

var CONFIG_PATH: String = 'user://pegconfig.cfg'
var CONFIG_DESKTOP_MODE = 'desktopMode'

var config: ConfigFile = ConfigFile.new()

func load_config_file() -> void:
	var err = config.load(CONFIG_PATH)
	if err != OK:
		printerr('FALURE: Player configuration not loaded.')
		return
	OnConfigLoaded.emit()

func get_config_value(configSection, configName, configDefault):
	if config:
		return config.get_value(configSection, configName, configDefault)

func save_config_value(configSection, configName, configValue) -> void:
	if config:
		config.set_value(configSection, configName, configValue)
		config.save(CONFIG_PATH)

func debug_config_values() -> void:
	for section in config.get_sections():
		for key in config.get_section_keys(section):
			print('SECTION: ' + section + ' - KEY: ' + key + ' - VALUE: ' + str(config.get_value(section, key)))
