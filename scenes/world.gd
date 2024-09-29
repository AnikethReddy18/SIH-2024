extends Node2D


@onready var land = $Land
@onready var player = $Player

@onready var ground_layer : TileMapLayer = land.get_child(0)
@onready var effects_layer : TileMapLayer = land.get_child(1)
@onready var mods_layer : TileMapLayer = land.get_child(2)
@onready var crop_layer : TileMapLayer = land.get_child(3)
@onready var structure_layer : TileMapLayer = land.get_child(4)
@onready var aim_layer : TileMapLayer = land.get_child(5)

var ground_type : String
#terrain IDs

	   #terrain set 0

const water_id       : int = 0
const trench_id      : int = 1
const soil_id        : int = 2
const grass_id       : int = 3
const farm_id        : int = 4
const dried_farm_id  : int = 5
const dried_soil_id  : int = 6 
const dried_grass_id : int = 7
const flooded_id     : int = 8

#effects IDs

const fertilizer_id : int = 0 #Source

#farm mods IDs

const drip_pipe_id : int = 1 # Alternate ID; Source : 0

#crop IDs

const wheat_id   : int = 1 #Alternate ID; Source : 0
const pumpkin_id : int = 3 #Alternate ID; Source : 0

#structure IDs

const tubewell_id      : int = 1 #Source : 0
const sprinkler_id     : int = 3 #Source : 0
const recovery_well_id : int = 5 #Source : 0


func _ready():
	set_aim()
	set_ground_type()
	pass

func _input(_event):
	if Input.is_action_pressed("action"):
		match Globals.curr_mode:
			0 : #plant crops
				plant_current_crop()
			1 : #use tool
				use_equipped_tool()
			2 : #use object
				use_nearby_object()
			
	pass


func _process(delta):
	set_aim()
	set_ground_type()
	pass


func set_aim(): # aim tile setter
	var prev_aim_pos : Vector2i = Globals.aim_pos #get last tile location
	Globals.aim_pos = aim_layer.local_to_map(player.position + player.direction*Vector2(16,16))#get current tile location
	aim_layer.erase_cell(prev_aim_pos) #remove last tile
	aim_layer.set_cell(Globals.aim_pos, 0, Vector2i.ZERO) #set current tile
	pass
	
func set_ground_type():  #sets the current ground type -> soil, grass, farm, etc.
	var ground_data : TileData = ground_layer.get_cell_tile_data(Globals.aim_pos)
	match ground_data.terrain:
		0:
			ground_type = "water"
		1:
			ground_type = "trench"
		2:
			ground_type = "soil"
		3:
			ground_type = "grass"
		4:
			ground_type = "farm"
		5:
			ground_type = "dried_farm"
		6:
			ground_type = "dried_soil"
		7:
			ground_type = "dried_grass"
		8:
			ground_type = "flooded"
	pass
	
func plant_current_crop(): #plant the currently selected crop
	#check if ground is farm and there is no sprinkler on it (scenes accessed by alternative tile ID (for sprinkler : 3))
	if (ground_type == "farm" and structure_layer.get_cell_alternative_tile(Globals.aim_pos) != sprinkler_id):
		match Globals.curr_seed:
			"wheat":
				if Globals.wheat_count > 0:
					crop_layer.set_cell(Globals.aim_pos, 0, Vector2i(0,0), wheat_id )
					Globals.wheat_count -= 1
				
			"pumpkin":
				if Globals.pumpkin_count > 0:
					crop_layer.set_cell(Globals.aim_pos, 0, Vector2i(0,0), pumpkin_id )
					Globals.pumpkin_count -= 1
				
				
	pass

#use the currently selected utility
#0:fertilizer, 1:shovel, 2:hoe
func use_equipped_tool():
	match Globals.curr_util:
		0:
			use_fertilizer()
		1:
			place_drip_pipe()
		2:
			plough()
		3:
			harvest()
		4:
			dig_well()
	pass

func use_fertilizer():
	if ground_type == "farm" and Globals.util_count[0] > 0:
		effects_layer.set_cell(Globals.aim_pos, 0, Vector2i(0,0), 0)
		Globals.change_util_count(0,-1)
	pass
	
func place_drip_pipe():
	if ground_type == "farm" and Globals.util_count[1] > 0 and mods_layer.get_cell_source_id(Globals.aim_pos) == -1:
		mods_layer.set_cell(Globals.aim_pos,0,Vector2i(0, 0), drip_pipe_id)
		Globals.change_util_count(1,-1)
	pass

func plough():
	if ground_type == "soil" or ground_type == "grass":
		ground_layer.set_cells_terrain_connect([Globals.aim_pos], 0, farm_id)
	pass

func harvest():
	Globals.harvest_crop.emit()
	print("harvesting")
	pass

func dig_well():
	if (ground_type != "water" or ground_type != "trench") and structure_layer.get_cell_source_id(Globals.aim_pos) == -1:
		structure_layer.set_cell(Globals.aim_pos, 0, Vector2i(0, 0), recovery_well_id)
		Globals.change_util_count(4,-1)
	pass
		
#emit use object, the object scripts detect if player is in (Area 2D)
#and the signal is received - only then it gets used
func use_nearby_object():
	Globals.use_object.emit()
	pass
