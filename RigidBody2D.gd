extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var impulsePoint = Vector2(0.0, $CollisionShape2D.shape.extents.y/2)

	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		apply_impulse(impulsePoint, Vector2(0, -10))
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		apply_impulse(impulsePoint, Vector2(0, 10))

func _on_RigidBody2D_body_entered(body):
	print("Collision with " + body.get_name())
