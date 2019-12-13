extends TextureRect

func _process(delta: float) -> void:
	# zoom out camera
	if $Camera2D.zoom.x < 4:
		$Camera2D.zoom.x += 0.01
		$Camera2D.zoom.y += 0.01
