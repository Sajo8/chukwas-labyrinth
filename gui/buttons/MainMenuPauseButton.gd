extends Button

func _on_MainMenuButton_pressed():
	get_tree().paused = false
	Globals.set("player_dead", false)
	SceneChanger.go_to_scene("res://gui/screens/TitleScreen.tscn")
