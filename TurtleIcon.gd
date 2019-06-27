extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# Start rotating the icon immediately
	$Sprite/AnimationPlayer.play("Rotating TurtleCoin Icon")

func _on_Area2D_body_entered(body):
	# When the coin is hit, get rid of it
	"""
	Still want to do something more with the powerup, not yet decided.
	"""
	queue_free()