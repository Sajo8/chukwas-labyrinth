extends Button

func _on_PlayButton_pressed():
	print(SceneChanger.current_level)
	SceneChanger.go_to_level(SceneChanger.current_level)