extends CanvasLayer

onready var animation_player = $AnimationPlayer

var levels = {
	1: "dirt/Level1",
	2: "dirt/Level2",
	3: "stone/Level3",
	4: "stone/Level4",
	5: "stone/Level5",
}

var current_level = 1
var max_levels = levels.size()

func fade(from_end):
	animation_player.play("fade")
	if from_end:
		animation_player.play_backwards("fade")

func fade_out():
	fade(false)
	yield(animation_player, "animation_finished")

func fade_in():
	fade(true)
	yield(animation_player, "animation_finished")

func go_to_level(new_level):
	# Prevent going any further if we're already at the highest level there is
	if new_level > max_levels:
		return
	fade_out()
	# Make new path for scene to be switched
	var new_level_path = "res://levels/" + levels[new_level] + ".tscn"
	# Switch scene
	get_tree().change_scene(new_level_path)
	# Switched scenes, let's update current level number
	current_level = new_level
	fade_in()
	Globals.save_current_level()

func go_to_next_level():
	# Make temp var for next level
	var next_level = current_level + 1
	go_to_level(next_level)

func go_to_scene(scene_path):
	fade_out()
	get_tree().change_scene(scene_path)
	fade_in()

func restart_level():
	fade_out()
	var failed_level_path = "res://levels/" + levels[current_level] + ".tscn"
	get_tree().change_scene(failed_level_path)
	fade_in()