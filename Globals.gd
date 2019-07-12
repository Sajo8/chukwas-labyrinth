extends Node

var game_over = false
onready var fade_scene = preload("res://Fade.tscn").instance()

var levels = {
	1: "GenericLevels/GenericDirtLevel",
	2: "GenericLevels/GenericStoneLevel",
	3: "GenericLevels/GenericDiamondLevel",
	4: "GenericLevels/GenericEmeraldLevel"
}

var current_level = 1
var new_level = current_level

func go_to_next_level():
	# Prevent going any further if we're already at the highest level there is
	if current_level == levels.size():
		return
	
	# Increment level counter
	new_level += 1
	
	# Fade out and wait for it to finish
	get_parent().add_child(fade_scene)
	yield(fade_scene, "finished")
	
	# Generate path for next level
	var new_level_path = "res://levels/" + levels[new_level] + ".tscn"
	
	# Fade in to new scene
	# Doesn't really work(??)
	fade_scene.fade_in = true
	get_parent().add_child(fade_scene)
	
	# Switch scenes
	get_tree().change_scene(new_level_path)

func go_to_level(level_no):
	# Prevent going any further if we're already at the highest level there is
	if new_level == levels.size():
		return
	
	# Make new path for scene to be switched
	var new_level_path = "res://levels/" + levels[level_no] + ".tscn"
	
	# Switch scene
	get_tree().change_scene(new_level_path)