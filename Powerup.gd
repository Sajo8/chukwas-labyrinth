extends Area2D

func _on_Area2D_body_entered(body):
	# When the coin is hit, get rid of it
	"""
	Still want to do something more with the powerup, not yet decided.
	"""
	queue_free()