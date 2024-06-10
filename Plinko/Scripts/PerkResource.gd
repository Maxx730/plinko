extends Resource

enum PERK_LOCATION {
	DROP,
	PEG,
	SCORE
}

@export var perkName: String
@export var perkDescription: String
@export var perkLocation: PERK_LOCATION

