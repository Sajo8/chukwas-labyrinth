extends KinematicBody2D

export var speed = 150

signal hit_squasher(collision)
signal level_passed

var velocity
var player_is_immune = false

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

	# Disable any movement if the player died
	if Globals.player_dead:
		return

	velocity = get_input()
	velocity = velocity.normalized() * speed
	animate_player(velocity)
	move_and_slide(velocity)

	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "Squasher":
			emit_signal("hit_squasher", collision)

func _on_game_over():
	
	if player_is_immune:
		return
	
	set_physics_process(false)
	Globals.set("player_dead", true)
	
	# Squash the player into the void
	$AnimationPlayer.play("squash")
	
	# wait for animation to finish
	yield($AnimationPlayer, "animation_finished")

	$AnimationPlayer.stop(true)
	
	# Wait for 1s
	yield(get_tree().create_timer(1), "timeout")
	
	SceneChanger.go_to_scene("res://gui/LevelFailedMenu.tscn")

func _on_exit_entered():
	# Stop movement and animation
	set_physics_process(false)
	$AnimationPlayer.stop(true)

	# Save it now in case the player decides to quit to main menu
	Globals.save_next_level()
	SceneChanger.go_to_scene("res://gui/LevelPassedMenu.tscn")

func _on_powerup_grabbed(type):
	
	if type == 'turtleicon':
		# Stop movement and animation
		set_physics_process(false)
		$AnimationPlayer.stop(true)
		# emit_signal("level_passed")
		_on_exit_entered()
	elif type == 'apple':
		# Increase speed to 250 for 2 minutes
		speed = 250
		yield(get_tree().create_timer(120.0, false), "timeout")
		speed = 150
	elif type == 'watermelon':
		player_is_immune = true
		yield(get_tree().create_timer(120.0, false), "timeout")
		player_is_immune = false
	else:
		pass

func _ready():

	if Globals.player_dead: # Just respawned after dying

		# Show blinking animation
		$AnimationPlayer.play("respawn")
		# Wait for animation to finish playing
		yield($AnimationPlayer, "animation_finished")

		# No longer dead
		Globals.set("player_dead", false)

	# Connect signals for exits
	var exits = get_tree().get_nodes_in_group("exits")
	if exits:
		for exit in exits:
			exit.connect("exit_entered", self, "_on_exit_entered")

	# Connect signal for powerup
	var powerups = get_tree().get_nodes_in_group("powerup")
	if powerups:
		for powerup in powerups:
			powerup.connect("powerup_grabbed", self, "_on_powerup_grabbed")
		
	# Connect signals for traps
	var traps = get_tree().get_nodes_in_group("traps")
	if traps:
		for trap in traps:
			trap.connect("game_over", self, "_on_game_over")