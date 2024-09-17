extends CharacterBody2D

# Reference(s)
@onready var player_sprite = $AnimatedSprite2D


#Variables
var direction = Vector2.ZERO
const SPEED = 100

func _physics_process(_delta):
	handle_movement()
	move_and_slide()	
	
	
func _input(event):
	pass
	
	
func handle_movement():	
	if Input.is_action_pressed("MoveUp"):
		player_sprite.play("walk_up")
		direction = Vector2.UP

	elif Input.is_action_pressed("MoveDown"):
		player_sprite.play("walk_down")
		direction = Vector2.DOWN
			
	elif Input.is_action_pressed("MoveRight"):
		player_sprite.play("walk_side")
		player_sprite.flip_h = true
		direction = Vector2.RIGHT
		
	elif Input.is_action_pressed("MoveLeft"):
		player_sprite.play("walk_side")
		player_sprite.flip_h = false
		direction = Vector2.LEFT	
		
	else:
		match direction :
			Vector2.UP:
				player_sprite.play("idle_up")
			Vector2.DOWN:
				player_sprite.play("idle_down")
			Vector2.RIGHT:
				player_sprite.play("idle_side")
			Vector2.LEFT:
				player_sprite.play("idle_side")
		
		direction = Vector2.ZERO	
		
	velocity = direction*SPEED	
