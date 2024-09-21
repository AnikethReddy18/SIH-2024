extends Control

@onready var ground_water_label: Label = $StatsHContainer/GroundWaterVContainer/GroundWaterLabel
@onready var coins_label: Label = $StatsHContainer/CoinsVContainer/CoinsLabel
@onready var moat_water_level_bar: ProgressBar = $MoatWaterLevelBar
@onready var turn_on_pump_button: Button = $TurnOnPumpButton

func _ready() -> void:
	Globals.water_level_change.connect(_on_ground_water_level_changed)
	Globals.coins_change.connect(_on_coins_amount_changed)
	Globals.moat_water_level_changed.connect(_on_moat_water_level_changed)
	turn_on_pump_button.pressed.connect(_on_turn_on_pump_button_pressed)

func _on_ground_water_level_changed():
	ground_water_label.text = str(Globals.water_level) + "%"
	
func _on_coins_amount_changed():
	coins_label.text = ": " + str(Globals.coins)
	
func _on_moat_water_level_changed():
	moat_water_level_bar.value = Globals.moat_water_level
	
func _on_turn_on_pump_button_pressed():
	var diff = 100 - Globals.moat_water_level
	var available_water = Globals.water_level - diff
	
	if available_water>0:
		Globals.water_level -= diff
		Globals.moat_water_level += diff
	else:
		Globals.moat_water_level += Globals.water_level
		Globals.water_level = 0	
		
