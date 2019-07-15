extends Control

func _ready():
	$Popup.show()
	$Popup/MarginContainer/Buttons/HBoxContainer/RetryPauseButton.grab_focus()
