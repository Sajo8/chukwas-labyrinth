extends Control

func _ready() -> void:
	$Apple.hide()
	$Watermelon.hide()
	$GreenApple.hide()

	var powerups = get_tree().get_nodes_in_group("powerups")
	if powerups:
		for powerup in powerups:
			powerup.connect("powerup_grabbed", self, "_on_powerup_grabbed")

func _on_powerup_grabbed(type):
	if type == "apple":
		$Apple.show()
		yield(get_tree().create_timer(120, false), "timeout")
		$Apple.hide()
	elif type == "watermelon":
		$Watermelon.show()
		yield(get_tree().create_timer(120, false), "timeout")
		$Watermelon.hide()
	elif type == "green_apple":
		$GreenApple.show()
		yield(get_tree().create_timer(120, false), "timeout")
		$GreenApple.hide()
