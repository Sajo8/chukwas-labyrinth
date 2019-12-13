extends Node

var player_dead = false
var number_of_coins = 0

var fish_available = 5
var fish_used = 0
var total_fish = fish_available + fish_used

var new_level;

func save_current_level():
	save_game(SceneChanger.current_level)

func save_next_level():
	new_level = SceneChanger.current_level + 1
	save_game(new_level)

func save_game(level_to_save):
	var save_dict = {
		"level": level_to_save,
		"coins": number_of_coins,
		"fish_available": fish_available,
		"fish_used": fish_used,
		"total_fish": total_fish
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
		fish_available = 5
		fish_used = 0
		total_fish = fish_available + fish_used
		save_game.close()
		return

	save_game.open("user://savegame.trtl", File.READ)
	var save_file = parse_json(save_game.get_line())

	var saved_coins = int(save_file['coins'])
	number_of_coins = saved_coins

	var saved_fish_available = int(save_file['fish_available'])
	fish_available = saved_fish_available

	var saved_fish_used = int(save_file['fish_used'])
	fish_used = saved_fish_used

	var saved_total_fish = int(save_file['total_fish'])
	total_fish = saved_total_fish

	var saved_level = int(save_file['level'])
	SceneChanger.current_level = saved_level
#	if saved_level > SceneChanger.current_level:
#		save_game.close()
#		SceneChanger.go_to_end_screen()
	save_game.close()


