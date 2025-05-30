extends StaticBody2D

@export var base_speed: float = 500.0
@export var speed: float = base_speed

@export var min_y_position: float = 20.0
@export var max_y_position: float = 700.0

# paddle textures
const normal_texture: Texture2D = preload("res://assets/sprites/paddle.png") # normal texture
const flash_texture: Texture2D = preload("res://assets/sprites/paddle_hit.png") #the green flash on hit

var is_flashing : bool = false

@onready var flash_timer: Timer = Timer.new() # timer for the flash

@onready var sprite: Sprite2D = $Sprite2D #just refer to the sprite

func _ready() -> void:
	# first check texture
	if sprite and normal_texture:
		sprite.texture = normal_texture
	else:
		printerr("Paddle: Sprite node or normal_texture not assigned correctly")
		
	# internal timer configuration
	flash_timer.wait_time = 0.1 # flash duration
	flash_timer.one_shot = true # only do it once
	flash_timer.timeout.connect(_on_flash_timer_timeout)
	add_child(flash_timer)
	

func _physics_process(delta: float) -> void:
	
	var direction: float = 0.0
	
	#input for moving up with W
	if GameSettings.game_mode == "Player vs Player":
		if Input.is_action_pressed("move_up_right"):
			direction = -1.0
		#move down with S
		if Input.is_action_pressed("move_down_right"):
			direction = 1.0
	
	elif GameSettings.game_mode == "Player vs Computer":
		smart_move()
	
	if direction != 0:
		var new_y = position.y + (direction * speed * delta)
		
		#clamp to stay within screen
		var screen_height = get_viewport_rect().size.y
		var half_paddle_height = 50.0
		if sprite and sprite.texture != null:
				#if sprite height is available
				half_paddle_height = (sprite.texture.get_height() * sprite.scale.y) / 2.0
		position.y = clamp(new_y, half_paddle_height, screen_height - half_paddle_height)

func smart_move() -> void:
	return
	#implement ai
	
	
func attempt_flash() -> void:
	if is_flashing:
		print("Paddle: Flash requested but it's flashing")
		return # do nothing
	
	if not sprite or not flash_texture or not normal_texture:
		printerr("Paddle: cannot flash - sprite or textures not configured")
	
	print("Paddle: starting flash")
	is_flashing = true
	sprite.texture = flash_texture
	flash_timer.start()

func _on_flash_timer_timeout() -> void:
	if sprite and normal_texture:
		print ("Paddle: flash finished, reverting texture")
		sprite.texture = normal_texture
	is_flashing = false

func _on_paddle_detector_body_entered(body: PhysicsBody2D) -> void:
	print("collision detected! Body", body.name, " at time: ", Time.get_ticks_msec())
	if body is RigidBody2D and body.name == "Ball": #if it's the ball
		print("collision detected with right paddle, trying to flash, increasing speed")
		#increase the ball's speed
		GameSettings.ball_speed_multiplier += 0.05
		GameSettings.speed *= GameSettings.ball_speed_multiplier
		print("speed increased, new speed: ", GameSettings.speed)
		attempt_flash() #try to flash
	else:
		print("Type: ", body.get_class(), " Name: ", body.name)
