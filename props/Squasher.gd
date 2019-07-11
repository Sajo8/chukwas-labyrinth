extends StaticBody2D

# Note:
# The tween glitches out at the beginning
# After going down and then up once (starts in fully extended position)
# It doesn't go down properly; abrupt goes up again from down position
# But doesn't happen again so whatever

# Node refs

onready var tween = $Tween

# Main column
onready var squasher = $Squasher
onready var squasher_collision = $SquasherCollisionShape

onready var original_squasher_collision_pos = squasher_collision.position
onready var squashed_squasher_collision_pos = Vector2(0, original_squasher_collision_pos.y + 48.75)

# Top-part of pillar
onready var squashertop = $SquasherTop
onready var squashertop_collision = $TopCollisionShape

# Where the top-part started out
onready var original_pos = squashertop.position
# Where the top-part will end up after the squasher shrinks
onready var squashed_pos = Vector2(0, original_pos.y + 98)

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
	
	# The pillar automatically scales from the top only because the pivot point has been set to the bottom-most point. No such option exists for a CollisionShape, so this exists
	# Change position of collisionshape so that it matches the actual column
	# Too high to proper height
	tween.interpolate_property(squasher_collision, "position", 
		original_squasher_collision_pos, squashed_squasher_collision_pos, duration,
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
	
	# The pillar automatically scales from the top only because the pivot point has been set to the bottom-most point. No such option exists for a CollisionShape, so this exists
	# Change position of collisionshape so that it matches the actual column
	# Too low to proper height
	tween.interpolate_property(squasher_collision, "position", 
		squashed_squasher_collision_pos, original_squasher_collision_pos, duration,
		Tween.TRANS_CIRC, Tween.EASE_OUT, idle_duration)


	# Change position of top portion to match
	tween.interpolate_property(squashertop, "position", 
		squashed_pos, original_pos, duration,
		Tween.TRANS_CIRC, Tween.EASE_OUT, idle_duration)
	
	tween.interpolate_property(squashertop_collision, "position", 
		squashed_pos, original_pos, duration,
		Tween.TRANS_CIRC, Tween.EASE_OUT, idle_duration)

	tween.start()