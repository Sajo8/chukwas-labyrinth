extends KinematicBody2D

export var speed = 200

func get_input():
	# Detect up/down/left/right keystate and only move when pressed
	var velocity = Vector2(0,0)
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1

	return velocity

func animate_player(velocity):
	var velocity_length = velocity.length()
	
	if velocity_length == 1:
		
		if velocity.x == 1:
			# Going right
			$Sprite.rotation_degrees = 90
		if velocity.x == -1:
			# Going left
			$Sprite.rotation_degrees = 270
		
		if velocity.y == 1:
			# Going down
			$Sprite.rotation_degrees = 180
		if velocity.y == -1:
			# Going up
			$Sprite.rotation_degrees = 0
		
	else:
		if velocity_length > 1:
			# Only do something if we're actually moving; ignore a velocity_length of 0
			if velocity.x == -1:
				# Going left
				if velocity.y == -1:
					# Going to top left
					$Sprite.rotation_degrees = 315
				if velocity.y == 1:
					# Going to bottom left
					$Sprite.rotation_degrees = 225
			else:
				# Going right
				if velocity.y == -1:
					# Going to top right
					$Sprite.rotation_degrees = 45
				if velocity.y == 1:
					# Going to bottom right
					$Sprite.rotation_degrees = 135
	
	if velocity_length >= 1:
		$Sprite/AnimationPlayer.play("walk")
	else:
		$Sprite/AnimationPlayer.play("idle")

func _physics_process(delta):
	var velocity = get_input()
	animate_player(velocity)
	velocity = velocity.normalized() * speed
	move_and_slide(velocity)