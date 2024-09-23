extends Control

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

func _ready():
	display_crops_button.pressed.connect(_on_press_display_crops_button)
	select_pumpkin_button.pressed.connect(_on_select_crop_button_pressed.bind("pumpkin", pumkin_h_split_container))
	select_wheat_button.pressed.connect(_on_select_crop_button_pressed.bind("wheat", wheat_h_split_container))
	dupl_buttton.pressed.connect(_on_select_crop_button_pressed.bind("duplicate this", dupl))
	
	#Label Update
	Globals.wheat_count_change.connect(_on_crop_count_changed.bind("wheat", wheat_count_label))
	Globals.pumpkin_count_change.connect(_on_crop_count_changed.bind("pumpkin", pumpkin_count_label))
	Globals.duplicate_this_count_changed.connect(_on_crop_count_changed.bind("duplicate this", dupl_label))

func _on_press_display_crops_button():
	select_crop_h_box_container.visible = true
	
func _on_select_crop_button_pressed(crop, curr_crop):
	var prev_crop = current_crop_panel_container.get_child(0)
		
	current_crop_panel_container.remove_child(prev_crop)
	select_crop_h_box_container.remove_child(curr_crop)
		
	current_crop_panel_container.add_child(curr_crop)
	select_crop_h_box_container.add_child(prev_crop)
	select_crop_h_box_container.visible = false
	
	Globals.curr_seed = crop
		
func _on_crop_count_changed(crop, crop_label):
	crop_label.text =str(Globals.crop_count[crop])
