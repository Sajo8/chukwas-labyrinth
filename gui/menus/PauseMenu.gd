extends Control

func pause_or_unpause():
	if get_tree().paused:
		$Popup.hide()
	else:
		$Popup.show()
		$Popup/MarginContainer/Buttons/HBoxContainer/ResumeButton.grab_focus()
	get_tree().paused = !get_tree().paused

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		pause_or_unpause()