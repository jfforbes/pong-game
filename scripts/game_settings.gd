#game_settings.gd
extends Node

var game_mode: String = "Player vs Player" #Either "Player vs Computer" or "Player vs Player"
var difficulty: String = "Normal" #"Easy", "Normal", "Hard"
var power_ups_enabled: bool = false #true or false
var score_to_win: int = 10
var ball_speed_multiplier: float = 1.0
var speed = 400.0 #Set initial speed
var winner = "None" #Either right or left

func reset_settings():
	game_mode = "Player vs Player"
	difficulty = "Normal"
	power_ups_enabled = false
	score_to_win = 10
	ball_speed_multiplier = 1.0
	speed = 400.0
	winner = "None"
