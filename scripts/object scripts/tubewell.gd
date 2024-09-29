extends Area2D

@onready var body = $CollisionPolygon2D
@onready var animation = $AnimatedSprite2D
@onready var timer = $Timer

var player_in : bool
# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("idle") 
	player_in = false
	pass # Replace with function body.


func _physics_process(delta):
	Globals.use_object.connect(toggle)
	if get_meta("pumping") and timer.is_stopped():
		Globals.water_level -= 0.5
		timer.start()
		
		

func toggle():
	if player_in:
		if get_meta("pumping"):
			animation.play("idle")
			set_meta("pumping",false)
		else:
			animation.play("pumping")
			set_meta("pumping",true)
	
	pass

func _on_body_entered(body):
	player_in = true
	pass # Replace with function body.

func _on_body_exited(body):
	player_in = false
	pass # Replace with function body.
