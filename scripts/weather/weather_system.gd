extends Node

@onready var wetting = $wetting
@onready var idle = $idle
@onready var flooding = $flooding
@onready var extreme_sunny = $extreme_sunny
@onready var rain = $Rain

var rng = RandomNumberGenerator.new()
var rain_types : Array[String] = ["light","medium","heavy"]

func _ready():
	Globals.rain_type = "none"

func _physics_process(_delta):
	update_wait_times()
	var rn2 = rng.randi_range(0,3)
	if idle.is_stopped() && wetting.is_stopped() && flooding.is_stopped() && extreme_sunny.is_stopped():
		if (rn2 == 0): #idle
			Globals.weather_status = "idle"
			idle.start()
			Globals.rain_type = "none"
		elif (rn2 == 1): #start rain
			Globals.weather_status = "wetting"
			wetting.start()
			Globals.rain_type = rain_types.pick_random()
		elif (rn2 == 2): #storm
			Globals.weather_status = "flooding"
			flooding.start()
			Globals.rain_type = "storm"
		elif (rn2 == 3):
			Globals.weather_status = "extreme_sunny"
			extreme_sunny.start()
			Globals.rain_type = "none"	
	pass

func update_wait_times():
	wetting.wait_time = rng.randi_range(10,40)  #change to depend on water level
	idle.wait_time = rng.randi_range(5,45)
	flooding.wait_time = rng.randi_range(10,40) 
	extreme_sunny.wait_time = rng.randi_range(10,40)
