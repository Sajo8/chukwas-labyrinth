extends Area2D

signal exit_entered

export var mirror_h = false

func _ready() -> void:
	$Sprite.flip_h = mirror_h

func _on_Stairs_body_entered(body):
	if body in get_tree().get_nodes_in_group("players"):
		emit_signal("exit_entered")
