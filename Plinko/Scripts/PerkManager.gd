extends Node

enum PERK_STATUS {
	OK,
	ERROR
}

signal on_resources_loaded(status: PERK_STATUS)

var perkResources: Array
var perksLoaded: bool

func load_perk_resources() -> void:
	var resourcePath: String = "res://Resources/Perks"
	var dirReader = DirAccess.open(resourcePath)

	if dirReader.dir_exists(resourcePath):
		dirReader.list_dir_begin()
		var file_name = dirReader.get_next()
		while file_name != "":
			if file_name != "." and file_name != "..":
				if file_name.to_lower().ends_with('.tres'):
					var loadedResource = ResourceLoader.load(resourcePath + '/' + file_name)
					perkResources.append(loadedResource)
			file_name = dirReader.get_next()
		dirReader.list_dir_end()
		on_resources_loaded.emit(PERK_STATUS.OK)
		perksLoaded = true
	else:
		printerr('ERROR: Resource directory does not exist.')
		on_resources_loaded.emit(PERK_STATUS.ERROR)

