extends Control

@onready var ground_water_label: Label = $StatsHContainer/GroundWaterVContainer/GroundWaterLabel
@onready var coins_label: Label = $StatsHContainer/CoinsVContainer/CoinsLabel
@onready var moat_water_level_bar: ProgressBar = $MoatWaterLevelBar

func _ready() -> void:
	Globals.water_level_change.connect(_on_ground_water_level_changed)
	Globals.coins_change.connect(_on_coins_amount_changed)

func _on_ground_water_level_changed():
	ground_water_label.text = str(Globals.water_level) + "%"
	
func _on_coins_amount_changed():
	coins_label.text = ": " + str(Globals.coins)
		
