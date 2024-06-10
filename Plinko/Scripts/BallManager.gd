extends Node

enum BALL_STATUS {
	OK,
	ERROR
}

signal on_resources_loaded(status: BALL_STATUS)

var ballResources: Array
var ballsLoaded: bool

func load_ball_resources() -> void:
	var resourcePath: String = "res://Resources/Balls"
	var dirReader = DirAccess.open(resourcePath)

	if dirReader.dir_exists(resourcePath):
		dirReader.list_dir_begin()
		var file_name = dirReader.get_next()
		while file_name != "":
			if file_name != "." and file_name != "..":
				if file_name.to_lower().ends_with('.tres'):
					var loadedResource = ResourceLoader.load(resourcePath + '/' + file_name)
					ballResources.append(loadedResource)
			file_name = dirReader.get_next()
		dirReader.list_dir_end()
		on_resources_loaded.emit(BALL_STATUS.OK)
		ballsLoaded = true
	else:
		printerr('ERROR: Resource directory does not exist.')
		on_resources_loaded.emit(BALL_STATUS.ERROR)
