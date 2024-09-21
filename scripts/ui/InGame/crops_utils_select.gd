extends Control

# Preloads
const FERTILIZER = preload("res://assets/old/icons/fertilizer.png")
const PIPE = preload("res://assets/old/icons/pipe.png")
const SHOVEL = preload("res://assets/old/icons/shovel.png")
const WHEAT_SPRITE = preload("res://assets/old/Crops/wheat/wheat_04.png")
const PUMPKIN_SPRITE= preload("res://assets/old/Crops/pumkin/pumpkin_04.png")

#Sprites 
@onready var current_crop_sprite = $CropsVSplitContainer/currentCropVSplitContainer/currentCropHSplitContainer/currentCropSprite
@onready var current_sprite_count = $CropsVSplitContainer/currentCropVSplitContainer/currentCropHSplitContainer/currentSpriteCount
@onready var current_util_sprite = $UtilsHBoxContainer/CurrentUtilContainer/CurrentUtilSprite

#Labels
@onready var current_mode_label: Label = $CurrentModeLabel

#Buttons
@onready var display_crops_button = $CropsVSplitContainer/currentCropVSplitContainer/displayCropsButton
@onready var select_wheat_button = $CropsVSplitContainer/selectCropHSplitContainer/selectWheatButton
@onready var select_pumpkin_button = $CropsVSplitContainer/selectCropHSplitContainer/selectPumpkinButton
@onready var select_util_button = $UtilsHBoxContainer/SelectUtilButton
@onready var fertilizer_button = $UtilsHBoxContainer/UtilSelectContainer/FertilizerButton
@onready var pipe_button = $UtilsHBoxContainer/UtilSelectContainer/PipeButton
@onready var shovel_buttin = $UtilsHBoxContainer/UtilSelectContainer/ShovelButtin

#Container
@onready var select_crop_h_split_container = $CropsVSplitContainer/selectCropHSplitContainer
@onready var current_crop_v_split_container = $CropsVSplitContainer/currentCropVSplitContainer
@onready var util_select_container = $UtilsHBoxContainer/UtilSelectContainer

func _ready():
	#Buttons Pressed
	display_crops_button.pressed.connect(_on_display_crops_button_pressed)
	select_wheat_button.pressed.connect(_on_select_wheat_button)
	select_pumpkin_button.pressed.connect(_on_select_pumpkin_button)
	select_util_button.pressed.connect(_on_select_util_button_pressed)
	fertilizer_button.pressed.connect(_on_fertilizer_button_pressed)
	shovel_buttin.pressed.connect(_on_shovel_button_pressed)
	
	#Label Update
	Globals.curr_mode_changed.connect(_on_curr_mode_changed)

# Crops & Fertilizers	
func _on_display_crops_button_pressed():
	if select_crop_h_split_container.visible:
		select_crop_h_split_container.visible = false
	else:
		select_crop_h_split_container.visible = true	
		current_crop_v_split_container.visible = false

func _on_select_wheat_button():
	Globals.curr_seed = Globals.wheat_seed
	select_crop_h_split_container.visible = false
	current_crop_sprite.texture = WHEAT_SPRITE
	current_crop_v_split_container.visible = true
	
func _on_select_pumpkin_button():
	Globals.curr_seed= Globals.pumpkin_seed	
	select_crop_h_split_container.visible = false	
	current_crop_sprite.texture = PUMPKIN_SPRITE
	current_crop_v_split_container.visible = true


func _on_select_util_button_pressed():
	util_select_container.visible = true

func _on_fertilizer_button_pressed():
	Globals.curr_util = 0
	current_util_sprite.texture = FERTILIZER
	util_select_container.visible = false

func _on_shovel_button_pressed():
	Globals.curr_util = 2
	current_util_sprite.texture = SHOVEL
	util_select_container.visible = false

func _on_curr_mode_changed():
	if Globals.curr_mode == 0:
		current_mode_label.text = "Current Mode: Farm"
	else:
		current_mode_label.text = "Current Mode: Util"				
