extends Control

var label_content
onready var text_label = $Label

func _ready() -> void:
	var player = get_tree().get_nodes_in_group("players")
	if player:
		player = player[0]
		player.connect("fish_placed", self, "_on_fish_placed")

	label_content = "Remaining Fish: " + str(Globals.fish_available)
	# Assign new text
	text_label.set_text(label_content)

func _on_fish_placed(_position):
	# Make full text
	label_content = "Remaining Fish: " + str(Globals.fish_available)

	# Assign new text
	text_label.set_text(label_content)
