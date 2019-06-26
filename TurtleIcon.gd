extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite/AnimationPlayer.play("Rotating TurtleCoin Icon")

func _on_Area2D_body_entered(body):
	queue_free()

"""
Still want to do something more with the powerup, not yet decided.
"""