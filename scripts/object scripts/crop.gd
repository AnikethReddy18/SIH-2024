extends Node2D

# Values
var index = 0 
var crop_growth_time: int = 5
var crop_growth_speed: int = 1

#Properties
var harvest_ready: bool = false
var player_in : bool = false

# Refernces
@onready var animation_player = $AnimationPlayer
@onready var timer: Timer = $Timer

func _ready():
	init_crop()
	Globals.harvest_crop.connect(harvest)

func next_stage():
	#Displays new crop stage and calls harvest method
	if index < 3:
		index += 1
		animation_player.play(str(index))
		
		timer.start(crop_growth_time/float(crop_growth_speed))
	else:
		harvest_ready = true	
		
func ready_to_harvest():
	harvest_ready = true

func harvest():
	if harvest_ready and player_in:
		print("harvesation")
		Globals.coins += 2	
		queue_free()	

func init_crop():
	# Sets growth speed and starts crop growth
	var fertilized_crop = is_in_group('fertilized_crop')
	var dripped_crop = is_in_group('dripped_crop')
	var dripped_fertilized_crop = is_in_group('dripped_fertilized')
	

	crop_growth_speed = 5 if fertilized_crop or dripped_fertilized_crop else 1
	
	animation_player.play(str(index))
	timer.start(float(crop_growth_time/crop_growth_speed))
	timer.timeout.connect(next_stage)



func _on_body_entered(body):
	print("player in pumpkin")
	player_in = true
	pass # Replace with function body.


func _on_body_exited(body):
	print("player out pumpkin")
	player_in = false
	pass # Replace with function body.
