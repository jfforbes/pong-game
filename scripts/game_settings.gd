#game_settings.gd
extends Node

var game_mode: String = "Player vs Computer" #Either "Player vs Computer" or "Player vs Player"
var difficulty: String = "Normal" #"Easy", "Normal", "Hard"
var power_ups_enabled: bool = false #true or false
var score_to_win: int = 10
var ball_speed_multiplier: float = 1.0

func reset_settings():
	game_mode = "Player vs Player"
	difficulty = "Normal"
	power_ups_enabled = false
	score_to_win = 10
	ball_speed_multiplier = 1.0
