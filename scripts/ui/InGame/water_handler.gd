extends Node


@onready var crops: Node = $"../World/Crops"
@onready var timer = $Timer
@onready var water_flow = $"../Pump/WaterFlow"

var count = 0

func _ready():
	crops.child_entered_tree.connect(handle_new_crops)
	
	#Globals Signals Connection
	Globals.fertilized_tiles_number_change.connect(fertilized_tiles_handler)
	Globals.is_raining.connect(water_replenish)



func handle_new_crops(node):
	var curr_crops  = node.get_parent().get_children()
	var diverse = are_diveristy(curr_crops)
	var is_dripped = node.is_in_group("dripped_crop") or node.is_in_group("dripped_fertilized")
	var is_dripped_diverse = diverse and is_dripped
	
	if is_dripped_diverse:
		Globals.moat_water_level -= 1
	elif is_dripped:
		Globals.moat_water_level -= 2
	elif diverse:
		Globals.moat_water_level -= 5
	else:
		Globals.moat_water_level -= 10

func are_diveristy(crops):
	var pumpkin = false
	var wheat = false
	
	for crop in crops:
		if crop.is_in_group('pumpkins'):
			pumpkin = true
			break

	for crop in crops:
		if crop.is_in_group('wheats'):
			wheat = true
			break	
	
	return pumpkin and wheat			

func fertilized_tiles_handler():
	Globals.water_level -= 5
	
func water_replenish():
	var speed = 0.1
	
	if Globals.rain_type == "medium":
		speed = 0.2
	elif Globals.rain_type == "heavy":
		speed = 0.3
	elif Globals.rain_type == "storm":	
		speed = 0.4			
	
	if Globals.rain_type != "none":
		timer.start(1)
		timer.timeout.connect(func(): Globals.water_level += Globals.dugged_holes_count*speed)
	else:
		timer.stop()	

		
