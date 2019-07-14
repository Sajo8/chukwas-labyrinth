extends Control

func _ready():
	# Connect signals for when player dies
	var player = get_tree().get_nodes_in_group("player")
	if player:
		player = player[0]
		player.connect("player_died", self, "_on_player_died")
		
func _on_player_died():
	
	$Popup.show()
	$Popup/MarginContainer/Buttons/HBoxContainer/RetryPauseButton.grab_focus()
