extends Control

func _ready():
	$Popup.show()
	$Popup/MarginContainer/Buttons/HBoxContainer/NextLevelButton.grab_focus()