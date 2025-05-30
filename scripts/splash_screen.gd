#splash_green.gd
extends Control

@onready var animation_player_node = get_node("AnimationPlayer")

var can_skip_splash = false

func _ready():
	animation_player_node.play("flash")
	
	#starts a timer after 1 second so player doesn't skip screen
	await get_tree().create_timer(1.0).timeout
	
	can_skip_splash = true
	
func _input(event):
	#check if timer expired
	if can_skip_splash:
		if event is InputEventKey and event.is_pressed():
			#if key pressed, go to main menu
			change_to_main_menu()
		if event is InputEventMouseButton and event.is_pressed():
			#if mouse is clicked, go to main menu
			change_to_main_menu()
			
func change_to_main_menu():
	if not can_skip_splash:
		return
	
	can_skip_splash = false
	
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")
