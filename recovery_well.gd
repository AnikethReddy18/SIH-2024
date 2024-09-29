extends Area2D

@onready var animation = $AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("empty")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Globals.rain_type != "none" or Globals.rain_type != "light"):
		animation.play("filled")
	else:
		animation.play("empty")
	pass
