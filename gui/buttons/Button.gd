extends Button

export(String, "EXCEPTION", "about", "quit", "main menu", "main menu pause",
	"next level", "options", "play", "reset progress", "cancel reset", "confirm reset",
	"resume pause", "retry") var button_mode = "EXCEPTION"

func _ready() -> void:
	if button_mode == "EXCEPTION":
		# print out name and location for debugging convenience
		print(name)

		# find number of "../" needed to reach the root node and get node using thjat
		# then print out its name and location
		# we have to do this because we don't know the name of the root node
		var path = ""
		for _i in range(0, get_position_in_parent()):
			path += "../"
		var root_node = get_node(path)
		print(root_node.name)
		print(root_node.filename)

		assert(button_mode != "EXCEPTION") # error out if no button mode has been set

	set_button_text()

# Sets the text of the button according to what mode it is set to
func set_button_text() -> void:
	match button_mode:
		"about":
			text = "About"

		"quit":
			text = "Save and Quit"

		"main menu":
			text = "Return to Main Menu"

		"main menu pause":
			text = "Return to Main Menu"

		"next level":
			text = "Continue to next level"

		"options":
			text = "Options"

		"play":
			text = "Play"
			self.grab_focus()

		"reset progress":
			text = "Reset all progress"

		"cancel reset":
			text = "Cancel"

		"confirm reset":
			text = "Confirm"

		"resume pause":
			text = "Resume game"

		"retry":
			text = "Retry level"

func _on_Control_pressed() -> void:
	match button_mode:
		"about":
			SceneChanger.go_to_scene("res://gui/screens/AboutScreen.tscn")

		"quit":
			Globals.save_current_level()
			get_tree().quit()

		"main menu":
			SceneChanger.go_to_scene("res://gui/screens/TitleScreen.tscn")

		"main menu pause":
			get_tree().paused = false
			Globals.set("player_dead", false)
			SceneChanger.go_to_scene("res://gui/screens/TitleScreen.tscn")

		"next level":
			SceneChanger.go_to_next_level()

		"options":
			SceneChanger.go_to_scene("res://gui/screens/OptionsScreen.tscn")

		"play":
			SceneChanger.go_to_level(SceneChanger.current_level)

		"reset progress":
			$ConfirmReset.show()

		"cancel reset":
			get_node("../../").visible = false
			get_node("../../../").grab_focus()

		"confirm reset":
			var save_game = File.new()
			Globals.reset_save(save_game)
			get_node("../../").visible = false
			get_node("../../../").grab_focus()

		"resume pause":
			var pause_node = find_parent("PauseMenu")
			pause_node.call("toggle_pause")

		"retry":
			SceneChanger.restart_level()
