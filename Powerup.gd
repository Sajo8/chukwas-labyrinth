extends Area2D

func _ready():
	$Effect.interpolate_property($Sprite, 'scale',
		$Sprite.get_scale(), Vector2(2, 2), 0.5,
		Tween.TRANS_QUAD, Tween.EASE_OUT)
	
	$Effect.interpolate_property($Sprite, 'modulate',
		get_modulate(), Color(0, 0, 0, 0), 0.5,
		Tween.TRANS_QUAD, Tween.EASE_OUT)

func _on_Powerup_body_entered(body):
	if body.get_name() == "Player":
		$Effect.start()

func _on_Effect_tween_completed(object, key):
	"""
	Still want to do something more with the powerup, not yet decided.
	"""
	queue_free()
