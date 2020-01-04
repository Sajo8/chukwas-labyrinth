extends Control

func _ready():
	if Globals.new_level > SceneChanger.max_levels:
		SceneChanger.go_to_end_screen()
	$Popup.show()
	$Popup/MarginContainer/Buttons/HBoxContainer/NextLevelButton.grab_focus()