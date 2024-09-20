extends ScreenContents

var perkItemPrefab: PackedScene = preload('res://Prefabs/UI/Perk.tscn') as PackedScene

@onready var perkList: Node = get_node('Vert/List') as Node


func _draw() -> void:
	pass



func RenderScreen() -> void:
	setupRandomPerks()

func UpdateScreen() -> void:
	setupRandomPerks()




func setupRandomPerks() -> void:
	clearPerkList()

	var randomPerks: Array = PerkManager.get_random_perks()
	for perk in randomPerks:
		addPerkItem(perk)

func clearPerkList() -> void:
	if perkList:
		for perkItem in perkList.get_children():
			perkItem.queue_free.call_deferred()

func addPerkItem(perkResource: PerkResource) -> void:
	var perkItem: Perk = perkItemPrefab.instantiate() as Perk
	perkItem.perkResource = perkResource
	perkList.add_child.call_deferred(perkItem)
