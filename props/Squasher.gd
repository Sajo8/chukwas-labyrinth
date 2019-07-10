tool
extends KinematicBody2D

# Time between movements
const IDLE_DURATION = 2

# Distance it travels
export var move_amount = 80

onready var tween = $Tween

# Get x and y
onready var x = get_position().x
onready var y = get_position().y

# Set the starting position
onready var init_pos = Vector2(x, y)
# Set the position to move to
onready var move_to =  Vector2(x, (y - move_amount))

func _ready():
	var duration = 0.5
	
	# Interpolate properties going from bottom to top, then returning to bottom
	# See easings at https://easings.net
	# Bottom to Top goes fast and abrupt
	# Top to bottom goes slower and smoother
	
	tween.interpolate_property(self, "position", 
		init_pos, move_to, duration, 
		Tween.TRANS_CIRC, Tween.EASE_OUT, IDLE_DURATION)
	tween.interpolate_property(self, "position", 
		move_to, init_pos, duration, 
		Tween.TRANS_SINE, Tween.EASE_IN_OUT, duration + (IDLE_DURATION * 2))
	
	tween.start()