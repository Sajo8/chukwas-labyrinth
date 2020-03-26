extends Control

func toggle_pause():
	if get_tree().paused:
		$Popup.hide()
	else:
		$Popup.show()
		$Popup/HBoxContainer/Resume.grab_focus()

	get_tree().paused = not get_tree().paused

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func _notification(what: int) -> void:
	if what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		if not get_tree().paused:
			toggle_pause()
