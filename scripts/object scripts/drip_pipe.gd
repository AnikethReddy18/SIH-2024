extends AnimatedSprite2D

var wasdripping : bool
# Called when the node enters the scene tree for the first time.
func _ready():
	play("idle")
	set_meta("dripping",true)
	wasdripping = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if get_meta("dripping") != wasdripping:
		if get_meta("dripping"):
			play("dripping")
		else:
			play("idle")
	pass
