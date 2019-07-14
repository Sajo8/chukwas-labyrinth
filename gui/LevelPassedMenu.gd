extends Control

func _ready():
	var player = get_tree().get_nodes_in_group("player")[0]
	if player:
		player.connect("level_passed", self, "_on_level_passed")
		
func _on_level_passed():
	
	# Save it now incase they switch to main menu
	Globals.save_next_level()
	
	$Popup.show()
	$Popup/MarginContainer/Buttons/HBoxContainer/NextLevelButton.grab_focus()