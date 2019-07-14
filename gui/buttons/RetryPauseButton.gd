extends Button

func _on_RetryPauseButton_pressed():
	get_tree().reload_current_scene()
