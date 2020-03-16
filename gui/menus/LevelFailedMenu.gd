extends Control

func _ready():
	$Popup.show()
	$Popup/HBoxContainer/Retry.grab_focus()
