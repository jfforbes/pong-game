extends Control

func _input(event):
	if event is InputEventKey and event.is_pressed():
		print("key press")
		#if key pressed, go to main menu
		change_to_main_menu()
	if event is InputEventMouseButton and event.is_pressed():
		print("mouse click")
		#if mouse is clicked, go to main menu
		change_to_main_menu()

func change_to_main_menu():
	print("going to main menu")
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")
