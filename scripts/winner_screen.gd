extends Control

@onready var animation_player_node = get_node("AnimationPlayer")
@onready var winner_label_node: Label = get_node("MarginContainer/CenterContainer/WinnerLabel")
var can_skip_screen = false

func _ready() -> void:
	animation_player_node.play("flash")
	
	if GameSettings.winner == "Right" and GameSettings.game_mode == "Player vs Player":
		print("Displaying player 2 win")
		winner_label_node.text = "PLAYER 2 WINS"
	elif GameSettings.winner == "Left" and GameSettings.game_mode == "Player vs Player":
		print("Displaying player 1 win")
		winner_label_node.text = "PLAYER 1 WINS"
	elif GameSettings.winner == "Left" and GameSettings.game_mode == "Player vs Computer":
		print("Displaying player win")
		winner_label_node.text = "PLAYER WINS!"
	elif  GameSettings.winner == "Right" and GameSettings.game_mode == "Player vs Computer":
		print("Displaying computer win")
		winner_label_node.text = "COMPUTER WINS!"
		
	#starts a timer after 1 second so player doesn't skip screen
	await get_tree().create_timer(1.0).timeout
	
	can_skip_screen = true

func _input(event):
	#check if timer expired
	if can_skip_screen:
		if event is InputEventKey and event.is_pressed():
			#if key pressed, go to main menu
			change_to_main_menu()
		if event is InputEventMouseButton and event.is_pressed():
			#if mouse is clicked, go to main menu
			change_to_main_menu()

func change_to_main_menu():
	if not can_skip_screen:
		return
	
	GameSettings.reset_settings()
	
	can_skip_screen = false
	
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")
