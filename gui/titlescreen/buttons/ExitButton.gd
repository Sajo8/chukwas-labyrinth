extends Button

func _on_ExitButton_pressed():
	Globals.save_game()
	get_tree().quit()
