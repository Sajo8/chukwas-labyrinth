extends TextureRect

func _process(_delta: float) -> void:
	# zoom out camera
	if $Camera2D.zoom.x <= 4:
		$Camera2D.zoom.x += 0.01
		$Camera2D.zoom.y += 0.01
	else:
		$Congrats.show();
		$Congrats2.show();
		$Button.grab_focus()
