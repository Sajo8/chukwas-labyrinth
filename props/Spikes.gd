extends Area2D

signal game_over

func _on_Spikes_body_entered(body):
	if body.name == "Player":
		emit_signal("game_over")
