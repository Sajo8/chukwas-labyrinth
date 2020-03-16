extends CanvasLayer

var levels = {
	1: "brown/Level1",
	2: "brown/Level2",
	3: "white/Level3",
	4: "white/Level4",
	5: "white/Level5",
	6: "yellow/Level6",
	7: "yellow/Level7",
}

var current_level = 1
var max_levels = levels.size()

func fade():
	$AnimationPlayer.play("fade")
	yield($AnimationPlayer, "animation_finished")

func go_to_level(new_level):

	if new_level > max_levels:
		go_to_end_screen()
		return

	fade()
	yield(get_tree().create_timer(0.55), "timeout")

	# Make new path for scene to be switched
	var new_level_path = "res://levels/" + levels[new_level] + ".tscn"
	# Switch scene
	get_tree().change_scene(new_level_path)
	# Switched scenes, let's update current level number
	current_level = new_level
	Globals.save_current_level()

func go_to_next_level():
	# Make temp var for next level
	var next_level = current_level + 1
	go_to_level(next_level)

func go_to_scene(scene_path):

	# We just finished the last level
	# We saved the next level already, so current level is one more than the number of levels we have
	# If that is so then end it!
	if SceneChanger.current_level > max_levels:
		go_to_end_screen()

	fade()
	yield(get_tree().create_timer(0.55), "timeout")

	get_tree().change_scene(scene_path)

func restart_level():
	fade()
	yield(get_tree().create_timer(0.55), "timeout")

	var failed_level_path = "res://levels/" + levels[current_level] + ".tscn"
	get_tree().change_scene(failed_level_path)

func go_to_end_screen():
	# Switch instantly, don't fade in or whatever
	get_tree().change_scene("res://gui/screens/EndScreen.tscn")
