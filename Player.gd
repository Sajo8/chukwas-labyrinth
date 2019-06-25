extends KinematicBody2D

func _physics_process(delta):
	var moveBy = Vector2(0,0)

	if Input.is_key_pressed(KEY_LEFT):
		moveBy.x -= 1
	if Input.is_key_pressed(KEY_RIGHT):
		moveBy.x += 1
	if Input.is_key_pressed(KEY_UP):
		moveBy.y -= 1
	if Input.is_key_pressed(KEY_DOWN):
		moveBy.y += 1

	if moveBy.length() > 0:
		moveBy = moveBy.normalized() * 5

	self.move_and_collide(moveBy)