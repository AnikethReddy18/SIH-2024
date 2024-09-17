extends Sprite2D

@onready var water_flow = $WaterFlow
@onready var turn_on_pump_button = $"../UI/InGame/TurnOnPumpButton"
@onready var water_layer = $"../Tilemap/Water"


# Called when the node enters the scene tree for the first time.
func _ready():
	turn_on_pump_button.pressed.connect(_on_turn_on_pump_button_pressed)


func _on_turn_on_pump_button_pressed():
	
	print("hello")
	
	if Globals.water_level > 0:
		Globals.moat_water_level = Globals.water_level
		Globals.water_level = 0
	
