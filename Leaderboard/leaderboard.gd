extends Control

@onready var name_input: LineEdit = $HBoxContainer/name_input
@onready var score_input: LineEdit = $HBoxContainer/Score_input
@onready var submit_button: Button = $VBoxContainer/Submit_button
@onready var leaderboard_button: Button = $VBoxContainer/Leaderboard_button
@onready var main_menu_button: Button = $HBoxContainer2/main_menu_button

@onready var main_menu_level = load("res://Main Menu/main_menu.tscn") as PackedScene
func _on_submit_button_pressed() -> void:
	var score = float(score_input.text) 
	var player_name = name_input.text  
	await Leaderboards.post_guest_score("sih-2024-main-ZBI8", score, player_name)
	get_tree().reload_current_scene()


func _on_leaderboard_button_pressed() -> void:
	$LeaderboardUI.show()


func _on_exit_button_pressed() -> void:
	$LeaderboardUI.hide()


func _on_main_menu_button_pressed() -> void:
	print("Trying to go back to main menu")
	get_tree().change_scene_to_packed(main_menu_level)
