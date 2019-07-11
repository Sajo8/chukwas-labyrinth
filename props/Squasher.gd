extends KinematicBody2D

# Node refs

onready var tween = $Tween

# Main column
onready var squasher = $Squasher
onready var squasher_collision = $SquasherCollisionShape

# Top-part of pillar
onready var squashertop = $SquasherTop
onready var squashertop_collision = $TopCollisionShape

# Where the top-part started out
onready var original_pos = squashertop.position
# Where the top-part will end up after the squasher shrinks
onready var squashed_pos = Vector2(0, original_pos.y + 49)

func _ready():
	
	shrink_squasher()
	yield(tween, "tween_completed")
	maximise_squasher()
	yield(tween, "tween_completed")

func shrink_squasher():
	
	var idle_duration = 3
	var duration = 2

	# Reduce size of column    
	tween.interpolate_property(squasher, "scale", 
		Vector2(1.0, 1.0), Vector2(1.0, 0.1), duration,
		Tween.TRANS_SINE, Tween.EASE_IN_OUT, idle_duration)
	
	tween.interpolate_property(squasher_collision, "scale", 
		Vector2(1.0, 1.0), Vector2(1.0, 0.1), duration,
		Tween.TRANS_SINE, Tween.EASE_IN_OUT, idle_duration)


	# Change position of top portion to match
	tween.interpolate_property(squashertop, "position", 
		original_pos, squashed_pos, duration,
		Tween.TRANS_SINE, Tween.EASE_IN_OUT, idle_duration)
	
	tween.interpolate_property(squashertop_collision, "position", 
		original_pos, squashed_pos, duration,
		Tween.TRANS_SINE, Tween.EASE_IN_OUT, idle_duration)

	tween.start()

func maximise_squasher():
	
	var idle_duration = 1.5
	var duration = 0.5
	
	# Increase size of column    
	tween.interpolate_property(squasher, "scale", 
		null, Vector2(1.0, 1.0), duration,
		Tween.TRANS_CIRC, Tween.EASE_OUT, idle_duration)
	
	tween.interpolate_property(squasher_collision, "scale", 
		null, Vector2(1.0, 1.0), duration,
		Tween.TRANS_CIRC, Tween.EASE_OUT, idle_duration)


	# Change position of top portion to match
	tween.interpolate_property(squashertop, "position", 
		squashed_pos, original_pos, duration,
		Tween.TRANS_CIRC, Tween.EASE_OUT, idle_duration)
	
	tween.interpolate_property(squashertop_collision, "position", 
		squashed_pos, original_pos, duration,
		Tween.TRANS_CIRC, Tween.EASE_OUT, idle_duration)

	tween.start()