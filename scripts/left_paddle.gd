extends CharacterBody2D

@export var speed: float = 300.0

func _physics_process(delta: float) -> void:
	var direction: float = 0.0
	
	#input for moving up with W
	if Input.is_action_pressed("move_up_left"):
		direction = -1.0
	#move down with S
	if Input.is_action_pressed("move_down_left"):
		direction = 1.0
		
	velocity = Vector2(0, direction * speed)
	
	#Move character + handle collisions
	
	move_and_slide()
	
	#clamp to stay within screen
	var screen_height = get_viewport_rect().size.y
	var half_paddle_height = 50.0
	if has_node("Sprite2D"):
		var sprite = get_node("Sprite2D")
		if sprite.texture != null:
			#if sprite height is available
			half_paddle_height = (sprite.texture.get_height() * sprite.scale.y) / 2.0
	
	position.y = clamp(position.y, half_paddle_height, screen_height - half_paddle_height)


func _on_paddle_detector_body_entered(body: PhysicsBody2D) -> void:
	if body is RigidBody2D and body.name == "Ball": #if it's the ball
		var ball_node = get_node("../Ball")
		if ball_node:
			ball_node._flash_paddle_green(self)
