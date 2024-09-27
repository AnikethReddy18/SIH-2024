extends Area2D

@onready var body = $CollisionPolygon2D
@onready var animation = $AnimatedSprite2D

var player_in : bool
# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("idle") 
	player_in = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if player_in and Input.is_action_just_pressed("use"):
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
