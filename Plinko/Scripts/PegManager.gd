extends Node

enum PEG_STATUS {
	OK,
	ERROR
}

signal on_pegs_loaded(status)

var pegPrefabs: Array = []
var pegsLoaded: bool

func load_peg_prefabs() -> void:
	var prefabPath: String = "res://Prefabs/Pegs"
	var dirReader = DirAccess.open(prefabPath)

	if dirReader.dir_exists(prefabPath):
		dirReader.list_dir_begin()
		var file_name = dirReader.get_next()
		while file_name != "":
			if file_name != "." and file_name != "..":
				if file_name.to_lower().ends_with('.tscn'):
					var loadedPrefab = load(prefabPath + '/' + file_name)
					pegPrefabs.append(loadedPrefab)
			file_name = dirReader.get_next()
		dirReader.list_dir_end()
		on_pegs_loaded.emit(PEG_STATUS.OK)
		pegsLoaded = true
	else:
		printerr('ERROR: Resource directory does not exist.')
		on_pegs_loaded.emit(PEG_STATUS.ERROR)
