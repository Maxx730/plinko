class_name PerkResource extends Resource

const COMMON_PROB: float = 0.6
const UNCOMMON_PROB: float = 0.1
const RARE_PROB: float = 0.05

const COMMON_COLOR: Color = Color('#68de59')
const UNCOMMON_COLOR: Color = Color('#de1ff6')
const RARE_COLOR: Color = Color('#ff033e')

enum PERK_LOCATION {
	DROP,
	PEG,
	SCORE
}

enum PERK_TYPE {
	ADD,
	MULTIPLY
}

enum ADD_TYPE {
	BALL,
	POWER,
	LAUNCH,
	REFRESH_PEG,
	MULT_PEG,
	BOMB_PEG
}

enum PERK_CHANCE {
	COMMON,
	UNCOMMON,
	RARE
}

@export var perkName: String
@export var perkDescription: String
@export var perkLocation: PERK_LOCATION
@export var perkChance: PERK_CHANCE
@export var perkType: PERK_TYPE
@export var perkAddType: ADD_TYPE

func get_perk_chance() -> float:
	match perkChance:
		PERK_CHANCE.COMMON:
			return COMMON_PROB
		PERK_CHANCE.UNCOMMON:
			return UNCOMMON_PROB
		PERK_CHANCE.RARE:
			return RARE_PROB

	return 0.0
