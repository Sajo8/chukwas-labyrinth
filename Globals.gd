extends Node

var player_dead = false
var number_of_coins = 0

func save_current_level():
	save_game(SceneChanger.current_level)

func save_next_level():
	var next_level = SceneChanger.current_level + 1
	if next_level >  SceneChanger.levels.size(): # Don't save if they just finished the max level
		return
	else:
		save_game(SceneChanger.current_level + 1)

func save_game(level_to_save):
	var save_dict = {
		"level": level_to_save, 
		"coins": number_of_coins
	}

	var save_game = File.new()

	save_game.open("user://savegame.trtl", File.WRITE)
	save_game.store_line(to_json(save_dict))

	save_game.close()

func load_save():
	var save_game = File.new()

	# Set level to 1 and quit if no save file exists
	if not save_game.file_exists("user://savegame.trtl"):
		SceneChanger.current_level = 1
		number_of_coins = 0
		save_game.close()
		return

	save_game.open("user://savegame.trtl", File.READ)
	var save_file = parse_json(save_game.get_line())
	
	var saved_level = int(save_file['level'])
	SceneChanger.current_level = saved_level
	
	var saved_coins = int(save_file['coins'])
	number_of_coins = saved_coins

	save_game.close()