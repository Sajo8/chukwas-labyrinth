extends Node

var player_dead = false

func save_game():
	# saves in
	# /home/sajo/.local/share/godot/app_userdata/maze
	# i installed thru steam so may be different
	
	# windows: (untested)
	# %APPDATA%\Godot\app_userdata\maze
	var save_dict = {
		"level": SceneChanger.current_level
	}

	var save_game = File.new()

	save_game.open("user://savegame.trtl", File.WRITE)
	save_game.store_line(to_json(save_dict))

	save_game.close()

func load_save():
	var save_game = File.new()

	# Set level to 1 and quit
	if not save_game.file_exists("user://savegame.trtl"):
		SceneChanger.current_level = 1
		save_game.close()
		return

	save_game.open("user://savegame.trtl", File.READ)
	var saved_level = parse_json(save_game.get_line())
	saved_level = int(saved_level['level'])
	SceneChanger.current_level = saved_level

	save_game.close()

