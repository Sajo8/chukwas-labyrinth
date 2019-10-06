extends KinematicBody2D

export var speed = 150

signal hit_squasher(collision)
signal level_passed
signal fish_placed(position)

var velocity
var player_is_immune = false
var player_powerups = []

var fish_scene = preload("res://props/Fish.tscn")
var fish_nodes = {}

var coins_grabbed_in_level = 0
var new_fish_available = 0

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

	if Input.is_action_just_pressed("ui_select"):
		emit_signal("fish_placed", get_global_position())

	return velocity

func animate_player(velocity):
	var velocity_length = velocity.length()
	var velocity_angle = velocity.angle()
	# Convert it to degrees
	velocity_angle = rad2deg(velocity_angle)
	# Add 90 degrees since otherwise it treats going right as 0 degrees
	velocity_angle = velocity_angle + 90

	# If we're moving, change rotation
	if velocity_length >= 1:
		$Sprite.rotation_degrees = velocity_angle
		$CollisionPolygon2D.rotation_degrees = velocity_angle

	if player_powerups.size() >= 1:
		if velocity_length >= 1:
			# If moving in any direction, play walk animation.
			$AnimationPlayer.play("powerup_walk")
		else:
			# Not moving, idle anim
			$AnimationPlayer.play("powerup_idle")
	else:
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

	# Set the position of each fish every frame so that they don't move around with the player
	for node in fish_nodes:
		var global_pos = fish_nodes.get(node)
		node.set_global_position(global_pos)

func blink_player():

	set_physics_process(false)

	# Show blinking animation
	$AnimationPlayer.play("respawn")
	# Wait for animation to finish playing
	yield($AnimationPlayer, "animation_finished")

	set_physics_process(true)

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

	SceneChanger.go_to_scene("res://gui/menus/LevelFailedMenu.tscn")

func _on_timer_timeout():
	var small_light = preload("res://assets/tinylightcircle.png")

	if player_is_immune:
		return

	blink_player()

	$Light2D.set_texture(small_light)

func _on_level_passed():
	# Stop movement and animation
	set_physics_process(false)
	$AnimationPlayer.stop(true)

	Globals.number_of_coins += coins_grabbed_in_level
	Globals.fish_available += new_fish_available

	# Save it now in case the player decides to quit to main menu
	Globals.save_next_level()
	SceneChanger.go_to_scene("res://gui/menus/LevelPassedMenu.tscn")

func _on_exit_entered():
	emit_signal("level_passed")

func _on_powerup_grabbed(type):

	if type == 'comfy':
		emit_signal("level_passed")

	elif type == 'apple':
		# Increase speed to 250 for 2 minutes
		speed = 250
		player_powerups.append("apple")

		yield(get_tree().create_timer(120.0, false), "timeout")

		speed = 150
		var list_index = player_powerups.find("apple")
		player_powerups.remove(list_index)

	elif type == 'watermelon':
		player_is_immune = true
		player_powerups.append("watermelon")

		yield(get_tree().create_timer(120.0, false), "timeout")

		player_is_immune = false
		var list_index = player_powerups.find("watermelon")
		player_powerups.remove(list_index)
	else:
		pass

func _on_coin_grabbed():

	# Every 3 coins is one fish

	coins_grabbed_in_level += 1

	if coins_grabbed_in_level % 3 == 0:
		new_fish_available += 1
		coins_grabbed_in_level -= 3

func _on_fish_placed(position):
	# Don't do anything if no more fish left
	if Globals.fish_available < 1:
		return
	# Add node and global position to a dict to be used later
	var fish_node = fish_scene.instance()
	fish_nodes[fish_node] = position
	add_child(fish_node)

	Globals.fish_available -= 1
	Globals.fish_used += 1
	Globals.total_fish += 1

func _ready():

	if Globals.player_dead: # Just respawned after dying

		blink_player()
		# No longer dead
		Globals.set("player_dead", false)

	# Connect signals for exits
	var exits = get_tree().get_nodes_in_group("exits")
	if exits:
		for exit in exits:
			exit.connect("exit_entered", self, "_on_exit_entered")

	# Connect signal for powerups
	var powerups = get_tree().get_nodes_in_group("powerups")
	if powerups:
		for powerup in powerups:
			powerup.connect("powerup_grabbed", self, "_on_powerup_grabbed")

	var coins = get_tree().get_nodes_in_group("coins")
	if coins:
		for coin in coins:
			coin.connect("coin_grabbed", self, "_on_coin_grabbed")

	# Connect signals for traps
	var traps = get_tree().get_nodes_in_group("traps")
	if traps:
		for trap in traps:
			trap.connect("game_over", self, "_on_game_over")

	var timer = get_tree().get_nodes_in_group("timers")
	if timer:
		timer = timer[0]
		timer.connect("timer_timeout", self, "_on_timer_timeout")

	self.connect("level_passed", self, "_on_level_passed")

	self.connect("fish_placed", self, "_on_fish_placed")