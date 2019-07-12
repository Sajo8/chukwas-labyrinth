extends Area2D

signal exit_entered

func _on_Stairs_body_entered(body):
	if body in get_tree().get_nodes_in_group("player"):
		emit_signal("exit_entered")
