extends Button

func _on_ExitButton_pressed():
	Globals.save_current_level()
	get_tree().quit()
