class_name Loading extends ScreenContents

@onready var progressBar: ProgressBar = get_node('List/Progress')
@onready var loadingLabel: Label = get_node('List/Label') as Label

signal on_loading_complete()

var targetValue: float


func _ready() -> void:
	if not PerkManager.perksLoaded:
		load_perks()

func _process(_delta: float) -> void:
	if progressBar:
		progressBar.value = move_toward(progressBar.value, targetValue, 5)

		if is_equal_approx(progressBar.value, 100.0):
			Utils.print_success('Loading complete!')
			Events.OnLoadingComplete.emit()
			targetValue = 0.0
			progressBar.value = 0


func load_sections() -> void:
	loadingLabel.text = "Loading Sections..."
	SectionManager.on_sections_loaded.connect(on_sections_loaded)
	SectionManager.load_section_prefabs()

func on_sections_loaded(status) -> void:
	if status == SectionManager.SECTION_STATUS.OK:
		Utils.print_success(str(SectionManager.sectionPrefabs.size()) + ' sections loaded!')
		targetValue = 100.0
	else:
		printerr('ERROR: Unable to load sections.')

func load_pegs() -> void:
	loadingLabel.text = "Loading Pegs..."
	PegManager.on_pegs_loaded.connect(on_pegs_loaded)
	PegManager.load_peg_prefabs()

func on_pegs_loaded(status) -> void:
	if status == PegManager.PEG_STATUS.OK:
		Utils.print_success(str(PegManager.pegPrefabs.size()) + ' pegs loaded!')
		targetValue = 75.0
		await get_tree().create_timer(0.5).timeout
		load_sections()
	else:
		printerr('ERROR: Unable to load perks.')

func load_balls() -> void:
	loadingLabel.text = "Loading Balls..."
	BallManager.on_resources_loaded.connect(on_balls_loaded)
	BallManager.load_ball_resources()

func on_balls_loaded(status) -> void:
	if status == BallManager.BALL_STATUS.OK:
		Utils.print_success(str(BallManager.ballResources.size()) + ' balls loaded!')
		targetValue = 50.0
		await get_tree().create_timer(0.5).timeout
		load_pegs()
	else:
		printerr('ERROR: Unable to load perks.')

func load_perks() -> void:
	loadingLabel.text = "Loading Perks..."
	PerkManager.on_resources_loaded.connect(on_perks_loaded)
	PerkManager.load_perk_resources()

func on_perks_loaded(status) -> void:
	if status == PerkManager.PERK_STATUS.OK:
		Utils.print_success(str(PerkManager.perkResources.size()) + ' perks loaded!')
		targetValue = 25.0
		await get_tree().create_timer(0.5).timeout
		load_balls()
	else:
		printerr('ERROR: Unable to load perks.')
