extends Area2D

@onready var animation = $AnimatedSprite2D
@onready var timer = $Timer

const max_capacity : int = 20
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
		
	if(water == max_capacity):
		animation.play("filled")
	else:
		animation.play("empty")
	
	pass
