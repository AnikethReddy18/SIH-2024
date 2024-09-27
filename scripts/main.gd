extends Node

#Layers
@onready var farm_layer = $Land/FarmLayer
@onready var grass_layer = $Land/GrassLayer

@onready var position_finder_layer = $Land/PositionFinderLayer
@onready var tile_cords
@onready var stored_plants ={}
@onready var player = $World/Player
@onready var base_layer = $Land/PositionFinderLayer
@onready var digged_cells = []
@onready var grid_helper = $World/GridHelper

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
		var seed_data = to_plant_seed()
		if seed_data:	
			plant_seed(seed_data[0], seed_data[1], seed_data[2], seed_data[3])
		else:
			if stored_plants.get(tile_cords) != null and stored_plants[tile_cords].harvest_ready:
				harvest()	


func use_util_on_tile():
	
	var curr_util = Globals.curr_util
	var util_count = Globals.util_count
	
	var layer = grass_layer if curr_util == 2 else farm_layer
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

func to_plant_seed():
	if (not stored_plants.has(tile_cords) and Globals.moat_water_level > 0 and Globals.crop_count[Globals.curr_seed]>0):
		var custom_data = get_custom_cell_data(farm_layer)
		
		if custom_data == null:
			return false
		
		var is_fertilized = custom_data[0]
		var is_dripped = custom_data[1]
		var is_dripped_fertilized = custom_data[3]
		var is_farm = custom_data[4]
		
		return [is_fertilized, is_dripped, is_dripped_fertilized, is_farm]
		
	else:
		return false	
	
func plant_seed(is_fertilized, is_dripped, is_dripped_fertilized, is_ground):
	var seed_to_plant = Globals.seeds[Globals.curr_seed].instantiate()

	if is_ground:
		seed_to_plant.add_to_group('ground_crop')
	elif is_fertilized:
		seed_to_plant.add_to_group('fertilized_crop')	
	elif is_dripped:
		seed_to_plant.add_to_group('dripped_crop')	
	elif is_dripped_fertilized:
		seed_to_plant.add_to_group('dripped_fertilized')	
	
	if Globals.curr_seed == "wheat":
		stored_plants[tile_cords] = seed_to_plant
		seed_to_plant.name = seed_to_plant.name + str(Globals.increment_number)
		get_node("World/Crops").add_child(seed_to_plant)
		seed_to_plant.global_position = farm_layer.map_to_local(tile_cords)
		Globals.wheat_count -= 1
			
	elif Globals.curr_seed == "pumpkin":
		stored_plants[tile_cords] = seed_to_plant
		seed_to_plant.name = seed_to_plant.name + str(Globals.increment_number)
		get_node("World/Crops").add_child(seed_to_plant)
		seed_to_plant.global_position = farm_layer.map_to_local(tile_cords)
		Globals.pumpkin_count -= 1	
	
	elif Globals.curr_seed == "duplicate this":
		stored_plants[tile_cords] = seed_to_plant
		
		seed_to_plant.name = seed_to_plant.name + str(Globals.increment_number)
		get_node("World/Crops").add_child(seed_to_plant)
		seed_to_plant.global_position = farm_layer.map_to_local(tile_cords)
		Globals.duplicate_this_count -= 1	
		
func harvest():
	stored_plants[tile_cords].harvest()
	stored_plants.erase(tile_cords)	

func update_grid_helper_pos():
	var player_map_cod = base_layer.local_to_map(player.global_position)
	var player_dir = player.direction
	tile_cords = player_map_cod + Vector2i(player_dir) /16
	grid_helper.global_position = tile_cords*16		
