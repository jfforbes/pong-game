extends RigidBody2D

#the green paddle flash
const FLASH_TEXTURE = preload("res://assets/sprites/paddle_hit.png")

@export var initial_speed: float = 400.0 #initial speed
@export var speed: float = initial_speed #setting speed to initial speed
@export var max_speed: float = 800.0 #max speed

var left_score: int = 0 #initial score for left side
var right_score: int = 0 #initial score for right

#getting score labels
@onready var left_score_label = get_node("../../CanvasLayer/LeftScoreLabel")
@onready var right_score_label = get_node("../../CanvasLayer/RightScoreLabel")

func _ready() -> void:
	randomize() #ensuring random number
	
	reset_ball() #reset the ball
	
func _physics_process(delta: float) -> void:
	
	# length() gets the vector's speed
	if linear_velocity.length() > max_speed: #keep it under the max speed...
		linear_velocity = linear_velocity.normalized() * max_speed #normalized() gets the direction only
	elif linear_velocity.length() < initial_speed: #...but above the initial speed
		linear_velocity = linear_velocity.normalized() * initial_speed
	
	# make sure it doesn't get stuck vertically
	if abs(linear_velocity.x) <  50: # if horizontal speed is low
		linear_velocity.x = sign(linear_velocity.x) * speed * 0.5 #horizontal push in current direction
		# now it needs a vertical nudge
		linear_velocity.y += randf_range(-50, 50)
		linear_velocity = linear_velocity.normalized() * linear_velocity.length()
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
	# reset linear and angular velocities
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0
	
	# move to center of screen
	position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)
	
	await get_tree().create_timer(1.0).timeout #wait 1 sec
	
	# set launch direction with speed of 1
	var launch_direction = Vector2(1, randf_range(-0.5, 0.5)).normalized()
	
	# launch either left or right
	if randf() < 0.5:
		launch_direction.x *= -1
		
	# launch it
	apply_central_impulse(launch_direction * speed)

# update the score and increase ball speed multiplier every hit
func update_score(scoring_player: String) -> void:
	if scoring_player == "left":
		left_score += 1
		left_score_label.text = str(left_score)
		GameSettings.ball_speed_multiplier += 0.1
		#setting the speed
		speed *= GameSettings.ball_speed_multiplier
	elif scoring_player == "right":
		right_score += 1
		right_score_label.text = str(right_score)
		GameSettings.ball_speed_multiplier += 0.1
		#setting the speed
		speed *= GameSettings.ball_speed_multiplier
		
	print("Score: Left ", left_score, " - Right ", right_score)

#flash paddle green
func _flash_paddle_green(paddle: CharacterBody2D) -> void:
	var sprite = paddle.get_node("Sprite2D")
	if sprite: 
		var original_texture = sprite.texture
		
		sprite.texture = FLASH_TEXTURE
		
		#rever it after a delay
		var timer = Timer.new()
		paddle.add_child(timer)
		timer.wait_time = 0.1
		timer.one_shot = true
		
		timer.timeout.connect(func(): 
			if is_instance_valid(sprite):
				sprite.texture = original_texture
				timer.queue_free()
		)
		timer.start()
			
