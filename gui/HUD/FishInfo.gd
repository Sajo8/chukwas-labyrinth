extends Control

var label_text
onready var label = $GenericSmallLabel

func _ready() -> void:
	var player = get_tree().get_nodes_in_group("players")
	if player:
		player = player[0]
		print(player)
		player.connect("fish_placed", self, "_on_fish_placed")

	label_text = "Remaining Fish: " + str(Globals.fish_available)
	# Assign new text
	label.text = label_text

func _on_fish_placed(position):
	# Make full text
	label_text = "Remaining Fish: " + str(Globals.fish_available)

	# Assign new text
	label.text = label_text