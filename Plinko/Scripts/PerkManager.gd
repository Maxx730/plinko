extends Node

enum PERK_STATUS {
	OK,
	ERROR
}

signal on_resources_loaded(status: PERK_STATUS)

var perkResources: Array[PerkResource]
var perkList: Array[int]
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
		perkResources.shuffle()
		perksLoaded = true
	else:
		printerr('ERROR: Resource directory does not exist.')
		on_resources_loaded.emit(PERK_STATUS.ERROR)

func get_random_perk() -> PerkResource:
	var total_probability: float = 0.0
	for resource in perkResources:
		if resource is PerkResource:
			total_probability += resource.get_perk_chance()

	var rand_value: float = randf() * total_probability

	for resource in perkResources:
		if resource is PerkResource:
			if rand_value <= resource.get_perk_chance():
				return resource
			else:
				rand_value -= resource.get_perk_chance()
	return null

func get_random_perks(amnt: int = 3) -> Array:
	var randomPerks: Array = []
	while randomPerks.size() < amnt:
		var randomPerk: PerkResource = get_random_perk()

		if not randomPerks.has(randomPerk):
			randomPerks.append(randomPerk)

	return randomPerks

func get_perk_by_id(id: int) -> PerkResource:
	if perkResources.size() > 0:
		for resource in perkResources:
			if resource is PerkResource:
				if resource.perkID == id:
					return resource

	return null

func get_perks_by_type(type: PerkResource.PERK_LOCATION) -> void:
	pass
