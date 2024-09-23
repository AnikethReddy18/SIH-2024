extends Node2D

# Values
var index = 0 
var crop_growth_time: int = 5
var crop_growth_speed: int = 1

#Properties
var harvest_ready: bool = false

# Refernces
@onready var animation_player = $AnimationPlayer
@onready var timer: Timer = $Timer

func _ready():
	init_crop()

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

	if "pumpkin" in name:
		Globals.pumpkin_count += 1
		
	elif "wheat" in name:
		Globals.wheat_count += 1	
		
	elif "duplicate" in name:
		Globals.duplicate_this_count += 1
		
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
