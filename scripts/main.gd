extends Node

@onready var position_finder_layer = $Tilemap/PositionFinderLayer
@onready var ground_layer = $Tilemap/garden
@onready var tile_cords
@onready var stored_plants ={}
@onready var player = $World/Player
@onready var base_layer = $Tilemap/PositionFinderLayer
@onready var digged_cells = []
@onready var grid_helper = $World/GridHelper
@onready var grass_layer = $Tilemap/green_grass

func _input(_event):
	if Input.is_action_just_pressed("use"):
		_on_press_use()
	
	if Input.is_action_just_pressed("change_mode"):
		if Globals.curr_mode == 0:
			Globals.curr_mode = 1
		else:
			Globals.curr_mode = 0		

func _process(_delta):
	update_grid_helper_pos()

func _on_press_use():
	if Globals.curr_mode == 1:
		use_util_on_tile()
	else:
		var can_plant_seed = not stored_plants.has(tile_cords) and Globals.moat_water_level > 0		
		if can_plant_seed:
			plant_seed()
		else:
			if stored_plants.get(tile_cords) != null and stored_plants[tile_cords].harvest_ready:
				harvest()	
			
func use_util_on_tile():
	
	var curr_util = Globals.curr_util
	var util_count = Globals.util_count
	
	var layer = grass_layer if curr_util == 2 else ground_layer
	var custom_data = get_custom_cell_data(layer)
	var fertilized = custom_data[0]
	var drip_irrigated = custom_data[1]
	var grass = custom_data[2]
	#var fert_drip = custom_data[3]
	
	
	if curr_util == 0:
		if util_count[0]> 0:
			if not drip_irrigated:
				layer.set_cell(tile_cords, 3, Vector2i(0,0) )	
			elif fertilized:
				layer.set_cell(tile_cords, 4,Vector2i(0,0))						
		
			Globals.util_count = [util_count[0]-1, util_count[1], util_count[2]]
			Globals.moat_water_level -= 20				
	elif curr_util == 1:
		if util_count[1]>0:
			if not drip_irrigated:
				layer.set_cell(tile_cords,2,Vector2i(0,0))	
			if fertilized:
				layer.set_cell(tile_cords,4,Vector2i(0,0))	
				
			Globals.util_count = [util_count[0], util_count[1]-1, util_count[2]]
			
	elif curr_util == 2:
		print("hello")
		if Globals.util_count[2] > 0:
			Globals.dugged_holes_count += 1
			print("dig")
			digged_cells.append(tile_cords)
			layer.set_cell(tile_cords,0,Vector2i(-1,-1))	
			Globals.util_count = [util_count[0], util_count[1], util_count[2]-1]

	else:
		print("ERROR: METHOD: use_util_on_tile")		
	
func get_custom_cell_data(layer):
	var cell_data = layer.get_cell_tile_data(tile_cords)	
	
	if cell_data == null:
		if layer == grass_layer:
			return [false, false, false, true]
		else:
			return	
		
	var fertilized = cell_data.get_custom_data("fertilized")
	var drip_irrigated = cell_data.get_custom_data("drip_irrigated")
	var grass = cell_data.get_custom_data("grass")
	var fert_drip = cell_data.get_custom_data("fertilized_pipe")
	var ground = cell_data.get_custom_data("garden")
	
	var custom_data = [fertilized, drip_irrigated, grass, fert_drip, ground]
	
	return custom_data
	
func plant_seed():
	var can_plant_wheat = Globals.curr_seed == Globals.wheat_seed and Globals.wheat_count >= 1
	var can_plant_pumpkin = Globals.curr_seed == Globals.pumpkin_seed and Globals.pumpkin_count >= 1
	
	var seed_to_plant = Globals.curr_seed.instantiate()
	
	var custom_data = get_custom_cell_data(ground_layer)
	
	if custom_data == null:
		return
		
	var is_fertilized = custom_data[0]
	var is_dripped = custom_data[1]
	var is_dripped_fertilized = custom_data[3]
	var is_ground = custom_data[4]
		
	if is_ground:
		seed_to_plant.add_to_group('ground_crop')
	elif is_fertilized:
		seed_to_plant.add_to_group('fertilized_crop')	
	elif is_dripped:
		seed_to_plant.add_to_group('dripped_crop')	
	elif is_dripped_fertilized:
		seed_to_plant.add_to_group('dripped_fertilized')	
			
	if can_plant_wheat:
		stored_plants[tile_cords] = seed_to_plant
		seed_to_plant.name = seed_to_plant.name + str(Globals.crop_count)
		get_node("World/Crops").add_child(seed_to_plant)
		seed_to_plant.global_position = ground_layer.map_to_local(tile_cords)
		Globals.wheat_count -= 1
			
	elif can_plant_pumpkin:
		stored_plants[tile_cords] = seed_to_plant
		seed_to_plant.name = seed_to_plant.name + str(Globals.crop_count)
		get_node("World/Crops").add_child(seed_to_plant)
		seed_to_plant.global_position = ground_layer.map_to_local(tile_cords)
		Globals.pumpkin_count -= 1	
		
func harvest():
	stored_plants[tile_cords].harvest()
	stored_plants.erase(tile_cords)	

func update_grid_helper_pos():
	var player_map_cod = base_layer.local_to_map(player.global_position)
	var player_dir = player.direction
	tile_cords = player_map_cod + Vector2i(player_dir) /16
	grid_helper.global_position = tile_cords*16		
