extends Control

func _ready():
	# Maximise window
	OS.set_window_maximized(true)
	$Menu/CenterRow/LeftRow/Buttons/PlayButton.grab_focus()
	Globals.load_save()
