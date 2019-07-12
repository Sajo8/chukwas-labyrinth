extends KinematicBody2D

export var speed = 200

signal hit_squasher(collision)

var game_over
var velocity

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
	var velocity_angle = velocity.angle()
	# Convert it to degrees
	velocity_angle = rad2deg(velocity_angle)
	# Add 90 degrees since otherwise it treats going right as 0 degrees
	velocity_angle = velocity_angle + 90
	
	# If we're moving, change rotation
	if velocity.length() >= 1:
		$Sprite.rotation_degrees = velocity_angle
	
	if velocity_length >= 1:
		# If moving in any direction, play walk animation.
		$AnimationPlayer.play("walk")
	else:
		# Not moving, idle anim
		$AnimationPlayer.play("idle")

func _physics_process(delta):
	if Globals.game_over: # Don't do anything if the player died
		return
	
	velocity = get_input()
	velocity = velocity.normalized() * speed
	animate_player(velocity)
	move_and_slide(velocity)
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		emit_signal("hit_squasher", collision)

func _on_game_over():
	# Squash the player into the void
	$AnimationPlayer.play("squash")
	
	# Turn off input and wait for animation to finish
	Globals.set("game_over", true)
	yield($AnimationPlayer, "animation_finished")
	
	# Wait for 2s
	yield(get_tree().create_timer(2), "timeout")
	# Restart scene
	get_tree().reload_current_scene()

func _on_exit_entered():
	SceneChanger.go_to_next_level()

func _ready():
	
	if Globals.game_over: # Just respawned after dying
		# Blink the player to let them know they died
		$AnimationPlayer.play("blink")
		# Wait for animation to finish playing
		yield($AnimationPlayer, "animation_finished")
		
		# Take input again
		Globals.set("game_over", false)
	
	# Connect signals for traps
	var traps = get_tree().get_nodes_in_group("traps")
	for trap in traps:
		trap.connect("game_over", self, "_on_game_over")
	
	# Connect signals for exits
	var exits = get_tree().get_nodes_in_group("exits")
	for exit in exits:
		exit.connect("exit_entered", self, "_on_exit_entered")
