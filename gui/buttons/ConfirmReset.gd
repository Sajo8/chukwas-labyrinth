extends WindowDialog

func _on_ConfirmReset_visibility_changed():
	$HBoxContainer/Cancel.grab_focus()