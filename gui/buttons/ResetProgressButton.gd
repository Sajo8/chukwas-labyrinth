extends Button

func _on_ResetProgressButton_pressed():
	Globals.save_game(1)
	$AcceptDialog.show()

func _on_AcceptDialog_confirmed() -> void:
	grab_focus()
