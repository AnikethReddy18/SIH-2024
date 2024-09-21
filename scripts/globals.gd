extends Node

#Preloads
const wheat_seed = preload("res://objects/crops/wheat.tscn")
const pumpkin_seed = preload("res://objects/crops/pumpkin.tscn")

# Signals
signal coins_change
signal wheat_count_change
signal pumpkin_count_change
signal water_level_change
signal fertilized_tiles_number_change
signal is_raining()
signal weather_status_changed()
signal util_count_changed
signal curr_mode_changed
signal moat_water_level_changed
# Variables

var coins: int = 500: 
	set(value):
		coins = value
		coins_change.emit()	
		
var water_level: int = 100:
	set(value):
		if value > 100:
			water_level = 100
		elif value >= 0:
			water_level = value	
		else:
			if value > water_level:
				water_level = 1
			water_level = 0
		water_level_change.emit()				
var wheat_count: int:
	set(value):
		wheat_count = value
		wheat_count_change.emit()							
var pumpkin_count: int:
	set(value):
		pumpkin_count = value
		pumpkin_count_change.emit()
var crop_count: int:
	get():
		crop_count += 1
		return crop_count
var fertilized_tiles: int:
	set(value):
		fertilized_tiles = value
		fertilized_tiles_number_change.emit()
var dugged_holes_count= 0
var curr_seed = wheat_seed
var curr_util: int = 0# fertilizer:0, pipe:1, shovel:2
var util_count = [0,0,0]: 
	set(value):
		util_count = value
		util_count_changed.emit()
var curr_mode = 0: # 0:plant 1:util
	set(value):
		curr_mode = value
		curr_mode_changed.emit()		
var moat_water_level = 100:
	set(value):
		if value < 0 :
			moat_water_level = 0
		else:
			moat_water_level = value
		moat_water_level_changed.emit()			
#Weather and land
var rain_type : String: # "none" , "light" , "medium" , "heavy", "storm"
	set(type):
		rain_type = type
		is_raining.emit()
var weather_status : String: #idle wetting extreme_sunny flooding
	set(status):
		weather_status = status
		weather_status_changed.emit()
