extends Area2D

signal coin_grabbed

func _ready():
	# Increase size
	$Effect.interpolate_property($Sprite, 'scale',
		$Sprite.get_scale(), Vector2(2, 2), 0.6,
		Tween.TRANS_CUBIC, Tween.EASE_OUT)
	# Fade out
	$Effect.interpolate_property($Sprite, 'modulate',
		Color(1, 1, 1, 1), Color(0, 0, 0, 0), 0.6,
		Tween.TRANS_LINEAR, Tween.EASE_OUT)

func _on_Coin_body_entered(body):
	if body.get_name() == "Player":
		# Remove the collision shapes to prevent extra collisions during the time the effect is taking place.
		shape_owner_clear_shapes(get_shape_owners()[0])
		$Effect.start()
		# Wait for effect to finish
		yield($Effect, "tween_completed")
		# Emit signal and get rid of coin
		queue_free()
		emit_signal("coin_grabbed")