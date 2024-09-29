extends Control

#Mode control
@onready var current_mode_label: Label = $HBoxContainer/CurrentModeLabel
@onready var next_mode_button : Button = $HBoxContainer/next_mode_button
@onready var prev_mode_button : Button = $HBoxContainer/prev_mode_button

#crop selector
@onready var crop_selector : OptionButton = $Crops/crop_selector


#utility selector
@onready var util_selector : OptionButton = $Utility/util_selector


func _ready():
	update_utils()
	Globals.curr_mode = 0
	next_mode_button.pressed.connect(change_mode.bind(1))
	prev_mode_button.pressed.connect(change_mode.bind(-1))
	Globals.util_count_changed.connect(update_utils)
	Globals.wheat_count_change.connect(update_crops)
	Globals.pumpkin_count_change.connect(update_crops)
	pass

func change_mode(dir : int):
	Globals.curr_mode = (Globals.curr_mode + dir + 3) % 3
	print(Globals.curr_mode)
	if   (Globals.curr_mode == 0):
		current_mode_label.text = "Current Mode: Plant"
	elif (Globals.curr_mode == 1):
		current_mode_label.text = "Current Mode: Util"
	elif (Globals.curr_mode == 2):
		current_mode_label.text = "Current Mode: Use"
	pass

func update_utils():
	util_selector.set_item_text(0, str(Globals.util_count[0]))
	util_selector.set_item_text(1, str(Globals.util_count[1]))
	util_selector.set_item_text(2, str(Globals.util_count[2]))
	util_selector.set_item_text(3, str(Globals.util_count[3]))
	util_selector.set_item_text(4, str(Globals.util_count[4]))

func update_crops():
	crop_selector.set_item_text(0, str(Globals.crop_count["wheat"]))
	crop_selector.set_item_text(1, str(Globals.crop_count["pumpkin"]))

func _on_util_selector_item_selected(index):
	Globals.curr_util = index
	pass # Replace with function body.


func _on_crop_selector_item_selected(index):
	match index:
		0:
			Globals.curr_seed = "wheat"
		1:
			Globals.curr_seed = "pumpkin"
	pass # Replace with function body.
