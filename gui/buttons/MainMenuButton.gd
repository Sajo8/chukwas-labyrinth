extends Button

func _on_MainMenuButton_pressed():
	get_tree().paused = false
	SceneChanger.go_to_scene("res://gui/TitleScreen.tscn")	