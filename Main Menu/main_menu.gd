extends Control

@onready var start_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/start_button as Button
@onready var exit_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/exit_button as Button
@onready var leaderboard_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/leaderboard_button as Button

@onready var start_level = preload("res://scenes/main.tscn") as PackedScene
@onready var leaderboard_level = preload("res://Leaderboard/leaderboard.tscn") as PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.button_down.connect(on_start_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	leaderboard_button.button_down.connect(on_lb_pressed)
func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)

func on_exit_pressed()->void:
	get_tree().quit()
func on_lb_pressed()->void:
	get_tree().change_scene_to_packed(leaderboard_level)
