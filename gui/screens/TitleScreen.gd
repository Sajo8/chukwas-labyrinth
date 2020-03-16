extends Control

func _ready():
	# Maximise window
	OS.set_window_maximized(true)
	Globals.load_save()
