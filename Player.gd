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
	print(velocity)
	print(velocity_length)
	if velocity_length >= 1:
		$Sprite/AnimationPlayer.play("walk")
	else:
		$Sprite/AnimationPlayer.play("idle")

func _physics_process(delta):
	var velocity = get_input()
	animate_player(velocity)
	velocity = velocity.normalized() * speed
	move_and_slide(velocity)