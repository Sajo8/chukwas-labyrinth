extends Button

var pause_menu_node

func _ready():
	pause_menu_node = get_node("../../../../../.")

func _on_ResumeButton_pressed():
	pause_menu_node.pause_or_unpause()
