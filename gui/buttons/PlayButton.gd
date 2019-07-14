extends Button

func _on_PlayButton_pressed():
	SceneChanger.go_to_level(SceneChanger.current_level)