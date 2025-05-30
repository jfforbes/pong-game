#main_menu.gd

extends Control

@onready var game_mode_option : OptionButton = get_node("CenterContainer/MenuOptions/GameModeOption")
@onready var difficulty_option : OptionButton = get_node("CenterContainer/MenuOptions/DifficultyOption")
@onready var difficulty_label : Label = get_node("CenterContainer/MenuOptions/DifficultyLabel")
@onready var power_ups_toggle : CheckButton = get_node("CenterContainer/MenuOptions/PowerUpsOption/PowerUpsToggle")
@onready var start_button : Button = get_node("CenterContainer/MenuOptions/HBoxContainer/StartButton")
@onready var controls_button : Button = get_node("CenterContainer/MenuOptions/HBoxContainer/ControlsButton")

func _ready():
	game_mode_option.item_selected.connect(on_game_mode_selected)
	
	difficulty_label.hide()
	difficulty_option.hide()
	
	on_game_mode_selected(game_mode_option.selected)
	
	start_button.pressed.connect(on_start_button_pressed)
	controls_button.pressed.connect(on_controls_button_pressed)
	
func on_game_mode_selected(index):
	# index 0 = player vs player, 1 = player vs computer
	
	if index == 1: # player vs computer
		#show difficulty
		difficulty_option.show()
		difficulty_label.show()
	else: #player vs player
		difficulty_option.hide()
		difficulty_label.hide()

func on_start_button_pressed():
	#store game mode
	GameSettings.game_mode = game_mode_option.get_item_text(game_mode_option.selected)
	
	if difficulty_option.visible:
		GameSettings.difficulty = difficulty_option.get_item_text(difficulty_option.selected)
	else:
		GameSettings.difficulty = "Normal"
	
	GameSettings.power_ups_enabled = power_ups_toggle.button_pressed
	
	print("--- Game Settings Saved ---")
	print("Mode: ", GameSettings.game_mode)
	print("Difficulty: ", GameSettings.difficulty)
	print("Power Ups Enabled: ", GameSettings.power_ups_enabled)
	print("---------------------------")
	
	get_tree().change_scene_to_file("res://main/main.tscn")

func on_controls_button_pressed():
	get_tree().change_scene_to_file("res://menus/controls_screen.tscn")
	
