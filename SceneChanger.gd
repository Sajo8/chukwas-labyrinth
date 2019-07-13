extends CanvasLayer

onready var animation_player = $AnimationPlayer

var levels = {
	1: "dirt/level1",
	2: "GenericLevels/GenericDirtLevel",
	3: "GenericLevels/GenericStoneLevel",
	4: "GenericLevels/GenericDiamondLevel",
	5: "GenericLevels/GenericEmeraldLevel"
}

var current_level = 1

func fade_out():
	animation_player.play("fade")

func fade_in():
	animation_player.play_backwards("fade")

func go_to_level(new_level):
	# Prevent going any further if we're already at the highest level there is
	if current_level == levels.size():
		return
		
	fade_out()
	yield(animation_player, "animation_finished")
	
	# Make new path for scene to be switched
	var new_level_path = "res://levels/" + levels[new_level] + ".tscn"
	# Switch scene
	assert(get_tree().change_scene(new_level_path) == OK)
	
	# Switched scenes, let's update current level number
	current_level = new_level
	
	fade_in()
	yield(animation_player, "animation_finished")

func go_to_next_level():

	# Make temp var for next level
	var next_level = current_level + 1
	
	go_to_level(next_level)