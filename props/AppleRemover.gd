extends Area2D

signal powerup_grabbed(type)

func _ready():
	# Increase size
	$Effect.interpolate_property($Sprite, 'scale',
		$Sprite.get_scale(), Vector2(0, 0), 0.6,
		Tween.TRANS_CUBIC, Tween.EASE_OUT)
	# Fade out
	$Effect.interpolate_property($Sprite, 'modulate',
		Color(1, 1, 1, 1), Color(0, 0, 0, 0), 0.6,
		Tween.TRANS_LINEAR, Tween.EASE_OUT)

func _on_Effect_tween_completed(object, key):
	queue_free()
	emit_signal("powerup_grabbed", 'apple_remover')

func _on_AppleRemover_body_entered(body: Node) -> void:
	if body.get_name() == "Player":
		# Remove the collision shapes to prevent extra collisions during the time the effect is taking place.
		shape_owner_clear_shapes(get_shape_owners()[0])
		$Effect.start()
