extends KinematicBody2D

func _physics_process(delta):
	var moveBy = Vector2(0,0)

	if Input.is_key_pressed(KEY_LEFT):
		moveBy = Vector2(-5, 0)
	if Input.is_key_pressed(KEY_RIGHT):
		moveBy = Vector2(5, 0)
	if Input.is_key_pressed(KEY_UP):
		moveBy = Vector2(0, -5)
	if Input.is_key_pressed(KEY_DOWN):
		moveBy = Vector2(0, 5)

	self.move_and_collide(moveBy)