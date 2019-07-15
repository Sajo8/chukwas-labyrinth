extends Area2D

signal powerup_grabbed(type)

func _on_Watermelon_body_entered(body):
	if body.get_name() == "Player":
		emit_signal("powerup_grabbed", 'watermelon')
		queue_free()
