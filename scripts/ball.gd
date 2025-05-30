extends RigidBody2D

const MIN_HORIZONTAL_VELOCITY_RATIO = 0.25
const MIN_VERTICAL_VELOCITY_RATIO = 0.25
const NUDGE_TARGET_COMPONENT_RATIO = 0.35

@export var initial_speed: float = 400.0 #initial speed
@export var speed: float = initial_speed #setting speed to initial speed
@export var max_speed: float = 800.0 #max speed

var left_score: int = 0 #initial score for left side
var right_score: int = 0 #initial score for right

#getting score labels
@onready var left_score_label = get_node("../../CanvasLayer/LeftScoreLabel")
@onready var right_score_label = get_node("../../CanvasLayer/RightScoreLabel")

#launch delay timer
@onready var launch_delay_timer: Timer = Timer.new()

func _ready() -> void:
	gravity_scale = 0.0 #ensure gravity is 0
	randomize() #ensuring random number
	
	if not launch_delay_timer.get_parent(): 
		launch_delay_timer.name = "Launch Delay Timer"
		launch_delay_timer.one_shot = true
		launch_delay_timer.wait_time = 1.0
		launch_delay_timer.connect("timeout", Callable(self, "_on_LaunchDelayTimer_timeout"))
		add_child(launch_delay_timer)
		
	reset_ball() #reset the ball
	
func _physics_process(delta: float) -> void:
	speed = GameSettings.speed
	
	# only run the logic if ball is moving
	if not launch_delay_timer.is_stopped():
		_place_ball_at_center_and_stop()
		return
	
	# squared linear velocity
	var current_lv_sq = linear_velocity.length_squared()
		
	# failsafe for if ball stops for some weird reason
	if current_lv_sq < 0.1 and speed > 0: # if it's stopped
		print("Ball stopped mid game, relaunching")
		_on_LaunchDelayTimer_timeout()
		current_lv_sq = linear_velocity.length_squared() #update lv
		if current_lv_sq < 0.1 : return # bail if it's still stopped
	
	# if the ball is stuck too vertically
	if current_lv_sq > (speed * MIN_HORIZONTAL_VELOCITY_RATIO * 0.5)**2 and abs(linear_velocity.x) < speed * MIN_HORIZONTAL_VELOCITY_RATIO and speed > 0:
		_nudge_ball(linear_velocity.x, NUDGE_TARGET_COMPONENT_RATIO, "x")
		
	# if the ball is stuck too horizontally
	if current_lv_sq > (speed * MIN_VERTICAL_VELOCITY_RATIO * 0.5)**2 and abs(linear_velocity.y) < speed * MIN_VERTICAL_VELOCITY_RATIO and speed > 0:
		_nudge_ball(linear_velocity.y, NUDGE_TARGET_COMPONENT_RATIO, "y")
	
	# length() gets the vector's speed
	if linear_velocity.length_squared() > max_speed * max_speed: #keep it under the max speed...
		print("It's going over the max speed, clamping to: ", str(max_speed))
		linear_velocity = linear_velocity.normalized() * max_speed #normalized() gets the direction only
	elif linear_velocity.length_squared() < speed * speed and linear_velocity.length_squared() > 0.01: #...but moving slower than TARGED SPEED
		linear_velocity = linear_velocity.normalized() * speed
		
	# get width of screen
	var viewport_width = get_viewport_rect().size.x
	
	# if it goes out to the left, score for right
	if global_position.x < 0:
		update_score("right")
		reset_ball()
	# if it goes out to the right, score for left
	elif global_position.x > viewport_width:
		update_score("left")
		reset_ball()
		
		
func reset_ball() -> void:
	#reset the speed and speed modifiers
	GameSettings.speed = initial_speed
	GameSettings.ball_speed_multiplier = 1.0
	
	_place_ball_at_center_and_stop()
	
	launch_delay_timer.start()
	


func _on_LaunchDelayTimer_timeout() -> void:
	# set launch direction with speed of 1
	var launch_direction = Vector2(1, randf_range(-0.5, 0.5)).normalized()
	
	# launch either left or right
	if randf() < 0.5:
		launch_direction.x *= -1
		
	# launch it
	apply_central_impulse(launch_direction * speed)
	print("Ball launched with target speed: ", str(speed))

func _place_ball_at_center_and_stop():
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0
	
	# move to center of screen
	position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)

# update the score and increase ball speed multiplier every hit
func update_score(scoring_player: String) -> void:
	if scoring_player == "left":
		print("Left scores!")
		left_score += 1
		left_score_label.text = str(left_score)
		#if score exceeds score to win, go to splash screen
		if left_score >= GameSettings.score_to_win :
			get_tree().change_scene_to_file("res://menus/winner_screen.tscn")
	elif scoring_player == "right":
		print("Right scores!")
		right_score += 1
		right_score_label.text = str(right_score)
		#if score exceeds score to win, go to splash screen
		if right_score >= GameSettings.score_to_win:
			get_tree().change_scene_to_file("res://menus/winner_screen.tscn")
		
	print("Score: Left ", left_score, " - Right ", right_score)

#nudge the ball, for if it's stuck going too horizontal or too vertical
#i think i need to figure stuff out if it's y...
func _nudge_ball(linear_velocity_size, velocity_ratio, direction) -> void:
	speed = GameSettings.speed
	print("Ball speed too low, ", str(linear_velocity_size), ", nudging. Target speed: ", str(speed))
	
	var nudge_direction = sign(linear_velocity_size)

	if nudge_direction == 0.0:
		nudge_direction = ([-1.0, 1.0][randi() % 2]) #pick a random direction in x
		
	# set min speed for x or y
	if direction == "x":
		linear_velocity.x = nudge_direction * speed * velocity_ratio
	elif direction == "y":
		linear_velocity.y = nudge_direction * speed * velocity_ratio
		
	# re-normalize to maintain target speed...
	linear_velocity = linear_velocity.normalized() * speed
	print("Nudged ball velocity: ", str(linear_velocity))
