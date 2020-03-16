extends Control

func toggle_pause():
	if get_tree().paused:
		$Popup.hide()
	else:
		$Popup.show()
		$Popup/HBoxContainer/Resume.grab_focus()

	get_tree().paused = !get_tree().paused

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()
