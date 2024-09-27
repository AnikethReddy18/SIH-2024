extends Control

@onready var current_mode_label: Label = $CurrentModeLabel

#Crops
@onready var display_crops_button: Button = $CropsVSplitContainer/currentCropVSplitContainer/displayCropsButton
@onready var select_crop_h_box_container: HBoxContainer = $CropsVSplitContainer/selectCropHBoxContainer
@onready var current_crop_panel_container: PanelContainer = $CropsVSplitContainer/currentCropVSplitContainer/CurrentCropPanelContainer


# Crop Select Button
@onready var select_pumpkin_button: Button = $CropsVSplitContainer/selectCropHBoxContainer/PumkinHSplitContainer/selectPumpkinButton
@onready var select_wheat_button: Button = $CropsVSplitContainer/currentCropVSplitContainer/CurrentCropPanelContainer/WheatHSplitContainer/selectWheatButton
@onready var dupl_buttton: Button = $CropsVSplitContainer/selectCropHBoxContainer/Dupl/DuplButtton

# Crop Cotainer
@onready var wheat_h_split_container: HSplitContainer = $CropsVSplitContainer/currentCropVSplitContainer/CurrentCropPanelContainer/WheatHSplitContainer
@onready var pumkin_h_split_container: HSplitContainer = $CropsVSplitContainer/selectCropHBoxContainer/PumkinHSplitContainer
@onready var dupl: HSplitContainer = $CropsVSplitContainer/selectCropHBoxContainer/Dupl

# Crop Count Label
@onready var pumpkin_count_label: Label = $CropsVSplitContainer/selectCropHBoxContainer/PumkinHSplitContainer/PumpkinCountLabel
@onready var wheat_count_label: Label = $"CropsVSplitContainer/currentCropVSplitContainer/CurrentCropPanelContainer/WheatHSplitContainer/WheatCountLabe;"
@onready var dupl_label: Label = $CropsVSplitContainer/selectCropHBoxContainer/Dupl/DuplLabel


# Utils
@onready var panel_container: PanelContainer = $UtilsHBoxContainer/PanelContainer
@onready var select_util_button: Button = $UtilsHBoxContainer/SelectUtilButton
@onready var util_select_container: HBoxContainer = $UtilsHBoxContainer/UtilSelectContainer

# Utils Select Button
@onready var fertilizer_button: Button = $UtilsHBoxContainer/PanelContainer/FertilizerHSplitContainer/FertilizerButton
@onready var pipe_button: Button = $UtilsHBoxContainer/UtilSelectContainer/PipeHSplitContainer/PipeButton
@onready var shovel_buttin: Button = $UtilsHBoxContainer/UtilSelectContainer/ShovelHSplitContainer/ShovelButtin

# Crpo Cotainer
@onready var fertilizer_h_split_container: HSplitContainer = $UtilsHBoxContainer/PanelContainer/FertilizerHSplitContainer
@onready var pipe_h_split_container: HSplitContainer = $UtilsHBoxContainer/UtilSelectContainer/PipeHSplitContainer
@onready var shovel_h_split_container: HSplitContainer = $UtilsHBoxContainer/UtilSelectContainer/ShovelHSplitContainer

# Crop Count Label
@onready var fertilizer_count_label: Label = $UtilsHBoxContainer/PanelContainer/FertilizerHSplitContainer/FertilizerCountLabel
@onready var pipe_count_label: Label = $UtilsHBoxContainer/UtilSelectContainer/PipeHSplitContainer/PipeCountLabel
@onready var shovel_count_label: Label = $UtilsHBoxContainer/UtilSelectContainer/ShovelHSplitContainer/ShovelCountLabel

func _ready():
	Globals.curr_mode_changed.connect(_on_mode_change)
	"""Crops"""
	display_crops_button.pressed.connect(_on_press_display_crops_button)
	select_pumpkin_button.pressed.connect(_on_select_crop_button_pressed.bind("pumpkin", pumkin_h_split_container))
	select_wheat_button.pressed.connect(_on_select_crop_button_pressed.bind("wheat", wheat_h_split_container))
	dupl_buttton.pressed.connect(_on_select_crop_button_pressed.bind("duplicate this", dupl))
	
	#Label Update
	Globals.wheat_count_change.connect(_on_crop_count_changed.bind("wheat", wheat_count_label))
	Globals.pumpkin_count_change.connect(_on_crop_count_changed.bind("pumpkin", pumpkin_count_label))
	Globals.duplicate_this_count_changed.connect(_on_crop_count_changed.bind("duplicate this", dupl_label))
	
	"""Utils"""
	select_util_button.pressed.connect(_on_press_display_utils_button)
	fertilizer_button.pressed.connect(_on_select_util_button_pressed.bind(0, fertilizer_h_split_container))
	pipe_button.pressed.connect(_on_select_util_button_pressed.bind(1, pipe_h_split_container))
	shovel_buttin.pressed.connect(_on_select_util_button_pressed.bind(2, shovel_h_split_container))
	
	#Label Updates
	Globals.util_count_changed.connect(_on_util_count_changed)

#Crops
func _on_press_display_crops_button():
	select_crop_h_box_container.visible = true
	
func _on_select_crop_button_pressed(crop, curr_crop):
	Globals.curr_mode = 0
	var prev_crop = current_crop_panel_container.get_child(0)
		
	current_crop_panel_container.remove_child(prev_crop)
	select_crop_h_box_container.remove_child(curr_crop)
		
	current_crop_panel_container.add_child(curr_crop)
	select_crop_h_box_container.add_child(prev_crop)
	select_crop_h_box_container.visible = false
	
	Globals.curr_seed = crop
		
func _on_crop_count_changed(crop, crop_label):
	crop_label.text =str(Globals.crop_count[crop])

#Utils
func _on_press_display_utils_button():
	util_select_container.visible = true
	
func _on_select_util_button_pressed(util, curr_util):	
	Globals.curr_mode = 1
	var prev_util = panel_container.get_child(0)
		
	panel_container.remove_child(prev_util)
	util_select_container.remove_child(curr_util)
		
	panel_container.add_child(curr_util)
	util_select_container.add_child(prev_util)
	util_select_container.visible = false
	
	Globals.curr_util = util

func _on_util_count_changed():
	fertilizer_count_label.text = str(Globals.util_count[0])
	pipe_count_label.text = str(Globals.util_count[1])
	shovel_count_label.text = str(Globals.util_count[2])

func _on_mode_change():
	if (Globals.curr_mode ==0):
		current_mode_label.text = "Current Mode: Farm"
	else:
		current_mode_label.text = "Current Mode: util"	
