extends Control

func _ready():
	var level_label = $Stats/LevelValLabel
	var current_lvl = str(SceneChanger.current_level)
	var max_levels = str(SceneChanger.max_levels)
	level_label.text = current_lvl + "/" + max_levels