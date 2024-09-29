extends Area2D

@onready var timer = $Timer
@onready var animation = $AnimatedSprite2D
@onready var body = $CollisionShape2D

var player_in : bool

func _ready():
	animation.play("idle")
	set_meta("sprinkling",false)
	player_in = false
	pass 

func _physics_process(delta):
	Globals.use_object.connect(toggle)
	if get_meta("sprinkling") and timer.is_stopped():
		Globals.water_level -= 0.1
		timer.start()

func toggle():
	if player_in:
		if get_meta("sprinkling"):
			set_meta("sprinkling",false)
			animation.play("idle")
		else:
			set_meta("sprinkling",true)
			animation.play("sprinkling")
			
	pass


func _on_body_entered(body):
	player_in = true
	pass # Replace with function body.


func _on_body_exited(body):
	player_in = false
	pass # Replace with function body.
