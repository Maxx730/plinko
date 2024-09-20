extends Node

enum SECTION_STATUS {
	OK,
	ERROR
}

signal on_sections_loaded(status)

var sectionPrefabs: Array = []
var sectionsLoaded: bool

func load_section_prefabs() -> void:
	var prefabPath: String = "res://Prefabs/Board/Sections"
	var dirReader = DirAccess.open(prefabPath)

	if dirReader.dir_exists(prefabPath):
		dirReader.list_dir_begin()
		var file_name = dirReader.get_next()
		while file_name != "":
			if file_name != "." and file_name != "..":
				if file_name.to_lower().ends_with('.tscn'):
					var loadedPrefab = load(prefabPath + '/' + file_name)
					sectionPrefabs.append(loadedPrefab)
			file_name = dirReader.get_next()
		dirReader.list_dir_end()
		on_sections_loaded.emit(SECTION_STATUS.OK)
		sectionsLoaded = true
	else:
		printerr('ERROR: Resource directory does not exist.')
		on_sections_loaded.emit(SECTION_STATUS.ERROR)
