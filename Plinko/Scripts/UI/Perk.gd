@tool
class_name Perk extends BaseButton

var mouseHover: bool
var elapsedTime: float
var hoverScale: float = 1.1
var scaleSpeed: float = 8.0

@export var perkResource: Resource:
	set(pres):
		perkResource = pres
		updatePerkValues()

func _ready() -> void:
	mouse_entered.connect(onMouseEntered)
	mouse_exited.connect(onMouseExited)
	pressed.connect(onPerkPressed)
	pivot_offset.y = get_rect().size.y / 2

func _process(delta: float) -> void:
	elapsedTime += delta
	if mouseHover:
		scale = lerp(scale, Vector2(hoverScale, hoverScale), delta * scaleSpeed)
		rotation = deg_to_rad(sin(elapsedTime * 8.0) * 2.0)
	else:
		scale = lerp(scale, Vector2.ONE, delta * scaleSpeed)
		rotation = 0



func updatePerkValues() -> void:
	var titleNode: Label = get_node('List/Top/Margin/Items/Labels/Name') as Label
	var rarityLabel: Label = get_node('List/Top/Margin/Items/Labels/Rarity') as Label
	var titleBadge: TextureRect = get_node('List/Top/Margin/Items/Badge') as TextureRect
	var descNode: Label = get_node('List/Bottom/Content/Margin/Description') as Label

	if titleNode:
		titleNode.text = perkResource.perkName
		rarityLabel.text = str(PerkResource.PERK_CHANCE.keys()[perkResource.perkChance])

	if descNode:
		descNode.text = perkResource.perkDescription

	match perkResource.perkChance:
		PerkResource.PERK_CHANCE.COMMON:
			titleBadge.modulate = PerkResource.COMMON_COLOR
		PerkResource.PERK_CHANCE.UNCOMMON:
			titleBadge.modulate = PerkResource.UNCOMMON_COLOR
		PerkResource.PERK_CHANCE.RARE:
			titleBadge.modulate = PerkResource.RARE_COLOR

func onMouseEntered() -> void:
	mouseHover = true

func onMouseExited() -> void:
	mouseHover = false

func onPerkPressed() -> void:
	match perkResource.perkType:
		PerkResource.PERK_TYPE.ADD:
			match perkResource.perkAddType:
				PerkResource.ADD_TYPE.BALL:
					if Global.ballAmount + 1 <= 8:
						Global.ballAmount += 1
				PerkResource.ADD_TYPE.BOMB_PEG:
					Global.bombPegAmount += 1
				PerkResource.ADD_TYPE.MULT_PEG:
					Global.multiPegAmount += 1
				PerkResource.ADD_TYPE.REFRESH_PEG:
					Global.refreshPegAmount += 1

	Events.OnScreenChange.emit('Begin')
