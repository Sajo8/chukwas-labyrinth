extends Control

func _ready():
	$Menu/CenterRow/Buttons/PlayButton.grab_focus()
	Globals.load_save()