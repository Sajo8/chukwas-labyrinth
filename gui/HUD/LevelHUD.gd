extends Control

func _ready():
	var level_label = $Stats/LevelVal
	var current_lvl = str(SceneChanger.current_level)
	var max_levels = str(SceneChanger.max_levels)
	level_label.text = current_lvl + "/" + max_levels
