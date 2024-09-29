extends Area2D

@onready var animation = $AnimatedSprite2D
@onready var timer = $Timer
@onready var timer_2 = $Timer2

const max_capacity : int = 50
var water : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = 1
	water = 0
	animation.play("empty")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(Globals.rain_type != "none" and water < max_capacity and timer.is_stopped()):
		water += 1
		timer.start()	
	if(water >= max_capacity-10):
		animation.play("filled")
		
	else:
		animation.play("empty")
	
	if (Globals.water_level < 100 and water > 0 and timer_2.is_stopped()):
		water -= 1
		Globals.water_level += 0.5
		timer_2.start()
	
	pass
